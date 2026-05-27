#!/bin/bash
#-- PDM Weekly Load - Workflow execution and MV build

script_name="PDM_Load_V4.sh"

# common shell functions
. ../functions.sh

# Constants
USAGE="Usage: PDM_Load_VX.sh -U <dw schema> -P <dw schema_password> -d <SID> -i <informatica server> -f <informatica folder> [-s <step number>]"
email_recepient="Poornima.m.malladi@massmail.state.ma.us"


# source the application constants
if [ -x $PDMBINHOME/application.sh ]
then
    . $PDMBINHOME/application.sh
else
    echo "Error: ($script_name) cannot execute \$PDMBINHOME/application.sh (file not found or not executable)" 1>&2
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
    *     ) echo "Error: (Daily_Prov_MF_Staging_Load.sh) Unknown switch $Option"
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
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_pdm_ufr
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_pdm_provr_adr_stg
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_PD_CIW_VENDOR_BUS_TYPE
    #pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_PR_Encumbrances
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_Central_Expense_Detail
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_DISBURSEMENT_DETAIL
    pmcmd stopworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_VENDOR_PAYMENTS
    #-- Special handling of errorlevel 3 which is expected if we stop a workflow that is already stopped.
    if [[ ($? -gt 0 && $? -lt 3)  || $? -ge 4 ]]
    then
    	send_email "${email_recepient}" "Error in ($script_name)" "step 0 failed - Stopping Workflows "
        error_msg_ex " step 0, stopping workflows "
    fi

    echo "Info: ($script_name) Stop of currently running workflows done at: `date` "

    step_1
}

step_1 ()
{
    ########## Run workflow : wf_pdm_ufr
    echo "Info: ($script_name) Executing Workflow  - wf_pdm_ufr."

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
		pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_pdm_ufr

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
	    echo "Info: ($script_name) wf_pdm_ufr Workflow completed at: `date` "
	    step_2
       else
	    send_email "${email_recepient}" "Error in ($script_name)" "step 1 failed - wf_pdm_ufr failed "
	    error_msg_ex  " step 1, executing workflow wf_pdm_ufr "
	fi

}

step_2 ()
{
    ########## Run workflow : wf_pdm_provr_adr_stg
    echo "Info: ($script_name) Executing Workflow  - wf_pdm_provr_adr_stg."

     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
		pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_pdm_provr_adr_stg

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
	    echo "Info: ($script_name) wf_pdm_provr_adr_stg Workflow completed at: `date` "
	    step_3
       else
	    send_email "${email_recepient}" "Error in ($script_name)" "step 2 failed - wf_pdm_provr_adr_stg failed "
	    error_msg_ex  " step 2, executing workflow wf_pdm_provr_adr_stg "
	fi

}

step_3 ()
{
    ########## Run workflow : wf_PD_CIW_VENDOR_BUS_TYPE
    echo "Info: ($script_name) Executing Workflow  - wf_PD_CIW_VENDOR_BUS_TYPE."
     success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
		pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_PD_CIW_VENDOR_BUS_TYPE

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
	    echo "Info: ($script_name) wf_PD_CIW_VENDOR_BUS_TYPE Workflow completed at: `date` "
	    #skipping M_PR_ENcumbrances (old table) using EIM/ESM loaded M_PR_Encumbrances_Detail instead
	    step_7
       else
        send_email "${email_recepient}" "Error in ($script_name)" "step 3 failed - wf_PD_CIW_VENDOR_BUS_TYPE failed "
        error_msg_ex  " step 3, executing workflow wf_PD_CIW_VENDOR_BUS_TYPE "
    fi

}

step_4 ()
{
    ########## Run workflow : wf_M_AP_Central_Expense_Detail
    echo "Info: ($script_name) Executing Workflow  - wf_M_AP_Central_Expense_Detail."
    success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
       pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_Central_Expense_Detail

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
	    echo "Info: ($script_name) wf_M_AP_Central_Expense_Detail Workflow completed at: `date` "
            step_5
       else
	    echo "Info: ($script_name) wf_M_AP_Central_Expense_Detail Workflow Failed at: `date` "
	    send_email "${email_recepient}" "Central Expense Detail Data Load Failed After 3 Attempts.  Older data will exist."
	    step_6
	fi

}

step_5 ()
{

    pushd ../../sql/artf21943 > /dev/null

    DW_USER=$PDM_USER
    DW_PASS=$PDM_PASS

    #~~~~~~~~ Truncate and insert into the tables that used to be views
    echo "Info: ($script_name) Truncating and inserting data into the tables that used to be views"
    #run complete post etl
    run_sql_fg_ex PDM_PostETL_V2_0.sql
    run_sql_fg_ex UpdtFincRatios.sql

    popd > /dev/null

}

step_6 ()
{

    pushd ../../sql/artf21943 > /dev/null

    DW_USER=$PDM_USER
    DW_PASS=$PDM_PASS

    #run post etl witout central expense
    run_sql_fg_ex PDM_PostETL_V2_1.sql
    run_sql_fg_ex UpdtFincRatios.sql

    popd > /dev/null

}

step_7 ()
{
    ########## Run workflow : wf_M_AP_DISBURSEMENT_DETAIL
    echo "Info: ($script_name) Executing Workflow  - wf_M_AP_DISBURSEMENT_DETAIL."
    success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
		pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_DISBURSEMENT_DETAIL

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
		 	echo "Info: ($script_name) wf_M_AP_DISBURSEMENT_DETAIL Workflow completed at: `date` "
    		step_8
   	 	else
			send_email "${email_recepient}" "Error in ($script_name)" "step 7 failed - wf_M_AP_DISBURSEMENT_DETAIL failed "
        	error_msg_ex  " step 7, executing workflow wf_M_AP_DISBURSEMENT_DETAIL "
    	fi
 }

step_8 ()
{
    ########## Run workflow : wf_M_AP_VENDOR_PAYMENTS
    echo "Info: ($script_name) Executing Workflow  - wf_M_AP_VENDOR_PAYMENTS."
    success_code="1"
    cntr="3"
    cnt="1"

    while [[ "$success_code" -eq 1 && "$cnt" -le "$cntr" ]]
    do
	    pmcmd startworkflow -sv $INF_SERVER -d $DOMAIN -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_M_AP_VENDOR_PAYMENTS

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
			echo "Info: ($script_name) wf_M_AP_VENDOR_PAYMENTS Workflow completed at: `date` "
		 	step_4
	   else
			send_email "${email_recepient}" "Error in ($script_name)" "step 8 failed - wf_M_AP_VENDOR_PAYMENTS failed "
			error_msg_ex  " step 8, executing workflow wf_M_AP_VENDOR_PAYMENTS "
       fi

}


# = = = = = = = = = = = =  M A I N

case "$batch_step" in
    "0" )      step_0 ;;
    "1" )      step_1 ;;
    "2" )      step_2 ;;
    "3" )      step_3 ;;
    "4" )      step_4 ;;
    "5" )      step_5 ;;
    "6" )      step_6 ;;
    "7" )      step_7 ;;
    "8" )      step_8 ;;
     *  ) echo "$USAGE";;
esac  # jump to a particular point in script

echo "PDM Informatica Job completed successfully."
send_email "${email_recepient}" "($script_name) is done" "PDM Informatica Job completed successfully."
echo "Info: ($script_name) PDM Weekly Load -- Completed at: `date` "
echo "Info: ($script_name) Check out the log file:  $LOG_FILE "
