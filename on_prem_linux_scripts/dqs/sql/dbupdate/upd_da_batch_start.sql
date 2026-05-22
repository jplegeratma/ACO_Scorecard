SET pause OFF
SET echo ON
SET feedback ON
SET TIME ON
SET timing ON

whenever sqlerror exit failure rollback

INSERT INTO INF_B_DQ_LOAD_BATCH
(
  --DQ_BATCH_SEQ    --  NUMBER(10) DEFAULT INF_DQ_BATCH_SEQ.NEXTVAL ,
  RUN_DATE,         --  DATE                 -- passed by parameter - serves as report As Of Date
  STEP_NUM,         --  NUMBER,              -- what step it was running
  PROJECT_NAME,     --  VARCHAR2(2 BYTE),    -- SC or DA 
  PROGRAM_NAME,     --  VARCHAR2(255 BYTE),  -- batch job or Informatica job
  PARENT_BATCH_SEQ, --  NUMBER(10),          -- For Informatica jobs, this is the BATCH_NUM of Master Batch
  BATCH_START_DT_TM,--  DATE,                -- Date run and 
  STATUS            --  VARCHAR2(200)        -- Used on Batch headers 'Running', 'Complete' or 'Error'
)
VALUES
(
TRUNC(SYSDATE),
0,
'DA', 
'BATCH_SEQ',
NULL,
SYSDATE, 
'Running'
)
/

UPDATE INF_B_DQ_PARAMS 
SET PARAM_VALUE = (SELECT TO_CHAR(MAX(RUN_DATE),'YYYYMMDD') FROM INF_B_DQ_LOAD_BATCH WHERE PROJECT_NAME = 'DA' AND STEP_NUM = 0)
WHERE PARAM_NAME = 'DA_RUN_DATE'
/
UPDATE INF_B_DQ_PARAMS 
SET PARAM_VALUE = (SELECT MAX(DQ_BATCH_SEQ) FROM INF_B_DQ_LOAD_BATCH WHERE PROJECT_NAME = 'DA' AND STEP_NUM = 0)
WHERE PARAM_NAME = 'DA_BATCH_SEQ'
/
COMMIT
/

EXIT

