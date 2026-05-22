#!/bin/bash
#-- DQ ANOMALY MONTHLY Load - Workflow execution and MV build
#-- Borrowed from the PDM Weekly load scripts

#Unlike the PDM script which run against PowerCenter, these script run against the IDQ Developer, so they use infacmd.sh vs pmcmd    
#The main commands are like:
#infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_CLMTYP -wf WKF_INF_B_DA_MNTH_MCO_CLMTYP -pf DA_PARAMETERS.xml
#infacmd.sh wfs listActiveWorkflowInstances -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS
#infacmd.sh wfs abortWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -iid "${fn}" > /dev/null`


#TO DO
# purge steps
# stats step
# more error handling


script_name="DQ_ANOMALY.sh"

# common shell functions
. ../functions.sh

# Constants
USAGE="Usage: DQ_ANOMALY.sh -U <dw schema> -P <dw schema_password> -d <SID> -i <informatica server> -f <informatica folder> [-s <step number>]"

email_recepient="JP.Leger@mass.gov"


# source the application constants
if [ -x $DQBINHOME/application.sh ]
then
    . $DQBINHOME/application.sh
else
    echo "Error: ($script_name) cannot execute \$DQBINHOME/application.sh (file not found or not executable)" 1>&2
    exit 1
fi

# check input parameters
if [ $# -lt "1" -a $# -gt "14" ]  # Script invoked without enough command-line args?
then
    echo "Error: ($script_name) you must supply all arguments except -s <step number>, which is optional" 2>&1
    echo "$USAGE"  1>&2
    exit 1
fi

batch_step=0

while getopts ":U:P:d:u:p:i:f:s:" Option
do
  case $Option in
    U     ) DW_USER=$OPTARG;;
    P     ) DW_PASS=$OPTARG;;
    d     ) DW_SID=$OPTARG;;
    u     ) INF_USER=$OPTARG;;
    p     ) INF_PASS=$OPTARG;;
    i     ) INF_SERVER=$OPTARG;;
    f     ) INF_FOLDER=$OPTARG;;
    s     ) batch_step=$OPTARG;;
    *     ) echo "Error: (DQ_ANOMALY.sh) Unknown switch $Option"
            echo "$USAGE"
            exit 1;;
  esac
done
shift $(($OPTIND - 1))

# = = = = = = = = = = = =  V A R I A B L E S .

# = = = = = = = = = = = =  F U N C T I O N S  .
step_0 ()
{


    ########## Stop any workflows that might already be running.
    echo "Info: ($script_name) Stopping any Workflows that were already running."
#   In testing this doesn't always stop the jobs even though the comands are accepted? I don;t expect this to be needed. ' 

#    for fn in `infacmd.sh wfs listActiveWorkflowInstances -dn domain_dev -sn INFA_DIS -un jleger -pd ChangeMe | grep Running | cut -d' ' -f22`; do echo "killing ${fn}";     `infacmd.sh wfs abortWorkflow -dn domain_dev -sn INFA_DIS -un jleger -pd ChangeMe -iid "${fn}"`; done


    for fn in `infacmd.sh wfs listActiveWorkflowInstances -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS | grep Running | cut -d' ' -f22`; do echo "killing ${fn}";     `infacmd.sh wfs abortWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -iid "${fn}" > /dev/null`; done

    echo "Info: ($script_name) Stop of currently running workflows done at: `date` "

    sleep 20
    step_1
}

step_1 ()
{

    pushd ../../sql/dbupdate > /dev/null

    #~~~~~~~~ Start the Batch  
    echo "Info: ($script_name) Starting the Batch"
    run_sql_fg upd_da_batch_start.sql
    if [ $? -gt 0 ]
        then
                echo "DA Start Batch failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed -
 DA Start Batch failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) DA Start Batch completed at: `date` "
        popd > /dev/null
        step_2
}

