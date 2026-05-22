#!/bin/bash

#
# Defines usernames, passwords and connection strings so that these things do not need to be
# embedded in shell scripts
# Usage:  In your shell script:
# . $EIMBINHOME/application.sh
# # then
# sqlplus $EIMUSER/${EIMPASS}@$SID @somescript.sql > somescript.sql.log 2>&1
# # or
# pmcmd startworkflow -s $INF_SERVER -u $INF_USER -p $INF_PASS -f $INF_FOLDER -wait wf_ods_6510

#Unlike the PDM script which run against PowerCenter, these script run against the IDQ Developer, so they use infacmd.sh vs pmcmd
#The main commands are like:
#infacmd.sh wfs startWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -a APP_INF_B_DA_MNTH_MCO_CLMTYP -wf WKF_INF_B_DA_MNTH_MCO_CLMTYP -pf DA_PARAMETERS.xml
#infacmd.sh wfs listActiveWorkflowInstances -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS
#infacmd.sh wfs abortWorkflow -dn $DOMAIN -sn $INF_SERVER -un $INF_USER -pd $INF_PASS -iid "${fn}" > /dev/null`

# Oracle user that will run DML scripts
export DW_USER=dq
export DW_PASS=Rcm#Lr2p
# Oracle database connect string
export DW_SID=DWQ1RAC
# Informatica server (engine)
export INF_SERVER=INFA_DIS_QA
# Informatica User the will run Informatica workflows/sessions
export INF_USER=dq
export INF_PASS=ChangeMe
# Informatica Folder where workflows/sessions live
export INF_FOLDER=DQ
export INF_FOLDER_2=DQ
export DOMAIN=domain_qa
