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

# Oracle user that will run DML scripts
export DW_USER=mr
export DW_PASS=mr
export PDM_USER=pdm
export PDM_PASS=pdm
# Oracle database connect string
export DW_SID=mrd1.world
# Informatica server (engine)
export INF_SERVER=int_serv_dev
# Informatica User the will run Informatica workflows/sessions
export INF_USER=dwbatch
export INF_PASS=dwbatch
# Informatica Folder where workflows/sessions live
export INF_FOLDER=PDM
export INF_FOLDER_2=PDM
export DOMAIN=Domain_dev
