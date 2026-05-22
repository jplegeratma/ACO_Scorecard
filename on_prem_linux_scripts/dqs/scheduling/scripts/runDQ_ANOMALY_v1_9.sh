#!/bin/sh
LOG_FILE=../logs/DQ_ANOMALY`date +%m%d%y%H%M%S`.sh.log

export LOG_FILE

# Source LB env
source ~/.dq_profile

#export DA_MIN_DOS=20170101
#export DA_MAX_DOS=20200630
#export DA_PARAM_FILE=$INFA_HOME/server/infa_shared/BWParam/DQ/DA_PARAMETERS.xml
export DA_PARAM_FILE=DA_PARAMETERS.xml

# * * * * * * * * * * * * * * * *    I M P O R T A N T    * * * * * * * * * * * * * * * *
#                                                                                       *
#    Only one of the 3 calls below should be uncommented  and run at any given time     *
#                                                                                       *
# * * * * * * * * * * * * * * * *    I M P O R T A N T    * * * * * * * * * * * * * * * *
#Execution using the application.sh
./DQ_ANOMALY_v1_9.sh > ${LOG_FILE} 2>&1 &

## Full execution
#./DQ_ANOMALY.sh  > ${LOG_FILE} 2>&1 &

## Full execution - Restart
#./DQ_ANOMALY.sh  -s 19 > ${LOG_FILE} 2>&1 &
