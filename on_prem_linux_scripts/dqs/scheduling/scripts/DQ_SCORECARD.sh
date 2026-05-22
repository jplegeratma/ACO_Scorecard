#!/bin/bash
#-- DQ SCORECARD MONTHLY Load - Workflow execution and MV build
#-- Borrowed from the PDM Weekly load scripts

#Unlike the PDM script which run against PowerCenter, these script run against the IDQ Developer, so they use infacmd.sh vs pmcmd
#The main commands are like:
#infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_CLMTYP -wf WKF_INF_B_DA_MNTH_MCO_CLMTYP -pf DA_PARAMETERS.xml
#infacmd.sh wfs listActiveWorkflowInstances -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS
#infacmd.sh wfs abortWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -iid "${fn}" > /dev/null`

#SC_RUN_DATE may by exported in the run_DQ_SCORECARD. If it is set then it overrides the date set in the BATCH table in step 1

#TO DO
#-- add start and stop to all workflows
#-- fill in step 1 stop jobs
# multiple snapshots in same tables
# purge steps
# stats step
# more error handling


script_name="DQ_SCORECARD.sh"

# common shell functions
. ../functions.sh

# Constants
USAGE="Usage: DQ_SCORECARD.sh -U <dw schema> -P <dw schema_password> -d <SID> -i <informatica server> -f <informatica folder> [-s <step number>]"

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
    *     ) echo "Error: (DQ_SCORECARD.sh) Unknown switch $Option"
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
    run_sql_fg upd_sc_batch_start.sql
    if [ $? -gt 0 ]
        then
                echo "SC Start Batch failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed -
 SC Start Batch failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) SC Start Batch completed at: `date` "
        popd > /dev/null
        step_2
}

step_2 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    set_run_date (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_run_date ()
{
        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

#echo "lgrd_db_connect_str: $lgrd_db_connect_str"

    if [ -n "$SC_RUN_DATE" ]
    then
        # Overwrite the value in the nw_params table
        local query="update INF_B_DQ_PARAMS set PARAM_VALUE = '${SC_RUN_DATE}' where PARAM_NAME = 'SC_RUN_DATE'";
                                                                                                                                         local lora_error=`process_sql "${lgrd_db_connect_str}" "${query}"`
                                                                                                                                         # Check for any sql errors
        local ora_error=`echo $lora_error | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi  
    fi                                                                                                                      

        step_3

}

step_3 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_run_date (db_connect_string)
# Notes:   Taken from function get_run_date
# lazy - just get the RUN_DATE howerver it was set
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#get_run_date ()
{

        # Get the run date from dw_params table
        local query="select param_value from INF_B_DQ_PARAMS where param_name = 'SC_RUN_DATE'"

        lgrd_run_date=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 lgrd_run_date=`date +%Y%m%d`
        fi

        # Echo the run date - so that the caller gets the run date result
        echo "$lgrd_run_date"

        step_4
}

step_4 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_offset (db_connect_string)
# Notes:   Taken from function get_run_date
# lazy - just get the RUN_DATE howerver it was set
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#get_offest ()
{
        # Get the run date from dw_params table
        local query="select param_value from INF_B_DQ_PARAMS where param_name = 'SC_RUN_DATE_TO_MAX_OFFSET_MNTHS'"
        OFFSET=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 lgrd_run_date=`date +%Y%m%d`
        fi

        # Echo the run date - so that the caller gets the run date result
        echo "$lgrd_run_date"

        step_5
}

step_5 ()
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
        local query="select param_value from INF_B_DQ_PARAMS where param_name = 'SC_BATCH_SEQ'"

        lgrd_batch_seq=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lgrd_batch_seq | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        # Echo the run date - so that the caller gets the run date result
        echo "$lgrd_batch_seq"

        step_6
}

step_6 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    set_SC_MON (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_SC_MON ()
{

        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="UPDATE INF_B_DQ_PARAMS SET param_value = TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR('${lgrd_run_date}',1,6),'YYYYMM'), - (TO_NUMBER('${OFFSET}','99') + 3)), 'MONYYYY') || '_' || TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR('${lgrd_run_date}',1,6),'YYYYMM'), - TO_NUMBER('${OFFSET}','99')), 'MONYYYY') WHERE param_name = 'SC_MON'";

        echo ${query}

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
# Name:    set_SC_MIN_DOS (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_SC_MIN_DOS ()
{

        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="UPDATE INF_B_DQ_PARAMS SET param_value = TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR('${lgrd_run_date}',1,6),'YYYYMM'), - (TO_NUMBER('${OFFSET}','99') + 3)), 'YYYYMMDD') WHERE param_name = 'SC_MIN_DOS'";

        echo ${query}

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
# Name:    set_SC_MAX_DOS (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#set_SC_MAX_DOS ()
{

        # Local variables
        local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

        # Get the run date from dw_params table
        local query="UPDATE INF_B_DQ_PARAMS SET param_value = TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR('${lgrd_run_date}',1,6),'YYYYMM'), - TO_NUMBER('${OFFSET}','99')), 'YYYYMMDD') WHERE param_name = 'SC_MAX_DOS'";

        echo ${query}

        local lora_error=`process_sql "${lgrd_db_connect_str}" "${query}"`

        # Check for any sql errors
        local ora_error=`echo $lora_error | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
        if [ -n "${ora_error}" ]
        then
                 echo "${ora_error}"
        fi

        step_9
}

step_9 ()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    write_SC_PARAM_FILE (db_connect_string)
# Notes:   Taken from function get_run_date
# This may be written as a function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#write_SC_PARAM_FILE ()
{

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<root xmlns=\"http://www.informatica.com/Parameterization/1.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema\" version=\"2.0\">
    <project name=\"b_DW_Monitoring_Project\">
        <folder name=\"MCE_Encounter_Scorecard_SQLs\">
            <mapping name=\"MCO_MBHP_DOS_Pull\">
                <parameter name=\"SC_BATCH_SEQ\">${lgrd_batch_seq}</parameter>
                <parameter name=\"SC_RUN_DATE\">${lgrd_run_date}</parameter>
                <parameter name=\"SC_RUN_DATE_TO_MAX_OFFSET_MNTHS\">${OFFSET}</parameter>
                <parameter name=\"TABLE_MON\">b_DW_Monitoring_Project/MCE_Encounter_Scorecard_SQLs/RelationalDataObject:MCO_MBHP_DOS_SEP2018_DEC2018</parameter>
            </mapping>
        </folder>
    </project>
</root>" > $SC_PARAM_FILE

        step_11
#        step_51
}


step_11 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBHP_DOS Workflow: WKF_INF_B_SC_MCO_MBHP_DOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBHP_DOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBHP_DOS -wf WKF_INF_B_SC_MCO_MBHP_DOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBHP_DOS completed at: `date` "
            sleep 20
            step_12
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 11 failed - APP_INF_B_SC_MCO_MBHP_DOS failed "
            error_msg_ex  " step 11, executing APP_INF_B_SC_MCO_MBHP_DOS "
        fi

}

