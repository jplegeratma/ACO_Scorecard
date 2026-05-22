#-- Utility functions

# assumes following global variable(s) - beware these should not be overwritten !!!
# 1. script_name   -  should contain name of script being executed.
# 2. inf_user      -  informatica user (defaults to Administrator)
# 3. inf_pass      -  informatica user password (defaults to Administrator)
# 4. inf_server    -  informatica server (defaults to DMA-DWDEV:4001)
# 5. inf_folder    -  informatica user pass (defaults to dwdev)
# 6. verbose       -  specifies if this is a verbose_mode

#= = = = = = = = = = = = = GLOBAL CONSTANTS

# source the application constants
#if [ -x $DWBINHOME/dmadw/application.sh ]
#then
#    . $DWBINHOME/dmadw/application.sh
#else
#    echo "Error: ($script_name) cannot execute \$DWBINHOME/dmadw/application.sh (file not found or not executable)" 1>&2
#    exit 1
#fi

#gc_email_support="aimee.mcneil@state.ma.us,dinesh.sherpaakam@state.ma.us,dushyant.jhamb@state.ma.us,maheshwar.uppalapati@state.ma.us,malcolm.winfield@state.ma.us,peter.rogan@state.ma.us,vibhas.paranjape@state.ma.us,ma_dma_am@yahoo.com,ma_dma_dj@yahoo.com,ma_dma_ds@yahoo.com,ma_dma_mu@yahoo.com,ma_dma_mw@yahoo.com,ma_dma_pr@yahoo.com,ma_dma_vp@yahoo.com"
#gc_email_support="Peter.Rogan@state.ma.us"
#gc_email_support="Mahesh.Marineni-Subramanyam@state.ma.us"
#gc_email_support="EHS-DL-DWDeveloper@MassMail.State.MA.US,sivakumar.essambattu@state.ma.us,EHS-DL-PDMITTeam@MassMail.State.MA.US"
#gc_email_support="sivakumar.essambattu@state.ma.us"
gc_email_support="JP.Leger@mass.gov"

#= = = = = = = = = = = = = SET DEFAULTS FOR GLOBAL VARIABLES
if [ -z "$script_name" ];       then    script_name="Unknown Script"    ; fi
if [ -z "$inf_user" ];          then    inf_user="$INF_USER"            ; fi
if [ -z "$inf_pass" ];          then    inf_pass="$INF_PASS"            ; fi
if [ -z "$inf_server" ];        then    inf_server="$INF_SERVER"        ; fi
if [ -z "$inf_folder" ];        then    inf_folder="$INF_FOLDER"        ; fi

gv_sat_run_date="99991231"
gv_shifted_date="99991231"

gv_code_dir="$DWBINHOME/dmadw/code"
gv_sql_dir="${gv_code_dir}/sql"


