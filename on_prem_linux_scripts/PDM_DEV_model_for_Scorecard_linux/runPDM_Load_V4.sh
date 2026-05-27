#!/bin/sh
LOG_FILE=../logs/PDM_Load_V4`date +%m%d%y%H%M%S`.sh.log

# Source LB env
source ~/.pdm_profile

# * * * * * * * * * * * * * * * *    I M P O R T A N T    * * * * * * * * * * * * * * * *
#                                                                                       *
#    Only one of the 3 calls below should be uncommented  and run at any given time     *
#                                                                                       *
# * * * * * * * * * * * * * * * *    I M P O R T A N T    * * * * * * * * * * * * * * * *
#Execution using the application.sh
./PDM_Load_V4.sh > ${LOG_FILE} 2>&1 &

## Full execution
#./PDM_Load_V3.sh  > ${LOG_FILE} 2>&1 &

## Full execution - Restart
#./PDM_Load_V3.sh  -s 7 > ${LOG_FILE} 2>&1 &