step_12 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_TOTREX Workflow: WKF_INF_B_SC_MCO_MBH_TOTREX
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_TOTREX"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_TOTREX -wf WKF_INF_B_SC_MCO_MBH_TOTREX -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_TOTREX completed at: `date` "
            sleep 20
            step_13
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 12 failed - APP_INF_B_SC_MCO_MBH_TOTREX failed "
            error_msg_ex  " step 12, executing APP_INF_B_SC_MCO_MBH_TOTREX "
        fi

}

step_13 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_TDOS Workflow: WKF_INF_B_SC_MCO_MBH_TDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_TDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_TDOS -wf WKF_INF_B_SC_MCO_MBH_TDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_TDOS completed at: `date` "
            sleep 20
            step_14
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 13 failed - APP_INF_B_SC_MCO_MBH_TDOS failed "
            error_msg_ex  " step 13, executing APP_INF_B_SC_MCO_MBH_TDOS "
        fi

}

step_14 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_FLDREX Workflow: WKF_INF_B_SC_MCO_MBH_FLDREX
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_FLDREX"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_FLDREX -wf WKF_INF_B_SC_MCO_MBH_FLDREX -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_FLDREX completed at: `date` "
            sleep 20
            step_15
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 14 failed - APP_INF_B_SC_MCO_MBH_FLDREX failed "
            error_msg_ex  " step 14, executing APP_INF_B_SC_MCO_MBH_FLDREX "
        fi

}

step_15 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_FRDOS Workflow: WKF_INF_B_SC_MCO_MBH_FRDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_FRDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_FRDOS -wf WKF_INF_B_SC_MCO_MBH_FRDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_FRDOS completed at: `date` "
            sleep 20
            step_16
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 15 failed - APP_INF_B_SC_MCO_MBH_FRDOS failed "
            error_msg_ex  " step 15, executing APP_INF_B_SC_MCO_MBH_FRDOS "
        fi

}

step_16 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_PCNT Workflow: WKF_INF_B_SC_MCO_MBH_PCNT
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_PCNT"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_PCNT -wf WKF_INF_B_SC_MCO_MBH_PCNT -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_PCNT completed at: `date` "
            sleep 20
            step_17
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 16 failed - APP_INF_B_SC_MCO_MBH_PCNT failed "
            error_msg_ex  " step 16, executing APP_INF_B_SC_MCO_MBH_PCNT "
        fi

}