# = = = = = = = = = = = =  F U N C T I O N S  .

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    chkora <filename(s)>
# Purpose: scans the output of one or more sqlplus script logs
#          for oracle/sqlplus/plsql errors
#          Returns non-zero if error is found and emits error lines
#          to stderr
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function chkora() {

    perl -ne 'if (/(ORA\-[0-9])|(PLS\-[0-9])|(SP2-[0-9])/) { print STDERR $ARGV, ":", $_; $found = 1; } END { if ($found) { exit 1; } }' $@

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    run_sql_fg <sql-script> (<additional sqlplus args>)
# Purpose: Runs a sql script in the forground via sqlplus (i.e. doesn't return to
#          caller until done). Reports start and end.  Exit code and output are
#          checked for errors and reported to the calling shell.
# Notes:   database connection is done using global vars $DW_USER $DW_SID and $DW_PASS
#          Optional additional args can be passed.
# Example, no args:
#          run_sql_fg somesuch.sql
# Example, additional sqlplus args
#          run_sql_fg somesuch.sql USERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function run_sql_fg()
{
    # first arg must be the sql script to run.
    # Additional args can be added, but note that quoting issues remain
    args="$*"
    sql=$1

    echo "Info: ($script_name) starting $args at: " `date`
    echo "${DW_PASS}" | sqlplus -L ${DW_USER}@${DW_SID} @${args} > $sql.log 2>&1
    if [ $? -gt 0 ]
    then
        chkora $sql.log
        error_msg " error code returned by $args"
		  return 1
    fi
    echo "Info: ($script_name) done $args at: " `date`

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    run_sql_fg_ex <sql-script> (<additional sqlplus args>)
# Purpose: Runs a sql script in the forground via sqlplus by calling
#          run_sql_fg and EXIT in case of an error
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function run_sql_fg_ex()
{
	 # Call run_sql_fg with the passed in args and exit out in case of an error
	 run_sql_fg "$@"
	 if [ $? -gt 0 ]; then exit 1; fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    run_sql_bg <sql-script> (<additional sqlplus args>)
# Purpose: Runs a sql script in the background via sqlplus.
#          Reports start and end via echo's to stdout.  Exit code and output are
#          checked for errors and reported to the calling shell via echos to stdout.
# Notes:   database connection is done using global vars $DW_USER $DW_SID and $DW_PASS
#          Also:  since job runs in background, calling this returns
#          immediately to calling script.  Status is sent to stdout;
#          No error code can be passed via $?, unless of course its an error
#          in starting the script.   On hpux, if caller is killed
#          then child scripts are killed.  It is up to the caller to scan
#          logs looking for errors.
#          Optional additional sqlplus args may be passed.
# Example, no args:
#          run_sql_bg somesuch.sql
# Example, additional sqlplus args
#          run_sql_bg somesuch.sql USERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function run_sql_bg()
{
    # Runs a sql script in the background via sqlplus.
    #
    #
    # first arg must be the sql script to run.
    # Additional args can be added, but note that quoting issues remain
    args="$*"
    sql=$1

    echo "Info: ($script_name) starting $sql at: " `date`
    ((echo "${DW_PASS}" | sqlplus -L ${DW_USER}@${DW_SID} @${args} > $sql.log 2>&1); \
         chkora $sql.log && \
         echo "Info: ($script_name) done $sql at: " `date`) &
    if [ $? -gt 0 ]
    then
        chkora $sql.log
        error_msg " cannot start $sql"
    fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    print_msg (type,msg)
# Purpose: prints different types of messages (error, warning, info)
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print_msg ()
{
        local type=$1
        local msg=$2
        echo "${type}: (${script_name}) `date "+%Y-%m-%d %H:%M:%S"` $msg"
        return 0
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    error_msg (error_msg)
# Purpose: prints error message and sends an email to the support
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error_msg ()
{
	local error_msg=$1
	local l_skip_email_flag=$2

	# Print message to the log
	print_msg "Error" "${error_msg}" 1>&2

	# Get the current run date
	#local l_run_date=`get_run_date "${connect_string}"`

	# Insert a record in batch table that failure has occured
	#insert_load_batch_rec "${connect_string}" "Batch_Failure_${l_run_date}: ${error_msg}"

	# Send an email to the support that there was an error
	if [ -z "${l_skip_email_flag}" ]; then
	    send_email "${gc_email_support}" "Load Cycle Error at `date` on host $HOSTNAME: Failed in ${script_name}" " $error_msg"
	fi

   return 1
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    error_msg_ex (args)
# Purpose: Error message and EXIT out
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error_msg_ex ()
{
	 # Call error_msg with the passed in args and exit out
	 error_msg "$@"
	 exit 1
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    warning_msg (warning_msg)
# Purpose: prints warning message
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
warning_msg ()
{
        local warning_msg=$1
        print_msg "Warning" "${warning_msg}"
        return 0
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    info_msg (info_msg)
# Purpose: prints info message
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
info_msg ()
{
        local info_msg=$1
        print_msg "Info" "${info_msg}"
        return 0
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    send_email (recepient, subject, email_body)
# Purpose: dispatches email
# Notes:
# 1. Only runs if the script executes from smtp_enabled_machine.
# 2. Be aware that currently the smtp service is set up as oracle -
#    hence all email receieved will be from "Oracle Administrator"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
send_email ()
{
        local recepient=$1
        local subject=$2
        local email_body=$3

        #local default_recepient="EHS-DL-DWDeveloper@MassMail.State.MA.US,sivakumar.essambattu@state.ma.us,EHS-DL-PDMITTeam@MassMail.State.MA.US"
        local default_recepient="sivakumar.essambattu@state.ma.us"

        # default email address.
        if [ -z "$recepient" ]
        then
                recepient=$default_recepient
        fi

        # dispatch email
        email_body_file="email_body_`date +%Y%m%d%H%M%S`.txt"
        echo -e $email_body > ./${email_body_file}
        # Only send email if the script is running from smtp_enabled_machine
        if [ -n "$verbose" ]
        then
                info_msg "Following Email sent:"
                echo "  To: '${recepient}'"
                echo "  Subject: '${subject}'"
                echo -e "  ${email_body}"
                echo
        fi

		mailx -s "$subject" "$recepient" < ./${email_body_file}
		if [ $? -gt 0 ]
		then
			 print_msg "Error" "Could not send email to ${recepient} on ${subject}"
		fi

        rm ./$email_body_file
        return 0
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    chk_sqlerror (msg)
# Purpose: Checks for ORA errors in string passed to it.
# Notes:
# 1. Typical usage :
#         result=`process_sql "paranjapev/dma@dwd1" "select * from dual"`
#         if  ! chk_sqlerror "$result"; then  exit 1 ; fi
#         proceed with "$result" which now has the results.......
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
chk_sqlerror ()
{
        local msg="$1"
        local ora_error=`echo "$msg" | egrep '(ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)'`
        local ret_val=0

        if [ -n "${ora_error}" ]
        then
                error_msg "$ora_error"
                ret_val=1
        fi
        return $ret_val
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    process_sql (connect_string, query)
# Purpose: processes sql and returns whatever SQLPLUS has to offer back to caller.
# Notes:
# 1. NO SEMICOLONS or "/" in the query  passed to this function.
# 2. it is caller's  responsibility to check for error. (use chk_error () for this purpose)
# 3. for simplicity, this function serves all DML - hence it performs commit (even for select).
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
process_sql ()
{
    local connect_string=$1
    local query=$2

    local result=`sqlplus -S -L /nolog <<EOF
connect $connect_string
set echo off
set feedback off
set heading off
set newpage 0
set pagesize 0
set pause off
set space 0
set time off
set timing off
set trimspool on
set sqlterminator "/"
$query
/
commit
/
exit
EOF
 2>&1`

 	result=`echo "$result" | tr -d "\f\r" | sed -e '/^Connected.$/d'` #chomp and return result.
    echo "$result"
}



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    stop_workflow (workflow)
# Purpose: stops workflow.
# Notes:
# 1. Expects following global variables: $inf_server, $inf_user, $inf_pass, $inf_folder
# 2. Typically called just before executing a workflow to ensure that is is not already running
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
stop_workflow ()
{

        local workflow=$1

        if [ -z "$workflow" ]
        then
                error_msg  "no workflow argument passed to stop_workflow "
                exit 1
        fi

        info_msg "Attempting to stop workflow \"$workflow\" on server ${inf_server} in folder ${inf_folder}"
        if [ -n "$verbose" ]
        then
                pmcmd stopworkflow -s $inf_server -u $inf_user -p $inf_pass -f $inf_folder -wait $workflow
        else
                pmcmd stopworkflow -s $inf_server -u $inf_user -p $inf_pass -f $inf_folder -wait $workflow > /dev/null
        fi

        #-- Special handling of errorlevel 3 which is expected if we stop a workflow that is already stopped.
        if [[ ($? -gt 0 && $? -lt 3)  || $? -ge 4 ]]
        then
                error_msg " Error stopping workflow $workflow "
                exit 1
        fi

        info_msg "workflow \"$workflow\" stopped succesfully at: `date` "
}




# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    start_workflow (workflow)
# Purpose: starts workflow.
# Notes:
# 1. Expects following global variables: $inf_server, $inf_user, $inf_pass, $inf_folder
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
start_workflow ()
{
        local workflow=$1
        if [ -z "$workflow" ]
        then
                error_msg  "no workflow argument passed to start_workflow "
                exit 1
        fi


        info_msg "Start execution of workflow  - \"${workflow}\" on server ${inf_server} in folder ${inf_folder} at: `date` "

        if [ -n "$verbose" ]
        then
                pmcmd startworkflow -s $inf_server -u $inf_user -p $inf_pass -f $inf_folder -wait $workflow
        else
                pmcmd startworkflow -s $inf_server -u $inf_user -p $inf_pass -f $inf_folder -wait $workflow > /dev/null
        fi

        if [ $? -gt 0 ]
        then
                error_msg  "executing workflow $workflow "
                exit 1
        fi
        info_msg "Workflow \"$workflow\" completed at: `date` "
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    calc_sat_run_date (db_connect_string)
# Purpose: Calculates the current run date from the last successfull run
#	       as recorded in the dw_params FACT_LOAD_YYYYMMDD
# Notes:   It sets the global var gv_sat_run_date
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
calc_sat_run_date ()
{
	# Local variables
	local lcsd_db_connect_str=$1

	# Let oracle do the date arithmetic
	local query="select to_char((to_date(param_value,'YYYYMMDD') + 7), 'YYYYMMDD') sat_run_date from dw_params where param_name ='FACT_LOAD_YYYYMMDD'"
	if [ -n "$verbose" ] ; then echo;info_msg "Executing $query" ; fi

	gv_sat_run_date=`process_sql "${lcsd_db_connect_str}" "${query}"`
	if  ! chk_sqlerror "${gv_sat_run_date}"; then return 1 ; fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_last_run_date (db_connect_string)
# Purpose: Gets the last run date from the last successfull run
#	       as recorded in the dw_params FACT_LOAD_YYYYMMDD
# Notes:   It sets the global var gv_last_run_date
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_last_run_date ()
{
	# Local variables
	local lcsd_db_connect_str=$1

	# Let oracle to the date arithmetic
	local query="select to_char(to_date(param_value,'YYYYMMDD'), 'YYYYMMDD') last_run_date from dw_params where param_name ='FACT_LOAD_YYYYMMDD'"

	if [ -n "$verbose" ] ; then echo;info_msg "Executing $query" ; fi

	gv_last_run_date=`process_sql "${lcsd_db_connect_str}" "${query}"`
	if  ! chk_sqlerror "${gv_last_run_date}"; then return 1 ; fi
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    shift_date_by_days (db_connect_string, src_date, [-]n)
# Purpose: Calculates the date by adding or subtracting n days from
#	       src_date passed in yyyymmdd format
# Notes:   It sets the global var gv_shifted_date
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
shift_date_by_days ()
{
	# Local variables
	local lsfd_db_connect_str="$1"
	local lsfd_src_date="$2"
	local lsfd_ndays="$3"

	# Build sql query to shift the date by (-)n days
	local query="select to_char(to_date('"${lsfd_src_date}"','YYYYMMDD') + ("${lsfd_ndays}"), 'YYYYMMDD') shifted_date from dual"

	if [ -n "$verbose" ] ; then echo;info_msg "Executing $query" ; fi

	# Set the global var gv_shifted_date
	gv_shifted_date=`process_sql "${lsfd_db_connect_str}" "${query}"`
	if  ! chk_sqlerror "${gv_shifted_date}"; then return 1 ; fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    shift_date_by_weekday (db_connect_string, src_date, weekday, [-p])
# Purpose: Calculates the date by arriving at next/previous weekday from
#	       src_date passed in yyyymmdd format
# Notes:   It sets the global var gv_shifted_date
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
shift_date_by_weekday ()
{
	# Local variables
	local lsfw_db_connect_str="$1"
	local lsfw_src_date="$2"
	local lsfw_weekday=`echo "$3" | tr [a-z] [A-Z]`
	local lsfw_prior="$4"
	local lsfw_days_to_sub=0

	if [ -n "${lsfw_prior}" ]; then
		lsfw_days_to_sub=7
	fi

	# Build sql query to shift the date by (-)n days
	local query="select to_char(next_day(to_date('"${lsfw_src_date}"','YYYYMMDD'), '"${lsfw_weekday}"') - "${lsfw_days_to_sub}", 'YYYYMMDD') shifted_date from dual"

	if [ -n "$verbose" ] ; then echo;info_msg "Executing $query" ; fi

	# Set the global var gv_shifted_date
	gv_shifted_date=`process_sql "${lsfw_db_connect_str}" "${query}"`
	if  ! chk_sqlerror "${gv_shifted_date}"; then return 1 ; fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    set_run_date (db_connect_string)
# Purpose: Calculates the current run date based on current system date
#	        This date is used for deriving DW md from date
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set_run_date ()
{
	# Local variables
	local lsrd_db_connect_str=$1
	local lsrd_run_date=`date +%Y%m%d`

	# update dw_params table to set the run date to current sys date
	local query="update dw_params set param_value = '${lsrd_run_date}' where param_name = 'RUNDATE'"
	if [ -n "$verbose" ] ; then echo;info_msg "Executing $query" ; fi

	local sql_result=`process_sql "${lsrd_db_connect_str}" "${query}"`
	if  ! chk_sqlerror "${sql_result}"; then return 1 ; fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    get_run_date (db_connect_string)
# Purpose: Gets the current run date that was set in dw_params table
# Notes:   Defaults to current date if for some reason we can't get the
#		     run date from dw_params
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_run_date ()
{
	# Local variables
	local lgrd_db_connect_str="$1"

	# Get the run date from dw_params table
	local query="select param_value from dw_params where param_name = 'RUNDATE'"

	local lgrd_run_date=`process_sql "${lgrd_db_connect_str}" "${query}"`

	# Check for any sql errors
	local ora_error=`echo $l_run_date | egrep '((ORA\-[0-9]+)|(PLS\-[0-9]+)|(SP2-[0-9]+)).*'`
	if [ -n "${ora_error}" ]
	then
		 lgrd_run_date=`date +%Y%m%d`
	fi

	# Echo the run date - so that the caller gets the run date result
	echo "$lgrd_run_date"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    insert_load_batch_rec (db_connect_string, mapping_name)
# Purpose: Inserts the corresponding mapping row in the dw_md_load_batch
#	        table by executing the sql script start_batch.sql
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
insert_load_batch_rec ()
{
	 # Local variables
	 local libr_db_connect_str="$1"
	 local libr_map_name="$2"
	 local libr_batch_sql="insert_load_batch_rec.sql"

	 pushd "${gv_sql_dir}"/dbupdate > /dev/null

	 # Since var limit in sqlplus is 239 - we will truncate the mapping name to 239 char
	 sqlplus -L "${libr_db_connect_str}" @"${libr_batch_sql}" "${libr_map_name:0:239}" > "${libr_batch_sql}".log 2>&1
	 if [ $? -gt 0 ]
	 then
		  perl -ne 'if (/(ORA\-[0-9])|(PLS\-[0-9])|(SP2-[0-9])/) { print STDERR $_; $found = 1; } END { if ($found) { return 1; } }' "${libr_batch_sql}".log
		  # We don't want to use error_msg func because this func is called from error_msg itself
		  print_msg "Error" "Inserting record in dw_md_load_batch table"
        return 1
    fi

	 popd > /dev/null
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    update_load_batch_rec (db_connect_string, mapping_name)
# Purpose: Updates the corresponding mapping row in the dw_md_load_batch
#	        table by executing the sql script end_batch.sql
# Notes:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
update_load_batch_rec ()
{
	 # Local variables
	 local lubr_db_connect_str="$1"
	 local lubr_map_name="$2"
	 local lubr_batch_sql="update_load_batch_rec.sql"

	 pushd "${gv_sql_dir}"/dbupdate > /dev/null

	 # Truncate the mapping name to 239 char (as we would have inserted that way due to sqlplus limit)
	 sqlplus -L "${lubr_db_connect_str}" @"${lubr_batch_sql}" "${lubr_map_name:0:239}" > "${lubr_batch_sql}".log 2>&1
	 if [ $? -gt 0 ]
	 then
		  perl -ne 'if (/(ORA\-[0-9])|(PLS\-[0-9])|(SP2-[0-9])/) { print STDERR $_; $found = 1; } END { if ($found) { return 1; } }' "${lubr_batch_sql}".log
		  # We don't want to use error_msg func because the insert batch rec is called from error_msg itself
		  print_msg "Error" "Updating record in dw_md_load_batch table"
        return 1
    fi

	 popd > /dev/null
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name:    if_error_exit (retcode errmsg)
# Purpose: Checks for the passed in return code, if greater than zero EXIT with error message
# Notes:
# 	Usage :
#         retcode=some_command
#         if_error_exit retcode "Unable to process some_command"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if_error_exit ()
{
        local retcode=$1
        local error_msg=$2

        if [ retcode -gt 0 ]
        then
                error_msg "$error_msg"
                exit 1
        fi

        return
}