step_2 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_run_date (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#get_run_date ()
{
        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

#echo "lgrd_db_connect_str: $lgrd_db_connect_str"

        # Get the run date from dw_params table
        local query="select param_value from INF_B_DQ_PARAMS where param_name = 'DA_RUN_DATE'"

        lgrd_run_date=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 lgrd_run_date=`date +%Y%m%d`
        fi

        # Echo the run date - so that the caller gets the run date result
        echo "$lgrd_run_date"

        step_3
}

step_3 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_batch_seq (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#get_batch_seq ()
{
        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="select param_value from INF_B_DQ_PARAMS where param_name = 'DA_BATCH_SEQ'"

        lgrd_batch_seq=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_batch_seq | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        # Echo the run date - so that the caller gets the run date result
        echo "$lgrd_batch_seq"

        step_4
}

step_4 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    calc_DA_MIN_DOS 
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#calc_DA_MIN_DOS ()
{
        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Calc the MIN date as first day 3 years ago - what is set in params 
# Switching back to using full years vs 36 months because we are using full years in Viz

local query="SELECT TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE('${lgrd_run_date}','YYYYMMDD'),'YEAR'),DA_PULL_START_YRS_BACK * 12),'YYYYMMDD') FROM ( SELECT - (TO_NUMBER(PARAM_VALUE, '999')) AS DA_PULL_START_YRS_BACK FROM INF_B_DQ_PARAMS WHERE PARAM_NAME = 'DA_PULL_START_YRS_BACK' )"

#local query="SELECT TO_CHAR(TRUNC(ADD_MONTHS(TRUNC(TO_DATE('${lgrd_run_date}','YYYYMMDD'),'MONTH'), DA_PULL_START_MNTHS_BACK)),'YYYYMMDD') FROM (SELECT - (TO_NUMBER(a.PARAM_VALUE) + TO_NUMBER(b.PARAM_VALUE) + TO_NUMBER(c.PARAM_VALUE) ) AS DA_PULL_START_MNTHS_BACK FROM INF_B_DQ_PARAMS a,INF_B_DQ_PARAMS b,INF_B_DQ_PARAMS c WHERE a.PARAM_NAME='DA_PULL_END_MNTHS_BACK' AND b.PARAM_NAME='DA_REVIEW_MNTHS' AND c.PARAM_NAME='DA_ROLL_WIN_MNTHS')"

        #echo "query min: $query"

        DA_MIN_DOS=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        # Echo the MIN DOS - so that the caller gets the run date result
        echo "DA_MIN_DOS: ${DA_MIN_DOS}"

        step_5
}

step_5 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    calc_DA_MAX_DOS
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#calc_DA_MAX_DOS ()
{
        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Calc the MAX date as last day of 3 month ago - what is set in params

        local query="SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(TO_DATE('${lgrd_run_date}','YYYYMMDD'),'MONTH'), DA_PULL_END_MNTHS_BACK)),'YYYYMMDD') FROM ( SELECT - (TO_NUMBER(PARAM_VALUE, '999')) AS DA_PULL_END_MNTHS_BACK FROM INF_B_DQ_PARAMS WHERE PARAM_NAME = 'DA_PULL_END_MNTHS_BACK' )"

        #echo "query max: $query"

        DA_MAX_DOS=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        # Echo the MAX DOS - so that the caller gets the run date result
        echo "DA_MAX_DOS: ${DA_MAX_DOS}"

        step_6
}

step_6 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    set_DA_MIN_DOS (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_DA_MIN_DOS ()
{

        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="update INF_B_DQ_PARAMS set PARAM_VALUE = '${DA_MIN_DOS}' where PARAM_NAME = 'DA_MIN_DOS'";

        local lora_error=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lora_error | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        step_7
}

step_7 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    set_DA_MAX_DOS (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_DA_MAX_DOS ()
{

        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="update INF_B_DQ_PARAMS set PARAM_VALUE = '${DA_MAX_DOS}' where PARAM_NAME = 'DA_MAX_DOS'";

        local lora_error=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lora_error | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

         step_8
}

step_8 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    write_DA_PARAM_FILE (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#write_DA_PARAM_FILE ()
{

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<root xmlns=\"http://www.informatica.com/Parameterization/1.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema\" version=\"2.0\">
    <project name=\"b_DW_Monitoring_Project\">
        <folder name=\"DI_Anomaly_Scorecards_v1_9\">
            <workflow name=\"WKF_INF_B_DA_MNTH_MCO_ACO_BASE\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_MCO_ACO_BASE</parameter>
                <parameter name=\"step_num\">11</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_MCO_ACO_BASE</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE</parameter>
                <parameter name=\"step_num\">12</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_MCO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">13</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">14</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">15</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">16</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">17</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
            <workflow name=\"WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9\">
                <parameter name=\"DA_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"DA_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"DA_MIN_DOS\">${DA_MIN_DOS}</parameter>
                <parameter name=\"DA_MAX_DOS\">${DA_MAX_DOS}</parameter>
                <parameter name=\"program_name\">WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"step_num\">18</parameter>
                <parameter name=\"table_name\">INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9</parameter>
                <parameter name=\"project_name\">DA</parameter>
            </workflow>
        </folder>
    </project>
</root>" > $DA_PARAM_FILE

        step_9
#        step_51
}

step_9 ()
{

    pushd ../../sql/dbupdate > /dev/null

    #~~~~~~~~ Purge tables
    echo "Info: ($script_name) Purging tables"
    run_sql_fg DA_PURGE_v1_9.sql
    if [ $? -gt 0 ]
        then
                echo "DA Purge tables failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed - DA Purge tables failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) DA Purge tables completed at: `date` "
        popd > /dev/null
        step_10
}

step_10 ()
{
    ########## Check PURGE tables complete
    # This is called 8 (vs 8s) because I don't care about the naming here
    echo "Info: ($script_name) Executing PURGE tables complete"

    success_code="1"
# loop 60 times - 1 hour
    cntr="60"
    cnt="1"

    local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

    while [[ "$success_code" -ne 0 && "$cnt" -le "$cntr" ]]
    do

        # Check if done
        local query="SELECT TO_CHAR((b.COMP),'9') FROM
(SELECT CASE WHEN STATUS = 'Complete' THEN 0 ELSE 1 END AS COMP FROM INF_B_DQ_LOAD_BATCH WHERE PROGRAM_NAME = 'PURGE_TABLES' AND PARENT_BATCH_SEQ = TO_NUMBER('${lgrd_batch_seq}','999999')) b "

        success_code=`process_sql "${lgrd_db_connect_str}" "${query}"`
echo "success_code: ${success_code}"

        # Check for any sql errors
        local ora_error=`echo $lgrd_batch_seq | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
                 # stop the loop
                 cnt='expr $cntr + 1'
        else
            cnt=`expr $cnt + 1`
            sleep 60
        fi
     echo "COUNTER: ${cnt}"
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) Check PURGE tables done completed at: `date` "
            sleep 20
            step_11
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 8 failed - PURGE tables complete "
            error_msg_ex  " step 8, executing PURGE tables complete "
        fi
}

step_11 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_MCO_ACO_BASE Workflow: WKF_INF_B_DA_MNTH_MCO_ACO_BASE
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_MCO_ACO_BASE"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_ACO_BASE -wf WKF_INF_B_DA_MNTH_MCO_ACO_BASE -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_MCO_ACO_BASE completed at: `date` "
            sleep 20
            step_12
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 11 failed - INF_B_DA_MNTH_MCO_ACO_BASE failed "
            error_msg_ex  " step 11, executing APP_INF_B_DA_MNTH_MCO_ACO_BASE "
        fi

}

step_12 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE Workflow: WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE -wf WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE completed at: `date` "
            sleep 20
            step_12s
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 12 failed - INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE failed
 "
            error_msg_ex  " step 12, executing APP_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE "
        fi

}

step_12s ()
{
    ########## Check BASE jobs complete
    # This is called 12s vs 13 so the jobs in this section will show up in succession in the Load Batch table
    echo "Info: ($script_name) Executing Check BASE jobs complete"

    success_code="1"
# loop 60 times - 1 hour
    cntr="60"
    cnt="1"

    local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

    while [[ "$success_code" -ne 0 && "$cnt" -le "$cntr" ]]
    do

        # Check if done
        local query="SELECT TO_CHAR((a.COMP + b.COMP),'9') FROM  
(SELECT CASE WHEN STATUS = 'Complete' THEN 0 ELSE 1 END AS COMP FROM INF_B_DQ_LOAD_BATCH WHERE PROGRAM_NAME = 'WKF_INF_B_DA_MNTH_MCO_ACO_BASE' AND PARENT_BATCH_SEQ = TO_NUMBER('${lgrd_batch_seq}','999999')) a, 
(SELECT CASE WHEN STATUS = 'Complete' THEN 0 ELSE 1 END AS COMP FROM INF_B_DQ_LOAD_BATCH WHERE PROGRAM_NAME = 'WKF_INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE' AND PARENT_BATCH_SEQ = TO_NUMBER('${lgrd_batch_seq}','999999')) b "

        success_code=`process_sql "${lgrd_db_connect_str}" "${query}"`
echo "success_code: ${success_code}"

        # Check for any sql errors
        local ora_error=`echo $lgrd_batch_seq | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
                 # stop the loop
                 cnt='expr $cntr + 1'
        else
            cnt=`expr $cnt + 1`
            sleep 60
        fi
     echo "COUNTER: ${cnt}"
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) Check BASE jobs done completed at: `date` "
            sleep 20
            step_13
#        step_51
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 12s failed - Check BASE jobs complete "
            error_msg_ex  " step 12s, executing Check BASE jobs complete "
        fi
}

step_13 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_MCO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_MCO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 completed at: `date` "
            sleep 20
            step_14
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 13 failed - APP_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 13, executing APP_INF_B_DA_MNTH_MCO_CLMTYP_v1_9 "
        fi

}

step_14 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml 

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 completed at: `date` "
            sleep 20
            step_15
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 14 failed - INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 14, executing APP_INF_B_DA_MNTH_MCO_ACO_CLMTYP_v1_9 "
        fi

}

step_15 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 completed at: `date` "
            sleep 20
            step_16
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 15 failed - INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 15, executing APP_INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP_v1_9 "
        fi

}

step_16 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 completed at: `date` "
            sleep 20
            step_17
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 16 failed - INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 16, executing APP_INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP_v1_9 "
        fi

}