step_17 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_PCTDOS Workflow: WKF_INF_B_SC_MCO_MBH_PCTDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_PCTDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_PCTDOS -wf WKF_INF_B_SC_MCO_MBH_PCTDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_PCTDOS completed at: `date` "
            sleep 20
            step_18
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 17 failed - APP_INF_B_SC_MCO_MBH_PCTDOS failed "
            error_msg_ex  " step 17, executing APP_INF_B_SC_MCO_MBH_PCTDOS "
        fi

}

step_18 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_TPDOS Workflow: WKF_INF_B_SC_MCO_MBH_TPDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_TPDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_TPDOS -wf WKF_INF_B_SC_MCO_MBH_TPDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_TPDOS completed at: `date` "
            sleep 20
            step_19
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 18 failed - APP_INF_B_SC_MCO_MBH_TPDOS failed "
            error_msg_ex  " step 18, executing APP_INF_B_SC_MCO_MBH_TPDOS "
        fi

}

step_19 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_FRPDOS Workflow: WKF_INF_B_SC_MCO_MBH_FRPDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_FRPDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_FRPDOS -wf WKF_INF_B_SC_MCO_MBH_FRPDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_FRPDOS completed at: `date` "
            sleep 20
            step_20
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 19 failed - APP_INF_B_SC_MCO_MBH_FRPDOS failed "
            error_msg_ex  " step 19, executing APP_INF_B_SC_MCO_MBH_FRPDOS "
        fi

}

step_20 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_PTPDOS Workflow: WKF_INF_B_SC_MCO_MBH_PTPDOS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_PTPDOS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_PTPDOS -wf WKF_INF_B_SC_MCO_MBH_PTPDOS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_PTPDOS completed at: `date` "
            sleep 20
            step_21
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 20 failed - APP_INF_B_SC_MCO_MBH_PTPDOS failed "
            error_msg_ex  " step 20, executing APP_INF_B_SC_MCO_MBH_PTPDOS "
        fi

}

step_21 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE Workflow: WKF_INF_B_SC_MCO_MBH_REP_TRANSPOSE
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_REP_TRANSPOSE"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE -wf WKF_INF_B_SC_MCO_MBH_REP_TRANSPOSE -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE completed at: `date` "
            sleep 20
            step_22
#            step_51
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 21 failed - APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE failed "
            error_msg_ex  " step 21, executing APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE "
        fi

}

step_22 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_REP_STEP1 Workflow: WKF_INF_B_SC_MCO_MBH_REP_STEP1
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_REP_STEP1"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_REP_STEP1 -wf WKF_INF_B_SC_MCO_MBH_REP_STEP1 -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_REP_STEP1 completed at: `date` "
            sleep 20
            step_23
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 22 failed - APP_INF_B_SC_MCO_MBH_REP_STEP1 failed "
            error_msg_ex  " step 22, executing APP_INF_B_SC_MCO_MBH_REP_STEP1 "
        fi

}

step_23 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBH_REP_STEP2 Workflow: WKF_INF_B_SC_MCO_MBH_REP_STEP2
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBH_REP_STEP2"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBH_REP_STEP2 -wf WKF_INF_B_SC_MCO_MBH_REP_STEP2 -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_REP_STEP2 completed at: `date` "
            sleep 20
            step_31
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 23 failed - APP_INF_B_SC_MCO_MBH_REP_STEP2 failed "
            error_msg_ex  " step 23, executing APP_INF_B_SC_MCO_MBH_REP_STEP2 "
        fi

}

step_31 ()
{
    ########## Run Application: APP_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET Workflow: WKF_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET -wf WKF_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET completed at: `date` "
            sleep 20
            step_31s
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 31 failed - APP_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET failed "
            error_msg_ex  " step 31, executing APP_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET "
        fi

}

step_31s ()
{
    ########## Check PURGE tables complete
    # This is called 31 because it is sleeping for 31
    echo "Info: ($script_name) Executing MAPPLET sleep"

    success_code="1"
# loop 60 times - 1 hour
    cntr="60"
    cnt="1"

    local lgrd_db_connect_str="${DW_USER}/${DW_PASS}@${DW_SID}"

    while [[ "$success_code" -ne 0 && "$cnt" -le "$cntr" ]]
    do

        # Check if done
        local query="SELECT TO_CHAR((b.COMP),'9') FROM
(SELECT CASE WHEN STATUS = 'Complete' THEN 0 ELSE 1 END AS COMP FROM INF_B_DQ_LOAD_BATCH WHERE PROGRAM_NAME = 'WKF_INF_B_SC_MCO_MBHP_PTPDOS_MAPPLET' AND PARENT_BATCH_SEQ = TO_NUMBER('${lgrd_batch_seq}','999999')) b "

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
            echo "Info: ($script_name) Check MAPPLET sleep done completed at: `date` "
            sleep 20
            step_32
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 31s failed - MAPPLET sleep "
            error_msg_ex  " step 31s, executing MAPPLET sleep "
        fi
}

