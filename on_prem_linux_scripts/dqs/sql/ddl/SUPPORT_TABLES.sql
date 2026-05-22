CREATE SEQUENCE INF_DQ_BATCH_SEQ
       START WITH 1
       INCREMENT BY 1
       NOCACHE
       NOCYCLE;
/
CREATE TABLE INF_B_DQ_LOAD_BATCH
(
  DQ_BATCH_SEQ       NUMBER(10) DEFAULT INF_DQ_BATCH_SEQ.NEXTVAL , -- replaces BATCH_NUM
  RUN_DATE           DATE,                                -- passed by parameter - serves as report As Of Date
  STEP_NUM           NUMBER,                              -- what step it was running
  PROJECT_NAME       VARCHAR2(2 BYTE),                    -- SC or DA 
  PROGRAM_NAME       VARCHAR2(255 BYTE),                  -- batch job or Informatica job
  PARENT_BATCH_SEQ   NUMBER(10),                          -- For Informatica jobs, this is the BATCH_NUM of Master Batch
  BATCH_START_DT_TM  DATE,                                -- Date run and 
  BATCH_END_DT_TM    DATE,                                -- Wriiten at end of batch
  WH_INSERT_DT_TM    DATE      DEFAULT SYSDATE,           -- Datetime this record created     
  TABLE_NAME         VARCHAR2(255 BYTE),                  -- table populated
  MIN_DOS            DATE,                                -- Populated after load by SQL - calculated but should equal passed
  MAX_DOS            DATE,                                -- Populated after load by SQL
  MIN_REMIT_DATE     DATE,                                -- Populated after load by SQL
  MAX_REMIT_DATE     DATE,                                -- Populated after load by SQL
  RECORDS_WRITTEN    NUMBER(10),                           -- Number of records written in Informatica job
  ERROR_MESSAGE      VARCHAR2(4000),                       -- Error mesages from Informatica jobs 
  STATUS             VARCHAR2(200)                        -- Used on Batch headers 'Running', 'Complete' or 'Error'
);
/
CREATE TABLE INF_B_DQ_PARAMS
(
  PARAM_NAME   VARCHAR2(40 BYTE)                NOT NULL,
  PARAM_VALUE  VARCHAR2(255 BYTE)               NOT NULL,
  PARAM_DESC   VARCHAR2(255 BYTE)
);
/
EXIT