step_17 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 completed at: `date` "
            sleep 20
            step_18
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 17 failed - INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 17, executing APP_INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP_v1_9 "
        fi

}


step_18 ()
{
    ########## Run Application: APP_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9 Workflow: WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9 -wf WKF_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9 -pf DA_PARAMETERS.xml

            if [ $? -gt 0 ]
            then
                    success_code="1"
            else
                success_code="0"
            fi

            cnt=`expr $cnt + 1`
    done

    if [ "$success_code" -eq 0 ]
       then
            echo "Info: ($script_name) APP_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP completed at: `date` "
            sleep 20
            step_41
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 18 failed - INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9 failed "
            error_msg_ex  " step 18, executing APP_INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP_v1_9 "
        fi

}

step_41 ()
{

    pushd ../../sql/dbupdate > /dev/null

    #~~~~~~~~ Gather Stats
    echo "Info: ($script_name) Gather Stats"
    run_sql_fg DA_STATS_v1_9.sql
    if [ $? -gt 0 ]
        then
                echo "DA Gather Stats failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed - DA Gather Stats failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) Gather Stats tables completed at: `date` "
        popd > /dev/null
        step_42
}

step_42 ()
{

    pushd ../../sql/ddl > /dev/null

    #~~~~~~~~ Run Grants
    echo "Info: ($script_name) Run Grants"
    run_sql_fg DA_GRANTS_v1_9.sql
    if [ $? -gt 0 ]
        then
                echo "DA Run Grants failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed - DA Run Grants failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) Run Grants tables completed at: `date` "
        popd > /dev/null
        step_51
}