step_32 ()
{
    ########## Run Application: APP_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE Workflow: WKF_INF_B_SC_MCO_MBH_REP_TRANSPOSE
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE -wf WKF_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_MCO_MBH_REP_TRANSPOSE completed at: `date` "
            sleep 20
            step_33
#            step_51
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 32 failed - APP_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE failed "
            error_msg_ex  " step 32, executing APP_INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE "
        fi

}

step_33 ()
{
    ########## Run Application: APP_INF_B_SC_STG_MCO_MBH_REP_STEP1 Workflow: WKF_INF_B_SC_STG_MCO_MBH_REP_STEP1
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_STG_MCO_MBH_REP_STEP1"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_STG_MCO_MBH_REP_STEP1 -wf WKF_INF_B_SC_STG_MCO_MBH_REP_STEP1 -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_STG_MCO_MBH_REP_STEP1 completed at: `date` "
            sleep 20
            step_34
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 33 failed - APP_INF_B_SC_STG_MCO_MBH_REP_STEP1 failed "
            error_msg_ex  " step 33, executing APP_INF_B_SC_STG_MCO_MBH_REP_STEP1 "
        fi

}

step_34 ()
{
    ########## Run Application: APP_INF_B_SC_STG_MCO_MBH_REP_STEP2 Workflow: WKF_INF_B_SC_STG_MCO_MBH_REP_STEP2
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_STG_MCO_MBH_REP_STEP2"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_STG_MCO_MBH_REP_STEP2 -wf WKF_INF_B_SC_STG_MCO_MBH_REP_STEP2 -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_STG_MCO_MBH_REP_STEP2 completed at: `date` "
            sleep 20
            step_35
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 34 failed - APP_INF_B_SC_STG_MCO_MBH_REP_STEP2 failed "
            error_msg_ex  " step 34, executing APP_INF_B_SC_STG_MCO_MBH_REP_STEP2 "
        fi

}

step_35 ()
{
    ########## Run Application: APP_INF_B_SC_STG_MCO_MBH_REP_STEP3 Workflow: WKF_INF_B_SC_STG_MCO_MBH_REP_STEP3
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_STG_MCO_MBH_REP_STEP3"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_STG_MCO_MBH_REP_STEP3 -wf WKF_INF_B_SC_STG_MCO_MBH_REP_STEP3 -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_STG_MCO_MBH_REP_STEP3 completed at: `date` "
            sleep 20
            step_36
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 35 failed - APP_INF_B_SC_STG_MCO_MBH_REP_STEP3 failed "
            error_msg_ex  " step 35, executing APP_INF_B_SC_STG_MCO_MBH_REP_STEP3 "
        fi

}

step_36 ()
{
    ########## Run Application: APP_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS Workflow: WKF_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS
    echo "Info: ($script_name) Executing Workflow  - WKF_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS"

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
            infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS -wf WKF_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS -pf SC_PARAMETERS.xml

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
            echo "Info: ($script_name) APP_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS completed at: `date` "
            sleep 20
            step_51
       else
            send_email "${email_recepient}" "Error in ($script_name)" "step 36 failed - APP_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS failed "
            error_msg_ex  " step 36, executing APP_INF_B_SC_STG_MCO_MBH_REP_TIMELINESS "
        fi

}



step_51 ()
{

    pushd ../../sql/dbupdate > /dev/null

    #~~~~~~~~ End the Batch  
    echo "Info: ($script_name) Ending the Batch"
    run_sql_fg upd_sc_batch_end.sql
    if [ $? -gt 0 ]
        then
                echo "SC End Batch failed at: `date` "
                send_email "${email_recepient}" "DEV - Error in ($script_name)" "DEV - Error in ($script_name). Step 1 failed -
 SC End Batch failed. Script Halted."
                exit 1
        fi

        echo "Info: ($script_name) SC End Batch completed at: `date` "
        popd > /dev/null
#       step_2
}


# = = = = = = = = = = = =  M A I N

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
    "20" )      step_20 ;;
    "21" )      step_21 ;;
    "22" )      step_22 ;;
    "23" )      step_23 ;;
    "51" )      step_51 ;;
     *  ) echo "$USAGE";;
esac  # jump to a particular point in script

echo "DQ SCORECARD Informatica Job completed successfully."
send_email "${email_recepient}" "($script_name) is done" "DQ SCORECARD Informatica Job completed successfully."
echo "Info: ($script_name) DQ SCORECARD Monthly Load -- Completed at: `date` "
echo "Info: ($script_name) Check out the log file:  $LOG_FILE "
