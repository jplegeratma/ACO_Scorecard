-- ACO Views for DIF based on Step3 Table

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_0(
	PLAN,
	ACO,
	ID,
	BENCHMARK,
	BENCHMARK_NAME,
	FIELD_ID,
	CLAIM_TYPE,
	BENCHMARK_THRESHOLD,
	A_MONTH_SERVICE,
	A_CLM,
	A_ACT_4,
	A_ACT_3,
	A_ACT_2,
	A_ACT_1,
	B_MONTH_SERVICE,
	B_CLM,
	B_ACT_5,
	B_ACT_4,
	B_ACT_3,
	B_ACT_2,
	C_MONTH_SERVICE,
	C_CLM,
	C_ACT_6,
	C_ACT_5,
	C_ACT_4,
	C_ACT_3,
	D_MONTH_SERVICE,
	D_CLM,
	D_ACT_7,
	D_ACT_6,
	D_ACT_5,
	D_ACT_4,
	RUN_DATE_STR,
	LAST_SUB_STR,
	RUN_DATE,
	DQ_BATCH_SEQ,
	A_CLM_HDR,
	A_ACT_4_HDR,
	A_ACT_3_HDR,
	A_ACT_2_HDR,
	A_ACT_1_HDR,
	B_CLM_HDR,
	B_ACT_5_HDR,
	B_ACT_4_HDR,
	B_ACT_3_HDR,
	B_ACT_2_HDR,
	C_CLM_HDR,
	C_ACT_6_HDR,
	C_ACT_5_HDR,
	C_ACT_4_HDR,
	C_ACT_3_HDR,
	D_CLM_HDR,
	D_ACT_7_HDR,
	D_ACT_6_HDR,
	D_ACT_5_HDR,
	D_ACT_4_HDR
) as
    SELECT PLAN,
           ACO,
           ID,
           BENCHMARK,
           BENCHMARK_NAME,
           FIELD_ID,
           CLAIM_TYPE,
           BENCHMARK_THRESHOLD,
           A_MONTH_SERVICE,
           A_CLM,
           A_ACT_4,
           A_ACT_3,
           A_ACT_2,
           A_ACT_1,
           B_MONTH_SERVICE,
           B_CLM,
           B_ACT_5,
           B_ACT_4,
           B_ACT_3,
           B_ACT_2,
           C_MONTH_SERVICE,
           C_CLM,
           C_ACT_6,
           C_ACT_5,
           C_ACT_4,
           C_ACT_3,
           D_MONTH_SERVICE,
           D_CLM,
           D_ACT_7,
           D_ACT_6,
           D_ACT_5,
           D_ACT_4,
           RUN_DATE_STR,
           LAST_SUB_STR,
           RUN_DATE,
           DQ_BATCH_SEQ,
           A_CLM_HDR,
           A_ACT_4_HDR,
           A_ACT_3_HDR,
           A_ACT_2_HDR,
           A_ACT_1_HDR,
           B_CLM_HDR,
           B_ACT_5_HDR,
           B_ACT_4_HDR,
           B_ACT_3_HDR,
           B_ACT_2_HDR,
           C_CLM_HDR,
           C_ACT_6_HDR,
           C_ACT_5_HDR,
           C_ACT_4_HDR,
           C_ACT_3_HDR,
           D_CLM_HDR,
           D_ACT_7_HDR,
           D_ACT_6_HDR,
           D_ACT_5_HDR,
           D_ACT_4_HDR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;

      create or replace view MHTEAM.DWDQ.INF_SC_STEP3_1(
	RUN_DATE,
	ACO,
	ID,
	BENCHMARK,
	BENCHMARK_NAME,
	FIELD_ID,
	CLAIM_TYPE,
	BENCHMARK_THRESHOLD,
	A_CLM,
	A_ACT_4_S,
	A_ACT_3_S,
	A_ACT_2_S,
	A_ACT_1_S,
	B_CLM,
	B_ACT_5_S,
	B_ACT_4_S,
	B_ACT_3_S,
	B_ACT_2_S,
	C_CLM,
	C_ACT_6_S,
	C_ACT_5_S,
	C_ACT_4_S,
	C_ACT_3_S,
	D_CLM,
	D_ACT_7_S,
	D_ACT_6_S,
	D_ACT_5_S,
	D_ACT_4_S,
	D_ACT_7,
	D_ACT_6,
	D_ACT_5,
	D_ACT_4
) as
      SELECT RUN_DATE,
             CASE
                 WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                 WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                 WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                 ELSE ACO
             END
                 AS ACO,
             ID,
             BENCHMARK,
             BENCHMARK_NAME,
             FIELD_ID,
             CLAIM_TYPE,
             TO_CHAR (BENCHMARK_THRESHOLD * 100, '999.99')
                 AS BENCHMARK_THRESHOLD,
             A_CLM,
             CASE
                 WHEN A_ACT_4 IS NULL THEN '-'
                 ELSE TO_CHAR (A_ACT_4, '999.99')
             END
                 AS A_ACT_4_S,
             CASE
                 WHEN A_ACT_3 IS NULL THEN '-'
                 ELSE TO_CHAR (A_ACT_3, '999.99')
             END
                 AS A_ACT_3_S,
             CASE
                 WHEN A_ACT_2 IS NULL THEN '-'
                 ELSE TO_CHAR (A_ACT_2, '999.99')
             END
                 AS A_ACT_2_S,
             CASE
                 WHEN A_ACT_1 IS NULL THEN '-'
                 ELSE TO_CHAR (A_ACT_1, '999.99')
             END
                 AS A_ACT_1_S,
             B_CLM,
             CASE
                 WHEN B_ACT_5 IS NULL THEN '-'
                 ELSE TO_CHAR (B_ACT_5, '999.99')
             END
                 AS B_ACT_5_S,
             CASE
                 WHEN B_ACT_4 IS NULL THEN '-'
                 ELSE TO_CHAR (B_ACT_4, '999.99')
             END
                 AS B_ACT_4_S,
             CASE
                 WHEN B_ACT_3 IS NULL THEN '-'
                 ELSE TO_CHAR (B_ACT_3, '999.99')
             END
                 AS B_ACT_3_S,
             CASE
                 WHEN B_ACT_2 IS NULL THEN '-'
                 ELSE TO_CHAR (B_ACT_2, '999.99')
             END
                 AS B_ACT_2_S,
             C_CLM,
             CASE
                 WHEN C_ACT_6 IS NULL THEN '-'
                 ELSE TO_CHAR (C_ACT_6, '999.99')
             END
                 AS C_ACT_6_S,
             CASE
                 WHEN C_ACT_5 IS NULL THEN '-'
                 ELSE TO_CHAR (C_ACT_5, '999.99')
             END
                 AS C_ACT_5_S,
             CASE
                 WHEN C_ACT_4 IS NULL THEN '-'
                 ELSE TO_CHAR (C_ACT_4, '999.99')
             END
                 AS C_ACT_4_S,
             CASE
                 WHEN C_ACT_3 IS NULL THEN '-'
                 ELSE TO_CHAR (C_ACT_3, '999.99')
             END
                 AS C_ACT_3_S,
             D_CLM,
             CASE
                 WHEN D_ACT_7 IS NULL THEN '-'
                 ELSE TO_CHAR (D_ACT_7, '999.99')
             END
                 AS D_ACT_7_S,
             CASE
                 WHEN D_ACT_6 IS NULL THEN '-'
                 ELSE TO_CHAR (D_ACT_6, '999.99')
             END
                 AS D_ACT_6_S,
             CASE
                 WHEN D_ACT_5 IS NULL THEN '-'
                 ELSE TO_CHAR (D_ACT_5, '999.99')
             END
                 AS D_ACT_5_S,
             CASE
                 WHEN D_ACT_4 IS NULL THEN '-'
                 ELSE TO_CHAR (D_ACT_4, '999.99')
             END
                 AS D_ACT_4_S,
             D_ACT_7,
             D_ACT_6,
             D_ACT_5,
             D_ACT_4
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3
       WHERE ACO != '+'
    ORDER BY RUN_DATE, ACO, ID;

    create or replace view MHTEAM.DWDQ.INF_SC_STEP3_1_BENCHMARK_DATA(
	RUN_DATE,
	ACO,
	ID,
	BENCHMARK,
	BENCHMARK_NAME,
	FIELD_ID,
	CLAIM_TYPE,
	DUM1,
	BENCHMARK_THRESHOLD,
	DUM2,
	A_CLM,
	A_ACT_4_S,
	A_ACT_3_S,
	A_ACT_2_S,
	A_ACT_1_S,
	DUM3,
	B_CLM,
	B_ACT_5_S,
	B_ACT_4_S,
	B_ACT_3_S,
	B_ACT_2_S,
	DUM4,
	C_CLM,
	C_ACT_6_S,
	C_ACT_5_S,
	C_ACT_4_S,
	C_ACT_3_S,
	DUM5,
	D_CLM,
	D_ACT_7_S,
	D_ACT_6_S,
	D_ACT_5_S,
	D_ACT_4_S
) as
      SELECT RUN_DATE,
             CASE
                 WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                 WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                 WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                 ELSE ACO
             END                                        AS ACO,
             ID,
             BENCHMARK,
             BENCHMARK_NAME,
             FIELD_ID,
             CLAIM_TYPE,
             ''                                         AS DUM1,
             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')    AS BENCHMARK_THRESHOLD,
             ''                                         AS DUM2,
             A_CLM,
             CASE
                 WHEN A_ACT_4 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (A_ACT_4 < BENCHMARK_THRESHOLD * 100)
                               AND (A_ACT_4 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (A_ACT_4 / 100, '9.9999')
                     END
             END                                        AS A_ACT_4_S,
             CASE
                 WHEN A_ACT_3 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (A_ACT_3 < BENCHMARK_THRESHOLD * 100)
                               AND (A_ACT_3 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (A_ACT_3 / 100, '9.9999')
                     END
             END                                        AS A_ACT_3_S,
             CASE
                 WHEN A_ACT_2 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (A_ACT_2 < BENCHMARK_THRESHOLD * 100)
                               AND (A_ACT_2 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (A_ACT_2 / 100, '9.9999')
                     END
             END                                        AS A_ACT_2_S,
             CASE
                 WHEN A_ACT_1 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (A_ACT_1 < BENCHMARK_THRESHOLD * 100)
                               AND (A_ACT_1 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (A_ACT_1 / 100, '9.9999')
                     END
             END                                        AS A_ACT_1_S,
             ''                                         AS DUM3,
             B_CLM,
             CASE
                 WHEN B_ACT_5 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (B_ACT_5 < BENCHMARK_THRESHOLD * 100)
                               AND (B_ACT_5 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (B_ACT_5 / 100, '9.9999')
                     END
             END                                        AS B_ACT_5_S,
             CASE
                 WHEN B_ACT_4 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (B_ACT_4 < BENCHMARK_THRESHOLD * 100)
                               AND (B_ACT_4 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (B_ACT_4 / 100, '9.9999')
                     END
             END                                        AS B_ACT_4_S,
             CASE
                 WHEN B_ACT_3 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (B_ACT_3 < BENCHMARK_THRESHOLD * 100)
                               AND (B_ACT_3 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (B_ACT_3 / 100, '9.9999')
                     END
             END                                        AS B_ACT_3_S,
             CASE
                 WHEN B_ACT_2 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (B_ACT_2 < BENCHMARK_THRESHOLD * 100)
                               AND (B_ACT_2 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (B_ACT_2 / 100, '9.9999')
                     END
             END                                        AS B_ACT_2_S,
             ''                                         AS DUM4,
             C_CLM,
             CASE
                 WHEN C_ACT_6 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (C_ACT_6 < BENCHMARK_THRESHOLD * 100)
                               AND (C_ACT_6 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (C_ACT_6 / 100, '9.9999')
                     END
             END                                        AS C_ACT_6_S,
             CASE
                 WHEN C_ACT_5 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (C_ACT_5 < BENCHMARK_THRESHOLD * 100)
                               AND (C_ACT_5 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (C_ACT_5 / 100, '9.9999')
                     END
             END                                        AS C_ACT_5_S,
             CASE
                 WHEN C_ACT_4 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (C_ACT_4 < BENCHMARK_THRESHOLD * 100)
                               AND (C_ACT_4 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (C_ACT_4 / 100, '9.9999')
                     END
             END                                        AS C_ACT_4_S,
             CASE
                 WHEN C_ACT_3 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (C_ACT_3 < BENCHMARK_THRESHOLD * 100)
                               AND (C_ACT_3 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (C_ACT_3 / 100, '9.9999')
                     END
             END                                        AS C_ACT_3_S,
             ''                                         AS DUM5,
             D_CLM,
             CASE
                 WHEN D_ACT_7 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (D_ACT_7 < BENCHMARK_THRESHOLD * 100)
                               AND (D_ACT_7 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (D_ACT_7 / 100, '9.9999')
                     END
             END                                        AS D_ACT_7_S,
             CASE
                 WHEN D_ACT_6 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (D_ACT_6 < BENCHMARK_THRESHOLD * 100)
                               AND (D_ACT_6 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (D_ACT_6 / 100, '9.9999')
                     END
             END                                        AS D_ACT_6_S,
             CASE
                 WHEN D_ACT_5 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (D_ACT_5 < BENCHMARK_THRESHOLD * 100)
                               AND (D_ACT_5 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (D_ACT_5 / 100, '9.9999')
                     END
             END                                        AS D_ACT_5_S,
             CASE
                 WHEN D_ACT_4 IS NULL
                 THEN
                     '-'
                 ELSE
                     CASE
                         WHEN (    (D_ACT_4 < BENCHMARK_THRESHOLD * 100)
                               AND (D_ACT_4 + P.ADJ > BENCHMARK_THRESHOLD * 100))
                         THEN
                             TO_CHAR (BENCHMARK_THRESHOLD, '9.9999')
                         ELSE
                             TO_CHAR (D_ACT_4 / 100, '9.9999')
                     END
             END                                        AS D_ACT_4_S
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3,
             (SELECT CAST(PARAM_VALUE AS DECIMAL(10, 2)) AS ADJ
                FROM MHTEAM.DWDQ.INF_B_DQ_PARAMS
               WHERE PARAM_NAME = 'SC_ACTUALS_ROUND') P
       WHERE ACO != '+'
    ORDER BY RUN_DATE, ACO, ID;

    create or replace view MHTEAM.DWDQ.INF_SC_STEP3_2(
	RUN_DATE,
	PLAN,
	ACO
) as
      SELECT DISTINCT
             RUN_DATE,
             PLAN,
             CASE
                 WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                 WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                 WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                 ELSE ACO
             END    AS ACO
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3
       WHERE ACO != '+'
    ORDER BY RUN_DATE, ACO;

 create or replace view MHTEAM.DWDQ.INF_SC_STEP3_3(
	RUN_DATE,
	LAST_SUB_STR
) as
    SELECT DISTINCT RUN_DATE, LAST_SUB_STR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;

 create or replace view MHTEAM.DWDQ.INF_SC_STEP3_4(
	RUN_DATE,
	RUN_DATE_STR
) as
    SELECT DISTINCT RUN_DATE, RUN_DATE_STR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_5(
	RUN_DATE,
	A_CLM_HDR,
	B_CLM_HDR,
	C_CLM_HDR,
	D_CLM_HDR
) as
    SELECT DISTINCT RUN_DATE,
                    REPLACE (A_CLM_HDR, '_', '-')     AS A_CLM_HDR,
                    REPLACE (B_CLM_HDR, '_', '-')     AS B_CLM_HDR,
                    REPLACE (C_CLM_HDR, '_', '-')     AS C_CLM_HDR,
                    REPLACE (D_CLM_HDR, '_', '-')     AS D_CLM_HDR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_6(
	RUN_DATE,
	A_ACT_4_HDR,
	A_ACT_3_HDR,
	A_ACT_2_HDR,
	A_ACT_1_HDR,
	B_ACT_5_HDR,
	B_ACT_4_HDR,
	B_ACT_3_HDR,
	B_ACT_2_HDR,
	C_ACT_6_HDR,
	C_ACT_5_HDR,
	C_ACT_4_HDR,
	C_ACT_3_HDR,
	D_ACT_7_HDR,
	D_ACT_6_HDR,
	D_ACT_5_HDR,
	D_ACT_4_HDR
) as
    SELECT DISTINCT RUN_DATE,
                    REPLACE (A_ACT_4_HDR, '_', '-')     AS A_ACT_4_HDR,
                    REPLACE (A_ACT_3_HDR, '_', '-')     AS A_ACT_3_HDR,
                    REPLACE (A_ACT_2_HDR, '_', '-')     AS A_ACT_2_HDR,
                    REPLACE (A_ACT_1_HDR, '_', '-')     AS A_ACT_1_HDR,
                    REPLACE (B_ACT_5_HDR, '_', '-')     AS B_ACT_5_HDR,
                    REPLACE (B_ACT_4_HDR, '_', '-')     AS B_ACT_4_HDR,
                    REPLACE (B_ACT_3_HDR, '_', '-')     AS B_ACT_3_HDR,
                    REPLACE (B_ACT_2_HDR, '_', '-')     AS B_ACT_2_HDR,
                    REPLACE (C_ACT_6_HDR, '_', '-')     AS C_ACT_6_HDR,
                    REPLACE (C_ACT_5_HDR, '_', '-')     AS C_ACT_5_HDR,
                    REPLACE (C_ACT_4_HDR, '_', '-')     AS C_ACT_4_HDR,
                    REPLACE (C_ACT_3_HDR, '_', '-')     AS C_ACT_3_HDR,
                    REPLACE (D_ACT_7_HDR, '_', '-')     AS D_ACT_7_HDR,
                    REPLACE (D_ACT_6_HDR, '_', '-')     AS D_ACT_6_HDR,
                    REPLACE (D_ACT_5_HDR, '_', '-')     AS D_ACT_5_HDR,
                    REPLACE (D_ACT_4_HDR, '_', '-')     AS D_ACT_4_HDR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;
      
create or replace view MHTEAM.DWDQ.INF_SC_STEP3_7(
	RUN_DATE,
	ACO,
	A_ACT_4_MISS,
	A_ACT_3_MISS,
	A_ACT_2_MISS,
	A_ACT_1_MISS,
	B_ACT_5_MISS,
	B_ACT_4_MISS,
	B_ACT_3_MISS,
	B_ACT_2_MISS,
	C_ACT_6_MISS,
	C_ACT_5_MISS,
	C_ACT_4_MISS,
	C_ACT_3_MISS,
	D_ACT_7_MISS,
	D_ACT_6_MISS,
	D_ACT_5_MISS,
	D_ACT_4_MISS
) as
      SELECT RUN_DATE,
             ACO,
             SUM (A_ACT_4_BEN)     AS A_ACT_4_MISS,
             SUM (A_ACT_3_BEN)     AS A_ACT_3_MISS,
             SUM (A_ACT_2_BEN)     AS A_ACT_2_MISS,
             SUM (A_ACT_1_BEN)     AS A_ACT_1_MISS,
             SUM (B_ACT_5_BEN)     AS B_ACT_5_MISS,
             SUM (B_ACT_4_BEN)     AS B_ACT_4_MISS,
             SUM (B_ACT_3_BEN)     AS B_ACT_3_MISS,
             SUM (B_ACT_2_BEN)     AS B_ACT_2_MISS,
             SUM (C_ACT_6_BEN)     AS C_ACT_6_MISS,
             SUM (C_ACT_5_BEN)     AS C_ACT_5_MISS,
             SUM (C_ACT_4_BEN)     AS C_ACT_4_MISS,
             SUM (C_ACT_3_BEN)     AS C_ACT_3_MISS,
             SUM (D_ACT_7_BEN)     AS D_ACT_7_MISS,
             SUM (D_ACT_6_BEN)     AS D_ACT_6_MISS,
             SUM (D_ACT_5_BEN)     AS D_ACT_5_MISS,
             SUM (D_ACT_4_BEN)     AS D_ACT_4_MISS
        FROM (  SELECT RUN_DATE,
                       CASE
                           WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                           WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                           WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                           ELSE ACO
                       END    AS ACO,
                       ID,
                       CASE
                           WHEN A_ACT_4 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN A_ACT_4 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS A_ACT_4_BEN,
                       CASE
                           WHEN A_ACT_3 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN A_ACT_3 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS A_ACT_3_BEN,
                       CASE
                           WHEN A_ACT_2 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN A_ACT_2 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS A_ACT_2_BEN,
                       CASE
                           WHEN A_ACT_1 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN A_ACT_1 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS A_ACT_1_BEN,
                       CASE
                           WHEN B_ACT_5 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN B_ACT_5 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS B_ACT_5_BEN,
                       CASE
                           WHEN B_ACT_4 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN B_ACT_4 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS B_ACT_4_BEN,
                       CASE
                           WHEN B_ACT_3 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN B_ACT_3 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS B_ACT_3_BEN,
                       CASE
                           WHEN B_ACT_2 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN B_ACT_2 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS B_ACT_2_BEN,
                       CASE
                           WHEN C_ACT_6 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN C_ACT_6 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS C_ACT_6_BEN,
                       CASE
                           WHEN C_ACT_5 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN C_ACT_5 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS C_ACT_5_BEN,
                       CASE
                           WHEN C_ACT_4 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN C_ACT_4 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS C_ACT_4_BEN,
                       CASE
                           WHEN C_ACT_3 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN C_ACT_3 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS C_ACT_3_BEN,
                       CASE
                           WHEN D_ACT_7 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN D_ACT_7 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS D_ACT_7_BEN,
                       CASE
                           WHEN D_ACT_6 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN D_ACT_6 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS D_ACT_6_BEN,
                       CASE
                           WHEN D_ACT_5 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN D_ACT_5 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS D_ACT_5_BEN,
                       CASE
                           WHEN D_ACT_4 IS NULL
                           THEN
                               NULL
                           ELSE
                               CASE
                                   WHEN D_ACT_4 + P.ADJ <
                                        BENCHMARK_THRESHOLD * 100
                                   THEN
                                       1
                                   ELSE
                                       0
                               END
                       END    AS D_ACT_4_BEN
                  FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3,
                       (SELECT CAST(PARAM_VALUE AS DECIMAL(10, 2)) AS ADJ
                          FROM MHTEAM.DWDQ.INF_B_DQ_PARAMS
                         WHERE PARAM_NAME = 'SC_ACTUALS_ROUND') P
                 WHERE ACO != '+'
              ORDER BY ACO, ID)
    GROUP BY RUN_DATE, ACO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_8_CLM_ACT_HDRS(
	RUN_DATE_STR,
	LAST_SUB_STR,
	RUN_DATE,
	DQ_BATCH_SEQ,
	A_CLM_HDR,
	A_ACT_4_HDR,
	A_ACT_3_HDR,
	A_ACT_2_HDR,
	A_ACT_1_HDR,
	B_CLM_HDR,
	B_ACT_5_HDR,
	B_ACT_4_HDR,
	B_ACT_3_HDR,
	B_ACT_2_HDR,
	C_CLM_HDR,
	C_ACT_6_HDR,
	C_ACT_5_HDR,
	C_ACT_4_HDR,
	C_ACT_3_HDR,
	D_CLM_HDR,
	D_ACT_7_HDR,
	D_ACT_6_HDR,
	D_ACT_5_HDR,
	D_ACT_4_HDR
) as
    SELECT DISTINCT RUN_DATE_STR,
                    LAST_SUB_STR,
                    RUN_DATE,
                    DQ_BATCH_SEQ,
                    A_CLM_HDR,
                    A_ACT_4_HDR,
                    A_ACT_3_HDR,
                    A_ACT_2_HDR,
                    A_ACT_1_HDR,
                    B_CLM_HDR,
                    B_ACT_5_HDR,
                    B_ACT_4_HDR,
                    B_ACT_3_HDR,
                    B_ACT_2_HDR,
                    C_CLM_HDR,
                    C_ACT_6_HDR,
                    C_ACT_5_HDR,
                    C_ACT_4_HDR,
                    C_ACT_3_HDR,
                    D_CLM_HDR,
                    D_ACT_7_HDR,
                    D_ACT_6_HDR,
                    D_ACT_5_HDR,
                    D_ACT_4_HDR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3;
                              
create or replace view MHTEAM.DWDQ.INF_SC_STEP3_9_DATE_STRINGS(
	RUN_DATE,
	IA,
	IB,
	IC,
	ID,
	IALL
) as
    SELECT RUN_DATE,
           IA,
           IB,
           IC,
           ID,
           IA || ', ' || IB || ', ' || IC || ', ' || ID     AS IALL
      FROM (SELECT DISTINCT
                   RUN_DATE,
                          TRIM (
                              TO_CHAR (TO_DATE (A_CLM_HDR, 'YYYY_MM'),
                                       'MMMM'))
                   || ' '
                   || TO_CHAR (TO_DATE (A_CLM_HDR, 'YYYY_MM'), 'YYYY')    IA,
                          TRIM (
                              TO_CHAR (TO_DATE (B_CLM_HDR, 'YYYY_MM'),
                                       'MMMM'))
                   || ' '
                   || TO_CHAR (TO_DATE (B_CLM_HDR, 'YYYY_MM'), 'YYYY')    IB,
                          TRIM (
                              TO_CHAR (TO_DATE (C_CLM_HDR, 'YYYY_MM'),
                                       'MMMM'))
                   || ' '
                   || TO_CHAR (TO_DATE (C_CLM_HDR, 'YYYY_MM'), 'YYYY')    IC,
                          TRIM (
                              TO_CHAR (TO_DATE (D_CLM_HDR, 'YYYY_MM'),
                                       'MMMM'))
                   || ' '
                   || TO_CHAR (TO_DATE (D_CLM_HDR, 'YYYY_MM'), 'YYYY')    ID
              FROM INF_B_SC_STG_MCO_MBH_REP_STEP3);

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_10_TIMELINESS(
	RUN_DATE,
	DQ_BATCH_SEQ,
	MCO,
	ID,
	FILE_NAME,
	ZIP_FILE_CREATED,
	METADATA_DATE_CREATED,
	DATE_FILE_PROCESSED,
	MANUAL_OVERRIDE,
	AMENDMENT
) as
      SELECT "RUN_DATE",
             "DQ_BATCH_SEQ",
             "MCO",
             "ID",
             "FILE_NAME",
             "ZIP_FILE_CREATED",
             "METADATA_DATE_CREATED",
             "DATE_FILE_PROCESSED",
             "MANUAL_OVERRIDE",
             "AMENDMENT"
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_TIMELINESS
    ORDER BY run_date, mco, id;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_11_2(
	RUN_DATE,
	DQ_BATCH_SEQ,
	MCO,
	MONTH,
	ZIP_COUNT
) as
      SELECT RUN_DATE,
             DQ_BATCH_SEQ,
             MCO,
             TO_CHAR (metadata_date_created, 'YYYY_MM')     AS month,
             COUNT (DISTINCT FILE_NAME)                     ZIP_COUNT
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_TIMELINESS
    GROUP BY RUN_DATE,
             DQ_BATCH_SEQ,
             MCO,
             TO_CHAR (metadata_date_created, 'YYYY_MM')
    ORDER BY RUN_DATE, MCO, TO_CHAR (metadata_date_created, 'YYYY_MM');

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_12_TIMELINESS_COUNTS(
	RUN_DATE,
	MCO,
	M6,
	Z6,
	M5,
	Z5,
	M4,
	Z4,
	M3,
	Z3,
	M2,
	Z2,
	M1,
	Z1
) as
    WITH
        MNTH
        AS
            (SELECT RUN_DATE,
                    MCO,
                    MONTH,
                    ZIP_COUNT     AS ZC
               FROM MHTEAM.DWDQ.INF_SC_STEP3_11_2),
        FILL
        AS
            (SELECT DISTINCT
                    RUN_DATE,
                    MCO,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -0),
                             'YYYY_MM')    MON6,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -1),
                             'YYYY_MM')    MON5,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -2),
                             'YYYY_MM')    MON4,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -3),
                             'YYYY_MM')    MON3,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -4),
                             'YYYY_MM')    MON2,
                    TO_CHAR (ADD_MONTHS (TRUNC (RUN_DATE, 'MONTH'), -5),
                             'YYYY_MM')    MON1
               FROM MHTEAM.DWDQ.INF_SC_STEP3_11_2)
      SELECT                                                        --DISTINCT
             F.RUN_DATE,
             F.MCO,
             TO_CHAR (TO_DATE (F.MON6, 'YYYY_MM'), 'MM/DD/YYYY')     AS M6,
             NVL (M6.ZC, 0)                                          AS Z6,
             TO_CHAR (TO_DATE (F.MON5, 'YYYY_MM'), 'MM/DD/YYYY')     AS M5,
             NVL (M5.ZC, 0)                                          AS Z5,
             TO_CHAR (TO_DATE (F.MON4, 'YYYY_MM'), 'MM/DD/YYYY')     AS M4,
             NVL (M4.ZC, 0)                                          AS Z4,
             TO_CHAR (TO_DATE (F.MON3, 'YYYY_MM'), 'MM/DD/YYYY')     AS M3,
             NVL (M3.ZC, 0)                                          AS Z3,
             TO_CHAR (TO_DATE (F.MON2, 'YYYY_MM'), 'MM/DD/YYYY')     AS M2,
             NVL (M2.ZC, 0)                                          AS Z2,
             TO_CHAR (TO_DATE (F.MON1, 'YYYY_MM'), 'MM/DD/YYYY')     AS M1,
             NVL (M1.ZC, 0)                                          AS Z1
        FROM FILL F
             LEFT JOIN MNTH M6
                 ON     M6.RUN_DATE = F.RUN_DATE
                    AND M6.MCO = F.MCO
                    AND M6.MONTH = F.MON6
             LEFT JOIN MNTH M5
                 ON     M5.RUN_DATE = F.RUN_DATE
                    AND M5.MCO = F.MCO
                    AND M5.MONTH = F.MON5
             LEFT JOIN MNTH M4
                 ON     M4.RUN_DATE = F.RUN_DATE
                    AND M4.MCO = F.MCO
                    AND M4.MONTH = F.MON4
             LEFT JOIN MNTH M3
                 ON     M3.RUN_DATE = F.RUN_DATE
                    AND M3.MCO = F.MCO
                    AND M3.MONTH = F.MON3
             LEFT JOIN MNTH M2
                 ON     M2.RUN_DATE = F.RUN_DATE
                    AND M2.MCO = F.MCO
                    AND M2.MONTH = F.MON2
             LEFT JOIN MNTH M1
                 ON     M1.RUN_DATE = F.RUN_DATE
                    AND M1.MCO = F.MCO
                    AND M1.MONTH = F.MON1
    ORDER BY F.RUN_DATE, F.MCO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_13_ACO_NAMES(
	ACO,
	MCO_NAME,
	CONTACT_MGR,
	PERFORMANCE_MGR,
	SHEET_NAME,
	PLAN
) as
    SELECT MCOAPP     AS ACO,
           MCO_NAME,
           CONTACT_MGR,
           PERFORMANCE_MGR,
           SHEET_NAME,
           MCO        AS PLAN
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_MCO_NAME_LOOKUP;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_14_BENCHMARK_COUNT(
	BENCH_CNT,
	BENCH_STR
) as
    SELECT MAX (ID)                                  AS BENCH_CNT,
           'Out of' || TO_CHAR (MAX (ID), '999')     BENCH_STR
      FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_15_TIMELINESS_STRINGS(
	RUN_DATE,
	ACO,
	MA,
	MB,
	MC,
	MD,
	SA,
	SB,
	SC,
	SD
) as
      SELECT M.RUN_DATE,
             M.ACO,
                D.IA
             || ' submission: '
             || M.A_ACT_4_MISS
             || ' benchmark(s) missed'    AS MA,
                D.IB
             || ' submission: '
             || M.B_ACT_4_MISS
             || ' benchmark(s) missed'    AS MB,
                D.IC
             || ' submission: '
             || M.C_ACT_4_MISS
             || ' benchmark(s) missed'    AS MC,
                D.ID
             || ' submission: '
             || M.D_ACT_4_MISS
             || ' benchmark(s) missed'    AS MD,
             CASE
                 WHEN TO_NUMBER (M.A_ACT_4_MISS) = 0
                 THEN
                     'All measures currently meet completeness benchmarks'
                 ELSE
                     ' '
             END                          AS SA,
             CASE
                 WHEN TO_NUMBER (M.B_ACT_4_MISS) = 0
                 THEN
                     'All measures currently meet completeness benchmarks'
                 ELSE
                     ' '
             END                          AS SB,
             CASE
                 WHEN TO_NUMBER (M.C_ACT_4_MISS) = 0
                 THEN
                     'All measures currently meet completeness benchmarks'
                 ELSE
                     ' '
             END                          AS SC,
             CASE
                 WHEN TO_NUMBER (M.D_ACT_4_MISS) = 0
                 THEN
                     'All measures currently meet completeness benchmarks'
                 ELSE
                     ' '
             END                          AS SD
        FROM MHTEAM.DWDQ.INF_SC_STEP3_7 M
             JOIN MHTEAM.DWDQ.INF_SC_STEP3_9_DATE_STRINGS D ON M.RUN_DATE = D.RUN_DATE
    ORDER BY RUN_DATE, ACO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_16_ACO_RUNDATE(
	PLAN,
	ACO,
	RUN_DATE,
	DATE_STR,
	SHEET_NAME
) as
      SELECT DISTINCT
             MCO
                 AS PLAN,
             MCOAPP
                 AS ACO,
             TO_CHAR (TO_DATE (PARAM_VALUE, 'YYYYMMDD'), 'DD-MON-YYYY')
                 AS RUN_DATE,
                TRIM(UPPER(TO_CHAR (TO_DATE (PARAM_VALUE, 'YYYYMMDD'), 'MMMM'))) 
                --TRIM (TO_CHAR (TO_DATE (PARAM_VALUE, 'YYYYMMDD'), 'MONTH'))
             || TO_CHAR (TO_DATE (PARAM_VALUE, 'YYYYMMDD'), '_YYYY')
                 AS DATE_STR,
             SHEET_NAME
        FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_MCO_NAME_LOOKUP, MHTEAM.DWDQ.INF_B_DQ_PARAMS
       WHERE PARAM_NAME = 'SC_RUN_DATE'
    ORDER BY PLAN, ACO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_17_ACO_FAILS(
	RUN_DATE,
	DQ_BATCH_SEQ,
	ID,
	BENCHMARK,
	CDE_ENC_MCO,
	CDE_ENC_ACO,
	ENC_CLAIM_NO,
	ENC_CLAIM_SUFFIX,
	CDE_CLM_DISPOSITION,
	DOS_FROM,
	CLAIM_TYPE,
	ETL_CHECK,
	DESC1,
	VALUE1,
	DESC2,
	VALUE2,
	DESC3,
	VALUE3,
	DESC4,
	VALUE4,
	DESC5,
	VALUE5
) as
      SELECT RUN_DATE,
             DQ_BATCH_SEQ,
             ID,
             BENCHMARK,
             CDE_ENC_MCO,
             CASE
                 WHEN CDE_ENC_ACO = 'NA' AND CDE_ENC_MCO = 'BMC' THEN 'WLS'
                 WHEN CDE_ENC_ACO = 'NA' AND CDE_ENC_MCO = 'CHA' THEN 'THP'
                 WHEN CDE_ENC_ACO = 'NA' AND CDE_ENC_MCO = 'MBH' THEN 'MBH'
                 ELSE CDE_ENC_ACO
             END                                 CDE_ENC_ACO,
             ENC_CLAIM_NO,
             ENC_CLAIM_SUFFIX,
             CDE_CLM_DISPOSITION,
             TO_CHAR (DOS_FROM, 'MM/DD/YYYY')    AS DOS_FROM,
             CLAIM_TYPE,
             ETL_CHECK,
             DESC1,
             VALUE1,
             DESC2,
             VALUE2,
             DESC3,
             VALUE3,
             DESC4,
             VALUE4,
             DESC5,
             VALUE5
        FROM ((SELECT f."RUN_DATE",
                      f."DQ_BATCH_SEQ",
                      f."ID",
                      f."BENCHMARK",
                      f."CDE_ENC_MCO",
                      f."CDE_ENC_ACO",
                      f."ENC_CLAIM_NO",
                      f."ENC_CLAIM_SUFFIX",
                      f."CDE_CLM_DISPOSITION",
                      f."DOS_FROM",
                      f."CLAIM_TYPE",
                      f."ETL_CHECK",
                      f."DESC1",
                      f."VALUE1",
                      f."DESC2",
                      f."VALUE2",
                      f."DESC3",
                      f."VALUE3",
                      f."DESC4",
                      f."VALUE4",
                      f."DESC5",
                      f."VALUE5"
                 FROM (  SELECT RUN_DATE,
                                DQ_BATCH_SEQ,
                                ID,
                                BENCHMARK,
                                CDE_ENC_MCO,
                                CASE
                                    WHEN CDE_ENC_ACO = '#' THEN 'NA'
                                    ELSE CDE_ENC_ACO
                                END    AS CDE_ENC_ACO,
                                ENC_CLAIM_NO,
                                ENC_CLAIM_SUFFIX,
                                CDE_CLM_DISPOSITION,
                                DOS_FROM,
                                CLAIM_TYPE,
                                ETL_CHECK,
                                DESC1,
                                VALUE1,
                                DESC2,
                                VALUE2,
                                DESC3,
                                VALUE3,
                                DESC4,
                                VALUE4,
                                DESC5,
                                VALUE5
                           FROM (SELECT RUN_DATE,
                                        DQ_BATCH_SEQ,
                                        ID,
                                        BENCHMARK,
                                        FIELD_ID,
                                        BENCHMARK_THRESHOLD,
                                        CDE_ENC_MCO,
                                        CDE_ENC_ACO,
                                        ENC_CLAIM_NO,
                                        ENC_CLAIM_SUFFIX,
                                        CDE_CLM_DISPOSITION,
                                        DOS_FROM,
                                        CLAIM_TYPE,
                                        ETL_CHECK,
                                        DESC1,
                                        CASE
                                            WHEN (    DESC1 IS NOT NULL
                                                  AND (   VALUE1 IS NULL
                                                       OR VALUE1 IN ('+',
                                                                     '-',
                                                                     '#',
                                                                     '',
                                                                     ' ',
                                                                     'Unknown')))
                                            THEN
                                                'Missing or Invalid'
                                            ELSE
                                                VALUE1
                                        END                                AS VALUE1,
                                        DESC2,
                                        CASE
                                            WHEN (    DESC2 IS NOT NULL
                                                  AND (   VALUE2 IS NULL
                                                       OR VALUE2 IN ('+',
                                                                     '-',
                                                                     '#',
                                                                     '',
                                                                     ' ',
                                                                     'Unknown')))
                                            THEN
                                                'Missing or Invalid'
                                            ELSE
                                                VALUE2
                                        END                                AS VALUE2,
                                        DESC3,
                                        CASE
                                            WHEN (    DESC3 IS NOT NULL
                                                  AND (   VALUE3 IS NULL
                                                       OR VALUE3 IN ('+',
                                                                     '-',
                                                                     '#',
                                                                     '',
                                                                     ' ',
                                                                     'Unknown')))
                                            THEN
                                                'Missing or Invalid'
                                            ELSE
                                                VALUE3
                                        END                                AS VALUE3,
                                        DESC4,
                                        CASE
                                            WHEN (    DESC4 IS NOT NULL
                                                  AND (   VALUE4 IS NULL
                                                       OR VALUE4 IN ('+',
                                                                     '-',
                                                                     '#',
                                                                     '',
                                                                     ' ',
                                                                     'Unknown')))
                                            THEN
                                                'Missing or Invalid'
                                            ELSE
                                                VALUE4
                                        END                                AS VALUE4,
                                        DESC5,
                                        CASE
                                            WHEN (    DESC5 IS NOT NULL
                                                  AND (   VALUE5 IS NULL
                                                       OR VALUE5 IN ('+',
                                                                     '-',
                                                                     '#',
                                                                     '',
                                                                     ' ',
                                                                     'Unknown')))
                                            THEN
                                                'Missing or Invalid'
                                            ELSE
                                                VALUE5
                                        END                                AS VALUE5,
                                        RANK ()
                                            OVER (PARTITION BY RUN_DATE,
                                                               CDE_ENC_MCO,
                                                               CDE_ENC_ACO,
                                                               ID
                                                  ORDER BY
                                                      RUN_DATE,
                                                      CDE_ENC_MCO,
                                                      CDE_ENC_ACO,
                                                      ID,
                                                      ENC_CLAIM_NO,
                                                      ENC_CLAIM_SUFFIX)    AS rnk
                                   FROM INF_B_SC_STG_MCO_MBH_REP_FAILS)
                          WHERE rnk <= 25
                       ORDER BY ID, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX) f,
                      (SELECT RUN_DATE,
                              ACO,
                              ID,
                              CASE
                                  WHEN (D_ACT_4 IS NULL OR D_ACT_4 = 0)
                                  THEN
                                      0                                 --NULL
                                  ELSE
                                      CASE
                                          WHEN D_ACT_4 + p.ADJ <
                                               BENCHMARK_THRESHOLD * 100
                                          THEN
                                              1
                                          ELSE
                                              0
                                      END
                              END    AS MISS
                         FROM INF_B_SC_STG_MCO_MBH_REP_STEP3,
--                              (SELECT TO_NUMBER (PARAM_VALUE, '9.9999')    AS ADJ
                                 (SELECT CAST(PARAM_VALUE AS DECIMAL(10, 2)) AS ADJ
                                 FROM INF_B_DQ_PARAMS
                                WHERE PARAM_NAME = 'SC_ACTUALS_ROUND') p
                        WHERE ACO != '+') m
                WHERE     1 = 1
                      AND m.run_date = f.run_date
                      AND m.aco = f.cde_enc_aco
                      AND m.id = f.id
                      AND m.miss = 1))
    ORDER BY RUN_DATE,
             CDE_ENC_MCO,
             CDE_ENC_ACO,
             ID;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_18_SUMMARY(
	RUN_DATE,
	PLAN,
	ACO,
	MISSED_BENCHMARKS,
	ACTUALS_WITH_ZERO
) as
      SELECT DISTINCT m.RUN_DATE,
                      m.PLAN,
                      m.ACO,
                      D_ACT_4_MISS     AS MISSED_BENCHMARKS,
                      D_ACT_4_ZERO     AS ACTUALS_WITH_ZERO
        FROM (  SELECT RUN_DATE,
                       PLAN,
                       ACO,
                       SUM (D_ACT_4_BEN)     AS D_ACT_4_MISS
                  FROM (  SELECT RUN_DATE,
                                 PLAN,
                                 CASE WHEN ACO = 'NA' THEN PLAN ELSE ACO END
                                     AS ACO,
                                 ID,
                                 CASE
                                     WHEN D_ACT_4 IS NULL
                                     THEN
                                         NULL
                                     ELSE
                                         CASE
                                             WHEN (    (D_ACT_4 + P.ADJ <
                                                        BENCHMARK_THRESHOLD * 100)
                                                   AND (D_ACT_4 != 0))
                                             THEN
                                                 1
                                             ELSE
                                                 0
                                         END
                                 END
                                     AS D_ACT_4_BEN
                            FROM INF_B_SC_STG_MCO_MBH_REP_STEP3,
--                                 (SELECT TO_NUMBER (PARAM_VALUE, '9.9999')    AS ADJ
                                   (SELECT CAST(PARAM_VALUE AS DECIMAL(10, 2)) AS ADJ
                                   FROM INF_B_DQ_PARAMS
                                   WHERE PARAM_NAME = 'SC_ACTUALS_ROUND') P
                           WHERE CASE
                                     WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                                     WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                                     WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                                     ELSE ACO
                                 END IN
                                     (SELECT MCOAPP
                                        FROM INF_B_SC_STG_MCO_MBH_MCO_NAME_LOOKUP)
                        ORDER BY PLAN, ACO, ID)
              GROUP BY RUN_DATE, PLAN, ACO) m
             FULL JOIN
             (  SELECT RUN_DATE,
                       PLAN,
                       ACO,
                       SUM (D_ACT_4_BEN)     AS D_ACT_4_ZERO
                  FROM (  SELECT RUN_DATE,
                                 PLAN,
                                 CASE WHEN ACO = 'NA' THEN PLAN ELSE ACO END
                                     AS ACO,
                                 ID,
                                 CASE
                                     WHEN D_ACT_4 IS NULL THEN NULL
                                     ELSE CASE WHEN (D_ACT_4 = 0) THEN 1 ELSE 0 END
                                 END
                                     AS D_ACT_4_BEN
                            FROM INF_B_SC_STG_MCO_MBH_REP_STEP3,
--                                 (SELECT TO_NUMBER (PARAM_VALUE, '9.9999')    AS ADJ
                                  (SELECT CAST(PARAM_VALUE AS DECIMAL(10, 2)) AS ADJ
                                    FROM INF_B_DQ_PARAMS
                                   WHERE PARAM_NAME = 'SC_ACTUALS_ROUND') P
                           WHERE CASE
                                     WHEN ACO = 'NA' AND PLAN = 'BMC' THEN 'WLS'
                                     WHEN ACO = 'NA' AND PLAN = 'CHA' THEN 'THP'
                                     WHEN ACO = 'NA' AND PLAN = 'MBH' THEN 'MBH'
                                     ELSE ACO
                                 END IN
                                     (SELECT MCOAPP
                                        FROM INF_B_SC_STG_MCO_MBH_MCO_NAME_LOOKUP)
                        ORDER BY PLAN, ACO, ID)
              GROUP BY RUN_DATE, PLAN, ACO) z
                 ON m.RUN_DATE = z.RUN_DATE AND m.ACO = Z.ACO
       WHERE (D_ACT_4_MISS > 0 OR D_ACT_4_ZERO > 0)
    ORDER BY RUN_DATE, PLAN, ACO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_19_PLAN_EMAIL_BODY(
	DATE_STR,
	RUN_DATE,
	PLAN,
	EMAIL_BODY,
	EMAIL_RECIPIENT_TABLE,
	SFTP_FOLDER,
	DEPLOY_STAGE
) as
    SELECT DISTINCT DATE_STR,
                    RUN_DATE,
                    PLAN,
                    EMAIL_BODY,
                    EMAIL_RECIPIENT_TABLE,
                    SFTP_FOLDER,
                    DEPLOY_STAGE
      FROM (SELECT date_str,
                   run_date,
                   plan,
                   a || b || c     AS email_body
              FROM (  SELECT date_str,
                             run_date,
                             plan,
                             a,
                             LISTAGG (b, ',') WITHIN GROUP (ORDER BY plan, b)
                                 AS b,
                             c
                        FROM (  SELECT date_str,
                                       run_date,
                                       plan,
                                          'ACO reports were generated and are available on the SFTP server in folder: <br/>/'
                                       -- JPL 11/15/2024 MBH is data but folder is mbhp
                                       || LOWER (
                                              CASE
                                                  WHEN plan = 'MBH' THEN 'MBHP'
                                                  ELSE plan
                                              END)
                                       || '/scorecard/prod/from_ehs <br/><br/>In zip file:<br/> MCO-ACPP_Encounter_Data_Scorecard_'
                                       || UPPER (plan)
                                       || '_'
                                       || date_str
                                       || '.zip<br/><br/>It includes these reports:'
                                           a,
                                          '<br/>MCO-ACPP Encounter Data Scorecard_'
                                       || sheet_name
                                       || '_'
                                       || date_str
                                       || '.xlsx'
                                           b,
                                          '<br/><br/>Sincerely,<br/>EHS Data Integrity'
                                       || '<br/><br/><i>This is an automatically generated email.  if you would like to be removed from this monthly <br/>email distribution list about your plan''s encounter performance, kindly reply to this email and let <br/>us know.</i><br/>'
                                           c
                                  FROM MHTEAM.DWDQ.INF_SC_STEP3_16_ACO_RUNDATE
                              ORDER BY date_str,
                                       run_date,
                                       plan,
                                       sheet_name)
                    GROUP BY date_str,
                             run_date,
                             plan,
                             a,
                             c
                    ORDER BY date_str,
                             run_date,
                             plan,
                             a,
                             c)) I
           INNER JOIN MHTEAM.DWDQ.INF_B_SC_MCO_CONTROL C ON I.PLAN = C.MCO;

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_20_INTERNAL_EMAIL_BODY(
	DATE_STR,
	RUN_DATE,
	EMAIL_BODY
) as
    SELECT DISTINCT date_str, run_date, a || b || c AS email_body
      FROM (  SELECT date_str,
                     run_date,
                     a,
                     LISTAGG (b, ',') WITHIN GROUP (ORDER BY b)     AS b,
                     c
                FROM (  SELECT date_str,
                               run_date,
                                  'Fails Summary Report: <br/>MCO-ACPP Encounter Data Missed Benchmarks_'
                               || date_str
                               || '.xlsx <br/>Please click on the attached spreadsheet.  If it is empty then there were no Fails.<br/><br/>'
                               || 'And zip file of all ACO Reports: <br/>'
                               || date_str
                               || '_ACO.zip<br/><br/>It includes these reports:'
                                   a,
                                  '<br/>MCO-ACPP Encounter Data Scorecard_'
                               || sheet_name
                               || '_'
                               || date_str
                               || '.xlsx'
                                   b,
                               '<br/><br/>Sincerely,<br/>EHS Data Integrity'
                                   c
                          FROM MHTEAM.DWDQ.INF_SC_STEP3_16_ACO_RUNDATE
                      ORDER BY date_str, run_date, sheet_name)
            GROUP BY date_str,
                     run_date,
                     a,
                     c
            ORDER BY date_str,
                     run_date,
                     a,
                     c);

create or replace view MHTEAM.DWDQ.INF_SC_STEP3_21_DOS_MONTH(
	RUN_DATE,
	DOS_MONTH
) as
    SELECT DISTINCT
           RUN_DATE,
              TRIM(TO_CHAR (TO_DATE (D_CLM_HDR, 'YYYY_MM'), 'MMMM'))
           || ' Dates of Service only'    DOS_MONTH
      FROM INF_B_SC_STG_MCO_MBH_REP_STEP3;
      
                                                                                       