step_51 ()
{

    pushd ../../sql/dbupdate > /dev/null

    #~~~~~~~~ End the Batch  
    echo "Info: ($script_name) Ending the Batch"
    run_sql_fg upd_da_batch_end.sql
    if [ $? -gt 0 ]
        then
                echo "DA End Batch failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed -
 DA End Batch failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) DA End Batch completed at: `date` "
        popd > /dev/null
#       step_2
}


# = = = = = = = = = = = =  M A I N
# only putting in start points for the detail and agg steps, and the Stats

case "$batch_step" in
    "0" )      step_0 ;;
    "11" )      step_11 ;;
    "12" )      step_12 ;;
    "13" )      step_13 ;;
    "14" )      step_14 ;;
    "15" )      step_15 ;;
    "16" )      step_16 ;;
    "17" )      step_17 ;;
    "18" )      step_18 ;;
    "19" )      step_19 ;;
    "41" )      step_41 ;;
    "51" )      step_51 ;;
     *  ) echo "$USAGE";;
esac  # jump to a particular point in script

echo "DQ ANOMALY Informatica Job completed successfully."
send_email "${email_recepient}" "($script_name) is done" "DQ ANOMALY Informatica Job completed successfully."
echo "Info: ($script_name) DQ ANOMALY Monthly Load -- Completed at: `date` "
echo "Info: ($script_name) Check out the log file:  $LOG_FILE "
