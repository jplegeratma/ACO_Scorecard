-- ACO SQL from Informatica
-- Includes latest Nicole SQL, SQL for Timeliness and Fails, and SQL for Mapplet data Step1 - Step3

CREATE TABLE MHTEAM.DWDQ.INF_B_SC_MCO_MBHP_DOS_~MON_output~
AS
SELECT
         TO_DATE('~ASOFDT_output~','YYYYMMDD') AS RUN_DATE, 
         ENC.CDE_ENC_MCO, 
         ENC.CDE_ENC_ACO, 
         CASE WHEN ENC.CDE_ENC_ACO in('#','+','-') THEN 'NA' ELSE ENC.CDE_ENC_ACO END AS ACO, 
         MEM.ID_MEDICAID, 
         ENCATT.CDE_ENC_REC_IND, 
         ENCATT.DSC_ENC_REC_IND, 
         ENC.DOS_FROM_DT AS DOS_FROM, 
         ENC.DOS_TO_DT AS DOS_THRU, 
         ENC.REMIT_FROM_DT AS PAID_DT, 
         ENC.ADMIT_DT, 
         ENC.DISCHARGE_DT, 
         ENC.DATE_SCRIPT_WRITTEN, 
         ENC.QTY_REFILL, 
         ENC.QTY_UNITS_BILLED, 
         ENC.RX_NUMBER, 
         ENC.AMT_NDC_PROFEE, 
         ENC.ENCSRGGRP_SEQ, 
         DIAGGRP.CDE_DIAG_ADMIT, 
         DIAGGRP.DSC_DIAG_ADMIT, 
         CSA.CDE_PATIENT_STATUS, 
         CSA.DSC_PATIENT_STATUS, 
         DIAGGRP.CDE_DIAG_1 AS PRIMARY_DIAG, 
         DIAGGRP.DSC_DIAG_1 AS PRIMARY_DIAG_DESC, 
         DIAGGRP.CDE_ICD_VERSION, 
         DIAGGRP.DIAGRP_SEQ, 
         CSA.CDE_ADMIT_TYPE, 
         CSA.DSC_ADMIT_TYPE, 
         CSA.CDE_ADMIT_SOURCE, 
         NCF.CDE_ENC_PROC AS PROC_CODE_ENC, 
         NCF.DSC_ENC_PROC AS PROC_CODE_ENC_DESC, 
         PROC.CDE_PROC AS PROC_CODE, 
         PROC.DSC_PROC AS PROC_CODE_DESC, 
         MFR.CDE_PROC_MOD AS PROC_MODIFIER1,
         MFR.DSC_PROC_MOD AS PROC_MODIFIER1_DESC,
         MFR.CDE_PROC_MOD_2 AS PROC_MODIFIER2,
         MFR.DSC_PROC_MOD_2 AS PROC_MODIFIER2_DESC,
         MFR.CDE_PROC_MOD_3 AS PROC_MODIFIER3,
         MFR.DSC_PROC_MOD_3 AS PROC_MODIFIER3_DESC,
         MFR.CDE_PROC_MOD_4 AS PROC_MODIFIER4,
         MFR.DSC_PROC_MOD_4 AS PROC_MODIFIER4_DESC,
         NCF.CDE_ENC_PROC_TYPE, 
         NCF.DSC_ENC_PROC_TYPE, 
         CSA.CDE_REVENUE, 
         CSA.DSC_REVENUE, 
         CSA.CDE_PLACE_OF_SERVICE, 
         CSA.DSC_PLACE_OF_SERVICE, 
         SUBSTR(CSA.CDE_PLACE_OF_SERVICE,2,2) AS PLACE_OF_SERVICE, 
         SUBSTR(CSA.CDE_PLACE_OF_SERVICE,1,1) AS PLACE_OF_SERVICE_TYPE, 
         CSA.CDE_PLACE_OF_SERVICE_ENC, 
         CSA.CDE_TYPE_OF_BILL, 
         CSA.CDE_TYPE_OF_BILL_ENC, 
         CSA.CDE_BILL_FREQ, 
         SVC_PROV.ID_PROVIDER AS SERV_PROV_ID, 
         SVC_PROV.ENC_PROV_ID AS ENC_SERV_PROV_ID, 
         SVC_PROV.DSC_ENC_PROV_ID_TYPE AS SERV_PROV_ID_TYPE, 
         SVC_PROV.ID_NPI AS SERV_NPI, 
         SVC_PROV.CDE_ENC_PROV_TYPE AS ENC_SERV_PROV_TYPE, 
         SVC_PROV.CDE_ENC_PROV_ID_LOC AS SERV_PROV_ID_LOC_CODE, 
         NCF.CDE_ENC_PROV_SPEC AS SERV_PROV_SPECIALTY,
         PROV.ID_PROVIDER AS BILL_PROV_ID, 
         PROV.ENC_PROV_ID AS ENC_BILL_PROV_ID, 
         PROV.DSC_ENC_PROV_ID_TYPE AS BILL_PROV_ID_TYPE, 
         PROV.CDE_ENC_PROV_ID_LOC AS BILL_PROV_ID_LOC_CODE, 
         PROV.ID_NPI AS BILL_NPI, 
         PRS_PROV.ID_PROVIDER AS PRES_PROV_ID, 
         PRS_PROV.ENC_PROV_ID AS ENC_PRES_PROV_ID, 
         PRS_PROV.DSC_ENC_PROV_ID_TYPE AS PRES_PROV_ID_TYPE, 
         PRS_PROV.CDE_ENC_PROV_ID_LOC AS PRS_PROV_ID_LOC_CODE, 
         DRG.CDE_DRUG_CLASS, 
         DRG.CDE_NDC, 
         ENC.CDE_CLM_TYPE AS CLAIM_TYPE, 
         ENC.ENC_CLAIM_NO, 
         ENC.ENC_CLAIM_SUFFIX, 
         ENC.AMT_PAID, 
         ENC.AMT_BILLED, 
         ENC.AMT_ALLOWED, 
         ENC.CDE_CLM_DISPOSITION, 
         ENC.AMT_TPL, 
         ENC.AMT_COPAY, 
         ENC.AMT_COINSURANCE, 
         ENC.NUM_LOGICAL_CLAIM, 
         ENCATT.CDE_ENC_DISP_AS_WRTN, 
         ENCATT.DSC_ENC_DISP_AS_WRTN, 
         ENCATT.CDE_ENC_CLAIM_CAT, 
         ENCATT.DSC_ENC_CLAIM_CAT, 
         ENCATT.CDE_ENC_SVC_CAT, 
         ENCATT.DSC_ENC_SVC_CAT, 
         ENCATT.IND_ENC_COMPOUND 
         FROM MHDWPROD.NW.NW_ENCOUNTER_HIST ENC 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_ATTRIBUTE ENCATT ON ENC.ATTRENC_SEQ = ENCATT.ATTRENC_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_MEMBER MEM ON ENC.MEM_SEQ = MEM.MEM_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_DIAGNOSIS_GROUP DIAGGRP ON ENC.DIAGRP_SEQ = DIAGGRP.DIAGRP_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_CLAIM_SERVICE_ATTRIBUTE CSA ON ENC.ATTRSRV_SEQ = CSA.ATTRSRV_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_PROCEDURE PROC ON ENC.PROC_SEQ = PROC.PROC_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_PROCEDURE_MFR_GROUP MFR ON ENC.PROCMFRGRP_SEQ= MFR.PROCMFRGRP_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_DRUG DRG ON ENC.DRUG_SEQ = DRG.DRUG_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_PROVIDER PROV ON ENC.BILL_ENCPRV_SEQ = PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_PROVIDER SVC_PROV ON ENC.SRV_ENCPRV_SEQ = SVC_PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_PROVIDER REF_PROV ON ENC.REF_ENCPRV_SEQ = REF_PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_PROVIDER PRS_PROV ON ENC.PRS_ENCPRV_SEQ = PRS_PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN MHDWPROD.NW.NW_ENC_NONCONF_ATTRIBUTE NCF ON NCF.ATTRENC_NC_SEQ = ENC.ATTRENC_NC_SEQ 
         WHERE  ENC.DOS_FROM_DT BETWEEN TO_DATE('~MONS_output~','YYYYMMDD')
--                 AND ((TO_DATE('~MONS_output~', 'YYYYMMDD') + INTERVAL '4' MONTH ) -1)
                 AND ADD_MONTHS(TO_DATE('~MONS_output~','YYYYMMDD'),(4)) -1
         AND  ENC.REMIT_THRU_DT = TO_DATE('99991231','YYYYMMDD')
         AND TO_DATE('~ASOFDT_output~','YYYYMMDD') BETWEEN ENC.WH_FROM_DT AND ENC.WH_THRU_DT 
         AND ENC.CDE_CLM_DISPOSITION <> 'V' 
         AND ENC.IND_OFFSET = 'N' 
         AND ENC.CDE_ENC_MCO IN('BMC','CHA','FLN','NHP','HNE','MBH')
         --LIMIT 175
         ;

          CREATE TABLE MHTEAM.DWDQ.INF_B_SC_MCO_MBH_FRPDOS_~MON_output~
         AS
         SELECT
         TO_DATE('~ASOFDT_output~','YYYYMMDD') AS RUN_DATE,
         FIRSTX.CDE_ENC_MCO,
         firstx.DOS_YRMONTH,
         firstx.ACO,
         SUM(FIRSTX.ID_MEDICAID1) AS ID_MEDICAID2,
         	 SUM(FIRSTX.DOS_FROM1) AS DOS_FROM2,
         	 SUM(FIRSTX.DOS_THRU1) AS DOS_THRU2,
         	 SUM(FIRSTX.SERV_PROV_ID1) AS SERV_PROV_ID2,
         	 SUM(FIRSTX.SERV_PROV_ID_TYP1) AS SERV_PROV_ID_TYP2,
         SUM(FIRSTX.SERV_PROV_SPEC1) AS SERV_PROV_SPEC2,
         SUM(FIRSTX.BILL_PROV_ID1) AS BILL_PROV_ID2,
         SUM(FIRSTX.BILL_PROV_ID_TYP1) AS BILL_PROV_ID_TYP2,
         SUM(FIRSTX.PRESCRIBE_PROV1) AS PRESCRIBE_PROV2,
         SUM(FIRSTX.PRES_PROV_ID_TYP1) AS PRES_PROV_ID_TYP2,
         SUM(FIRSTX.PRIMARY_DIAG1) AS PRIMARY_DIAG2,
         SUM(FIRSTX.CDE_ICD_VERSION1) AS CDE_ICD_VERSION2,
         SUM(FIRSTX.PROC_CODE1) AS PROC_CODE2,
         SUM(FIRSTX.PROC_CODE1a) AS PROC_CODE2_m,  /*professional claims only*/
         SUM(FIRSTX.PROC_CODE1b) AS PROC_CODE2_o_d, /*outpt/dental claims only*/
         SUM(FIRSTX.PROC_MOD_DME) AS PROC_MOD_DME2,
         SUM(FIRSTX.PROC_MOD_LABXRAY) AS PROC_MOD_LABXRAY2,
         SUM(FIRSTX.PROC_MOD_SURGERYM) AS PROC_MOD_SURGERYM2,
         SUM(FIRSTX.QTY_UNITS_BILLED1) AS QTY_UNIT_BILL2,
         SUM(FIRSTX.BILL_PRV_NPI) AS BILL_NPI2,
         	 SUM(FIRSTX.SERV_PRV_NPI) AS SERV_NPI2,
         SUM(FIRSTX.SCRIPTWRIT1) AS SCRIPTWRIT2,
         	 SUM(FIRSTX.REFILL1) AS REFILL2,
         	 SUM(FIRSTX.DISPENSE1) AS DISPENSE2,
         SUM(FIRSTX.SCRIPT1) AS SCRIPT2,
         SUM(FIRSTX.FEE1) AS FEE2,
         	 SUM(FIRSTX.NDC1) AS NDC2,
         	 SUM(FIRSTX.CLAIMCAT1) AS CLAIMCAT2,
         SUM(FIRSTX.RECIND1) AS RECIND2,
         SUM(FIRSTX.AMTBILL1) AS AMTBILL2,
         SUM(FIRSTX.AMTPAY1) AS AMTPAY2,
         SUM(FIRSTX.AMTALLOW1) AS AMTALLOW2,
         SUM(FIRSTX.ADMITDT1) AS ADMITDT2,
         SUM(FIRSTX.DISCHARGE_DT1) AS DISCHARGEDT2,
         SUM(FIRSTX.CDE_DIAG_ADMIT1) AS CDE_DIAG_ADMIT2,
         SUM(FIRSTX.CDE_PATIENT_STATUS1) AS CDE_PATIENT_STATUS2,
         SUM(FIRSTX.CDE_ADMIT_TYPE1) AS CDE_ADMIT_TYPE2,
         SUM(FIRSTX.CDE_ADMIT_SOURCE1) AS CDE_ADMIT_SOURCE2,
         SUM(FIRSTX.SVCCAT1) AS SVCCAT2,
         SUM(FIRSTX.SERV_PROV_TYP1) AS SERV_PROV_TYP2,
         SUM(FIRSTX.REV_CODE1) AS REV_CODE2,
         SUM(FIRSTX.POS_CODE1) AS POS_CODE2,
         SUM(FIRSTX.POS_TYPE1) AS POS_TYPE2,
         SUM(FIRSTX.PAID_DT1) AS PAID_DT2,
         SUM(FIRSTX.BILL_ID_LOC1) AS BILL_ID_LOC2,
         SUM(FIRSTX.SERV_ID_LOC1) AS SERV_ID_LOC2,
         SUM(FIRSTX.PRS_ID_LOC1) AS PRS_ID_LOC2,
         SUM(FIRSTX.ACO1) AS ACO2,
         SUM(FIRSTX.AMTTPL1) AS AMTTPL2,
         SUM(FIRSTX.AMTCOPAY1) AS AMTCOPAY2,
         SUM(FIRSTX.AMTCOINS1) AS AMTCOINS2,
         SUM(FIRSTX.CLMDISP1) AS CLMDISP2,
         SUM(FIRSTX.CLMNUM1) AS CLMNUM2,
         SUM(FIRSTX.CLMSUF1) AS CLMSUF2,
         SUM(FIRSTX.NUMLOGCLM1) AS NUMLOGCLM2
         FROM
         /*********************************** SUB SELECT TO ASSESS AND ASSIGN VALUES *************************/
         (SELECT
         CDE_ENC_MCO,
         TO_CHAR(DOS_FROM,'YYYY-MM') AS DOS_YRMONTH,
         ACO,
         /* MEMBER ID - Field 76*/
         case when substr(MX.ID_MEDICAID,1,1) = '1' then 1 else 0 end ID_MEDICAID1,
         /* FROM DOS - Field 17 */
         case when MX.DOS_FROM IS NOT NULL THEN 1 else 0 end DOS_FROM1 ,
         /* THRU DOS - Field 18 */
         case when MX.DOS_THRU IS NOT NULL then 1 else 0 end DOS_THRU1 ,
         /*  SERVICING PROVIDER ID - Field 50*/
         CASE WHEN ENC_SERV_PROV_ID = '+' THEN 0
         WHEN ENC_SERV_PROV_ID = '-' THEN 0
         WHEN ENC_SERV_PROV_ID = ' ' THEN 0
         else 1
         END SERV_PROV_ID1,
         /* SERVICING PROVIDER ID TYPE - Field 51 */
         case when substr(SERV_PROV_ID_TYPE,1,1)  IN ('1','6','9')  then 1 else 0 end SERV_PROV_ID_TYP1 ,
         /* SERVICING PROVIDER TYPE */
         CASE WHEN ENC_SERV_PROV_TYPE NOT IN (' ','-','+','#') THEN 1 else 0 END SERV_PROV_TYP1,
         /* SERVICING SPECIALTY */
         CASE WHEN SERV_PROV_SPECIALTY NOT IN (' ','-','+','#') THEN 1 else 0 END SERV_PROV_SPEC1,
         /* BILLING PROVIDER ID - Field 58*/
         CASE WHEN MX.ENC_BILL_PROV_ID = '+' THEN 0
         WHEN MX.ENC_BILL_PROV_ID = '-' THEN 0
         WHEN MX.ENC_BILL_PROV_ID = ' ' THEN 0
         else 1
         END BILL_PROV_ID1 ,
         /* BILLING PROVIDER ID TYPE - Field 93 */
         case when substr(BILL_PROV_ID_TYPE,1,1)  IN ('1','6','9')  then 1 else 0 end BILL_PROV_ID_TYP1 ,
         /* PRESCRIBING PROVIDER ID - ON PHARM CLAIMS ONLY - Field 81 */
         CASE WHEN CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS='F' AND ENC_PRES_PROV_ID NOT IN ('+','-',' ') THEN 1
         else 0
         END PRESCRIBE_PROV1,
         /* PRESCRIBING PROVIDER ID TYPE - ON PHARM CLAIMS ONLY - Field 95 */
         case when CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND substr(MX.PRES_PROV_ID_TYPE,1,1) In ('1','6','8') then 1
         else 0
         END PRES_PROV_ID_TYP1,
         /* PRIMARY DIAGNOSIS */
         case when CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND primary_diag not in ('+','-', ' ') then 1 else 0 end as PRIMARY_DIAG1,
         /* CDE_ICD_VERSION */
         case when CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND cde_icd_version in('9','10')  and (ENCSRGGRP_SEQ>0 or diagrp_seq>0)
         then 1 else 0 end as CDE_ICD_VERSION1,
         /* PROC_CODE */ /*Note: Benchmark 100% M; 98% O,D*/
         case when CDE_ENC_REC_IND <> '0' AND  ((claim_type in('O') and
         (proc_code not in(' ','-','+','#') or ((cde_revenue between 250 and 259) or (cde_revenue = 260) or  (cde_revenue between 262 and 279) or
         (cde_revenue between 370 and 372) or (cde_revenue = 374) or (cde_revenue = 379) or (cde_revenue = 710) or
         (cde_revenue = 839) or (cde_revenue = 902) or (cde_revenue = 946) or (cde_revenue = 947) or (cde_revenue = 961) or
         (cde_revenue = 962) or (cde_revenue = 963) or (cde_revenue = 973) or (cde_revenue = 974) or (cde_revenue = 975) or
         (cde_revenue = 981) or (cde_revenue = 982) or (cde_revenue = 983) or (cde_revenue = 988)))) or
         (claim_type in('D','M') and proc_code not in(' ','-','+','#')) or
         (claim_type in ('O','D','M') and cde_enc_proc_type ='7' and proc_code_enc not in(' ','-','+','#')))
         then 1 else 0 end as proc_code1,
         /* PROC_CODE: professional claims only*/
         case when CDE_ENC_REC_IND <> '0' AND claim_type in('M') and (proc_code not in(' ','-','+','#') or (cde_enc_proc_type ='7' and proc_code_enc not in(' ','-','+','#')))
         then 1 else 0 end as proc_code1a,
         /* PROC_CODE: outpt and dental claims only*/
         case when CDE_ENC_REC_IND <> '0' AND ((claim_type in('O') and
         (proc_code not in(' ','-','+','#') or ((cde_revenue between 250 and 259) or (cde_revenue = 260) or  (cde_revenue between 262 and 279) or
         (cde_revenue between 370 and 372) or (cde_revenue = 374) or (cde_revenue = 379) or (cde_revenue = 710) or
         (cde_revenue = 839) or (cde_revenue = 902) or (cde_revenue = 946) or (cde_revenue = 947) or (cde_revenue = 961) or
         (cde_revenue = 962) or (cde_revenue = 963) or (cde_revenue = 973) or (cde_revenue = 974) or (cde_revenue = 975) or
         (cde_revenue = 981) or (cde_revenue = 982) or (cde_revenue = 983) or (cde_revenue = 988)))) or
         (claim_type in('D') and proc_code not in(' ','-','+','#')) or
         (claim_type in ('O','D') and cde_enc_proc_type ='7' and proc_code_enc not in(' ','-','+','#')))
         then 1 else 0 end as proc_code1b,
         /* PROC MODIFIER claim type M (DME) Janes mods */
         case when CDE_ENC_REC_IND <> '0' AND claim_type in('M') and (substr(proc_code,1,1) in('E','K')  or
         (cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('E','K'))) and
         (proc_modifier1 in('RR','NU','UE') or proc_modifier2 in('RR','NU','UE') or proc_modifier3 in('RR','NU','UE') or proc_modifier4 in('RR','NU','UE'))
         then 1 else 0 end as proc_mod_DME,
         /* PROC MODIFIER claim type M (lab/xray) all mods */
         case when CDE_ENC_REC_IND <> '0' AND claim_type in('M') and (substr(proc_code,1,1) in('7')  or
         (cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('7'))) and
         (proc_modifier1 not in('+',' ','-') or proc_modifier2 not in('+',' ','-') or proc_modifier3 not in('+',' ','-') or proc_modifier4 not in('+',' ','-'))
         then 1 else 0 end as proc_mod_LABXRAY,
         /* PROC MODIFIER claim type M (surgery) all mods */
         case when cde_enc_rec_ind <> '0' and claim_type in('M') and
         ((proc_code between '10021' and '69990' and substr(proc_code,5,1) in('0','1','2','3','4','5','6','7','8','9') and proc_code_desc not in ('Unknown','N/A')) or
         (cde_enc_proc_type ='7' and proc_code_enc between '10021' and '69990' and substr(proc_code_enc,5,1) in('0','1','2','3','4','5','6','7','8','9') and
         proc_code_enc_desc not in('Unknown','N/A'))) and
         (proc_modifier1 not in('+',' ','-') or proc_modifier2 not in('+',' ','-') or proc_modifier3 not in('+',' ','-') or proc_modifier4 not in('+',' ','-'))
         then 1 else 0 end as proc_mod_SURGERYM,
         /* QTY UNITS BILLED */
         case when CLAIM_TYPE <> 'P' and qty_units_billed is not null then 1 else 0 end as QTY_UNITS_BILLED1, /*updated 7.2.18*/
         /* BILLING PROVIDER NPI */
         /*added zero as fail 8.26.16 see email Fallon and NPIs generally*/
         case when CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE not in ('P','D') and MX.BILL_NPI NOT IN('MISSING','+','-',' ','0') then 1 else 0 end as BILL_PRV_NPI,
         /* SERVICING PROVIDER NPI */
         /*added zero as fail 8.26.16 see email Fallon and NPIs generally*/
         case when CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE not in ('P','D') and MX.SERV_NPI NOT IN('MISSING','+','-',' ','0') then 1 else 0 end as SERV_PRV_NPI,
         /* DATE SCRIPT WRITTEN - Field 82*/
         case when MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND MX.DATE_SCRIPT_WRITTEN IS NOT NULL
         then 1 else 0 end as scriptwrit1,
         /* REFILL INDICATOR - Field 40 */
         case when MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND MX.QTY_REFILL >=0 THEN 1 ELSE 0 END AS REFILL1,
         /* DISPENSE AS WRITTEN - FIELD 41 */
         CASE WHEN MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND
         SUBSTR(MX.DSC_ENC_DISP_AS_WRTN,1,1) IN('0','1','2','3','4','5','6','7','8','9')
         THEN 1 ELSE 0 END AS DISPENSE1,
         /* PRESCRIPTION NUMBER - #198 */
         CASE WHEN MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND MX.RX_NUMBER IS NOT NULL THEN 1 ELSE 0 END AS SCRIPT1,
         /* DISPENSING FEE - #67 */
         CASE WHEN MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND MX.AMT_NDC_PROFEE IS NOT NULL THEN 1 ELSE 0 END AS FEE1,
         /* NDC CODE - #37 */
         /* Only drugs not compounded 2=No, 1=Yes */
         CASE WHEN MX.claim_type='P' AND CDE_DRUG_CLASS='F' AND  MX.IND_ENC_COMPOUND='2' AND MX.CDE_NDC NOT IN (' ','-','+','#')
         THEN 1 ELSE 0 END AS NDC1,
         /* CLAIM CATEGORY - #2 */
         CASE WHEN SUBSTR(MX.DSC_ENC_CLAIM_CAT,1,1) IN ('1','2','3','4','5','6','7') THEN 1 ELSE 0 END AS CLAIMCAT1,
         /* SERVICE CATEGORY */
         CASE WHEN CDE_ENC_SVC_CAT not in(' ','-','+','#') then 1 else 0 end as SVCCAT1,
         /* RECORD INDICATOR - #4 */
         /* JPL 20230927, include 8 and 9)*/
         CASE WHEN SUBSTR(MX.DSC_ENC_REC_IND,1,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS RECIND1,
         /* AMOUNT BILLED - #60 */
         CASE WHEN MX.AMT_BILLED >=0 THEN 1 ELSE 0 END AS AMTBILL1,
         /* NET AMOUNT PAID - #68 */
         /* THERE ARE NEGATIVE VALUES HOW TO CAPTURE IS NULL; updated to say amt_paid>=0 b/c there were 9 with negative values*/
         CASE WHEN MX.AMT_PAID >=0 THEN 1 ELSE 0 END AS AMTPAY1,
         /* AMOUNT ALLOWED - #86 */
         /* THERE ARE NEGATIVE VALUES HOW TO CAPTURE IS NULL; updated to say amt_paid>=0 b/c there were 9 with negative values*/
         CASE WHEN MX.AMT_ALLOWED >=0 THEN 1 ELSE 0 END AS AMTALLOW1,
         /* ADMISSION DATE */
         case when MX.claim_type IN('I','L') and
         (admit_dt is not null and admit_dt != to_date('01JAN1900','DDMONYYYY')) and
         (admit_dt <= discharge_dt or discharge_dt is null)
         THEN 1 ELSE 0 END AS ADMITDT1,
         /* DISCHARGE DATE */
         /*NT edit 7.26.18*/
         case when (CLAIM_TYPE='I' AND substr(cde_type_of_bill_enc,1,2) <> '21' and SUBSTR(DSC_PATIENT_STATUS,1,2) NOT BETWEEN '30' AND '39')
         AND (MX.DISCHARGE_DT IS NOT NULL and discharge_dt >= admit_dt or admit_dt is null) THEN 1 else 0 end DISCHARGE_DT1,		 
         /*old*/
         /*case when (CLAIM_TYPE='I' AND cde_place_of_service <> '221' and SUBSTR(DSC_PATIENT_STATUS,1,2) NOT BETWEEN '30' AND '39')
         AND (MX.DISCHARGE_DT IS NOT NULL and discharge_dt >= admit_dt) THEN 1 else 0 end DISCHARGE_DT1,*/
         /* ADMITTING DIAGNOSIS */
         /*NT edit 7.26.18*/
         case when CLAIM_TYPE IN('I') AND substr(cde_type_of_bill_enc,1,2) not in('12','22','42','62','81','82') AND CDE_DIAG_ADMIT not IN ('+','-', ' ')
         THEN 1 else 0 END CDE_DIAG_ADMIT1,
         /*old*/
         /*case when CLAIM_TYPE IN('I') AND cde_place_of_service not in('212','222','242','262','281','282') AND CDE_DIAG_ADMIT not IN ('+','-', ' ')
         THEN 1 else 0 END CDE_DIAG_ADMIT1,*/
         /* PATIENT DISCHARGE STATUS */
         case when CLAIM_TYPE IN('I','O') AND cde_patient_status not in ('+', '-', ' ') then 1 else 0 end as CDE_PATIENT_STATUS1,
         /* TYPE OF ADMISSION */
         case when CLAIM_TYPE IN('I','L') AND cde_admit_type in ('1','2','3','4','5','6','7','8','9') then 1 else 0 end as cde_admit_type1,
         /* SOURCE OF ADMISSION */
         case when CLAIM_TYPE IN('I','L') AND cde_admit_source  in ('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F') then 1 else 0 end as cde_admit_source1,
         /* REVENUE CODE */
         case when CLAIM_TYPE IN('I','O','L') AND substr(dsc_revenue,1,1) in ('0','1','2','3','4','5','6','7','8','9') and cde_enc_rec_ind <> '0'
         then 1 else 0 end as rev_code1,
         /*updated 5.29.2018 b/c DW storing POS and TOB separately now*/
         /* PLACE OF SERVICE */
         /*case when CLAIM_TYPE NOT IN('P','D') AND SUBSTR(place_of_service,1,1) IN ('0','1','2','3','4','5','6','7','8','9') and
         SUBSTR(place_of_service,2,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 else 0 end as pos_code1,*/
         /* PLACE OF SERVICE (updated) */
         case when CLAIM_TYPE NOT IN('P','D') AND
         ( (substr(cde_place_of_service_enc,1,1) in('0','1','2','3','4','5','6','7','8','9') and
         substr(cde_place_of_service_enc,2,1) in('0','1','2','3','4','5','6','7','8','9'))
         or
         (substr(cde_type_of_bill_enc,1,1) in('0','1','2','3','4','5','6','7','8','9') and
         substr(cde_type_of_bill_enc,2,1) in('0','1','2','3','4','5','6','7','8','9'))) then 1 else 0 end as pos_code1,
         /*updated 5.29.2018 b/c DW storing POS and TOB separately now and POS type has been retired*/
         /* PLACE OF SERVICE TYPE */
         /*case when claim_type not in('P','D') and 											
         (											
         ((cde_enc_claim_cat ='1' and substr(cde_place_of_service,1,1)='2') or (cde_enc_claim_cat ='2' and substr(cde_place_of_service,1,1)='1'))											
         or (cde_enc_claim_cat in('3','4','5') and substr(cde_place_of_service,1,1)='1') 											
         or (cde_enc_claim_cat in('6') and substr(cde_place_of_service,1,1)='2')											
         )											
         and SUBSTR(cde_place_of_service,2,1) IN ('0','1','2','3','4','5','6','7','8','9') and 											
         SUBSTR(cde_place_of_service,3,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 else 0 end as pos_type1,*/
         /* PLACE OF SERVICE TYPE (updated) */
         case when CLAIM_TYPE NOT IN('P','D') AND
         ((cde_enc_claim_cat in('2','3','4','5') and
         substr(cde_place_of_service_enc,1,1) in('0','1','2','3','4','5','6','7','8','9') and
         substr(cde_place_of_service_enc,2,1) in('0','1','2','3','4','5','6','7','8','9'))
         or
         (cde_enc_claim_cat in('1','6') and
         substr(cde_type_of_bill_enc,1,1) in('0','1','2','3','4','5','6','7','8','9') and
         substr(cde_type_of_bill_enc,2,1) in('0','1','2','3','4','5','6','7','8','9'))) then 1 else 0 end as pos_type1,
         /*Paid Date -Field 45*/
         case when MX.PAID_DT IS NOT NULL THEN 1 else 0 end PAID_DT1,	
         /*Billing Provider ID address location code- field 223*/	
         case when bill_prov_id_loc_code not in(' ','+','#','-') then 1 else 0 end as bill_id_loc1,
         									
         /*Servicing Provider ID address location code- field 227*/	
         case when serv_prov_id_loc_code not in(' ','+','#','-') then 1 else 0 end as serv_id_loc1,
         		
         /*Prescribing Provider ID address location code- field 224*/	
         case when CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS = 'F' and prs_prov_id_loc_code not in(' ','+','#','-') then 1 else 0 end as prs_id_loc1,
         /*ENTITY PIDSLs are used to derive cde_enc_MCO and cde_enc_ACO names, and are available in ODS only: ACO*/
         case when cde_enc_aco not in(' ','+','#','-') then 1 else 0 end as aco1,
         /* TPL AMOUNT */
         case when amt_tpl >= 0 then 1 else 0 end as amttpl1,
         /* COPAY AMOUNT */
         case when amt_copay >= 0 then 1 else 0 end as amtcopay1,
         /* COINSURANCE AMOUNT */
         case when amt_coinsurance >=0 then 1 else 0 end as amtcoins1,
         /* RECORD TYPE */
         case when cde_clm_disposition in ('O','V','R','A') then 1 else 0 end as clmdisp1,
         /* CLAIM NUMBER */
         case when enc_claim_no is not null then 1 else 0 end as clmnum1,
         /* CLAIM SUFFIX */
         case when enc_claim_suffix is not null then 1 else 0 end as clmsuf1,
         /* MOTHER-CHILD CLAIM ID */
         case when num_logical_claim is not null then 1 else 0 end as numlogclm1
         											
         FROM MHTEAM.DWDQ.INF_B_SC_MCO_MBHP_DOS_~MON_output~   MX
         WHERE MX.RUN_DATE = TO_DATE('~ASOFDT_output~','YYYYMMDD')
         )  FIRSTX
         GROUP BY FIRSTX.CDE_ENC_MCO, firstx.DOS_YRMONTH, firstx.ACO;

CREATE TABLE MHTEAM.DWDQ.INF_B_SC_MCO_MBH_TPDOS_~MON_output~
AS
         SELECT 
         TO_DATE('~ASOFDT_output~','YYYYMMDD') AS RUN_DATE, 
         CDE_ENC_MCO,DOS_YRMONTH, ACO,
         SUM(INPATS) AS TOT_INPAT,
         SUM(OUTPATS) AS TOT_OUTPT,
         SUM(OUTPATSQ2) AS TOT_OUTPTQ2, /*ADJUST B/C Q2 REMOVED REC_IND=0 FROM DATA PULL*/
         SUM(MED) AS TOT_MED,
         SUM(MEDQ2) AS TOT_MEDQ2,  /*ADJUST B/C Q2 REMOVED REC_IND=0 FROM DATA PULL*/
         SUM(PHARMS) AS TOT_PHARM,
         SUM(DENT) AS TOT_DENT,
         SUM(DENTQ2) AS TOT_DENTQ2, /*ADJUST B/C Q2 REMOVED REC_IND=0 FROM DATA PULL*/
         SUM(LTCS) AS TOT_LTC,
         SUM(FACILTY) AS TOT_FACILTY,
         SUM(ADJUST) AS TOT_ADJST,
         SUM(MISS) AS TOT_MISSING,
         SUM(NOT_PRM_DNT) AS TOT_NON_PHRM_DENT, /* USED TO COMPUTE % ON NON PHARM AND DENTAL CLAIMS, WHICH DON'T HAVE DX */
         SUM(NOT_PRM_DNTQ2) AS TOT_NON_PHRM_DENTQ2, /*ADJUST B/C Q2 REMOVED REC_IND=0 FROM DATA PULL*/
         SUM(PHARM_SCRIPT) AS TOT_PHARM_SCRIPT, /* USED TO COMPUTE % ON PRESCRIBING ID/TYPE OTC ARE EXCLUDED PER SPECS*/
         SUM(NON_PHARM) AS TOT_NONPHARM, /*added 7.2.18*/
         SUM(NOTCOMPOUND) AS TOT_NOTCOMPOUND,
         SUM(PHARMSCRIPT_NOTCOMP) AS TOT_PHARMSCRIPT_NOTCOMP,
         (SUM(INPATS) + SUM(MED)) AS TOT_INP_MED,
         (SUM(INPATS) + SUM(LTCS)) AS TOT_INPT_LTC,
         	    (SUM(INPATS) + SUM(OUTPATS)) AS TOT_INPT_OUTPT,
         (SUM(INPATS) + SUM(OUTPATS) + SUM(LTCS)) AS TOT_INPT_OUTPT_LTC,
         SUM(INOUTLTC_NOART) AS TOT_INOUTLTC_NOART,
         SUM(INPAT_FILTER1) AS TOT_INPAT_FILTER1,
         SUM(INPAT_FILTER2) AS TOT_INPAT_FILTER2,
         SUM(INOPLTC_EXC) AS TOT_INP_OP_LTC_EXC,
         SUM(INOPLTCM_EXC) AS TOT_INP_OP_LTC_M_EXC,
         SUM(INOPLTCM_EXCQ2) AS TOT_INP_OP_LTC_M_EXCQ2, /*ADJUST B/C Q2 REMOVED REC_IND=0 FROM DATA PULL*/
         SUM(MOD_DME) AS TOT_MOD_DME,
         SUM(MOD_LABXRAY) AS TOT_MOD_LABXRAY,
         SUM(MOD_SURGERYM) AS TOT_MOD_SURGERYM,
         SUM(REX) AS TOT_REX
         FROM
         (SELECT
         CDE_ENC_MCO,
         TO_CHAR(DOS_FROM,'YYYY-MM') AS DOS_YRMONTH,
         ACO,
         CASE WHEN CLAIM_TYPE = 'I' THEN 1 ELSE 0 END INPATS,
         CASE WHEN CLAIM_TYPE = 'P' THEN 1 ELSE 0 END PHARMS,
         CASE WHEN CLAIM_TYPE = 'O' THEN 1 ELSE 0 END OUTPATS,
         CASE WHEN CLAIM_TYPE = 'O' AND CDE_ENC_REC_IND <> '0' THEN 1 ELSE 0 END OUTPATSQ2,
         CASE WHEN CLAIM_TYPE = 'L' THEN 1 ELSE 0 END LTCS,
         CASE WHEN CLAIM_TYPE IN ('M') THEN 1 ELSE 0 END MED,
         CASE WHEN CLAIM_TYPE IN ('M') AND CDE_ENC_REC_IND <> '0' THEN 1 ELSE 0 END MEDQ2,
         CASE WHEN CLAIM_TYPE IN ('D') THEN 1 ELSE 0 END DENT,
         CASE WHEN CLAIM_TYPE IN ('D') AND CDE_ENC_REC_IND <> '0' THEN 1 ELSE 0 END DENTQ2,
         CASE WHEN CLAIM_TYPE NOT IN ('P','D') THEN 1 ELSE 0 END NOT_PRM_DNT,
         CASE WHEN CLAIM_TYPE NOT IN ('P','D') AND CDE_ENC_REC_IND <> '0' THEN 1 ELSE 0 END NOT_PRM_DNTQ2,
         CASE WHEN CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS = 'F' THEN 1 ELSE 0 END PHARM_SCRIPT,
         CASE WHEN CLAIM_TYPE <> 'P' THEN 1 ELSE 0 END AS NON_PHARM, /*added 7.2.18 for update to quantity logic*/
         CASE WHEN IND_ENC_COMPOUND='2' THEN 1 ELSE 0 END AS NOTCOMPOUND,
         CASE WHEN CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS = 'F' AND IND_ENC_COMPOUND='2'
         THEN 1 ELSE 0 END PHARMSCRIPT_NOTCOMP,
         CASE WHEN SUBSTR(CDE_ENC_CLAIM_CAT,1,1) = '1' THEN 1 ELSE 0 END FACILTY,
         CASE WHEN cde_clm_disposition <> 'O' THEN 1 ELSE 0 END ADJUST,
         CASE WHEN CLAIM_TYPE IN (' ','-','+') THEN 1 ELSE 0 END MISS,
         CASE WHEN CLAIM_TYPE='I' AND substr(cde_type_of_bill_enc,1,2) <> '21' and SUBSTR(DSC_PATIENT_STATUS,1,2) NOT BETWEEN '30' AND '39' THEN 1 ELSE 0 END INPAT_FILTER1,
         CASE WHEN CLAIM_TYPE IN('I') AND substr(cde_type_of_bill_enc,1,2) not in('12','22','42','62','81','82') THEN 1 ELSE 0 END AS INPAT_FILTER2,
         CASE WHEN CLAIM_TYPE IN('I','O','L') and cde_enc_rec_ind <> '0' THEN 1 ELSE 0 END AS INOUTLTC_NOART,
         CASE WHEN ((CLAIM_TYPE='I' AND CDE_PATIENT_STATUS NOT BETWEEN '30' AND '39') OR CLAIM_TYPE IN('O','L')) THEN 1 ELSE 0 END INOPLTC_EXC,
         CASE WHEN CLAIM_TYPE IN('I','M','O','L') AND (ENCSRGGRP_SEQ>0 or diagrp_seq>0) THEN 1 ELSE 0 END INOPLTCM_EXC,
         CASE WHEN CLAIM_TYPE IN('I','M','O','L') AND (ENCSRGGRP_SEQ>0 or diagrp_seq>0) AND CDE_ENC_REC_IND <> '0' THEN 1 ELSE 0 END INOPLTCM_EXCQ2,
         CASE WHEN CLAIM_TYPE IN ('M') AND CDE_ENC_REC_IND <> '0' AND (substr(proc_code,1,1) in('E','K')  or
         (cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('E','K'))) THEN 1 ELSE 0 END AS MOD_DME,
         CASE WHEN CLAIM_TYPE IN ('M') AND CDE_ENC_REC_IND <> '0' AND (substr(proc_code,1,1) in('7')  or
         (cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('7'))) THEN 1 ELSE 0 END AS MOD_LABXRAY,
         case when cde_enc_rec_ind <> '0' and claim_type in('M') and
         ((proc_code between '10021' and '69990' and substr(proc_code,5,1) in('0','1','2','3','4','5','6','7','8','9') and proc_code_desc not in ('Unknown','N/A')) or
         (cde_enc_proc_type ='7' and proc_code_enc between '10021' and '69990' and substr(proc_code_enc,5,1) in('0','1','2','3','4','5','6','7','8','9') and
         proc_code_enc_desc not in('Unknown','N/A'))) THEN 1 ELSE 0 END AS MOD_SURGERYM,
         1 AS REX
         FROM MHTEAM.DWDQ.INF_B_SC_MCO_MBHP_DOS_~MON_output~ MX
         WHERE MX.RUN_DATE = TO_DATE('~ASOFDT_output~','YYYYMMDD')
         )
         GROUP BY CDE_ENC_MCO ,DOS_YRMONTH, ACO
         ORDER BY CDE_ENC_MCO ,DOS_YRMONTH, ACO;

CREATE TABLE MHTEAM.DWDQ.INF_B_SC_MCO_MBH_PTPDOS_~MON_output~
AS
SELECT
         TO_DATE('~ASOFDT_output~','YYYYMMDD') AS RUN_DATE, 
         I.CDE_ENC_MCO,
         I.DOS_YRMONTH,
         I.ACO,
         S.TOT_INPAT,
         S.TOT_PHARM,
         S.TOT_OUTPT,
         S.TOT_OUTPTQ2,
         S.TOT_DENT,
         S.TOT_DENTQ2,
         S.TOT_MED,
         S.TOT_MEDQ2,
         S.TOT_NON_PHRM_DENTQ2,
         S.TOT_PHARM_SCRIPT,
         S.TOT_PHARMSCRIPT_NOTCOMP,
         S.TOT_NONPHARM,
         S.TOT_INPT_LTC,
         S.TOT_INPT_OUTPT_LTC,
         S.TOT_INP_OP_LTC_M_EXCQ2,
         S.TOT_NON_PHRM_DENT,
         S.TOT_INPAT_FILTER1,
         S.TOT_INPAT_FILTER2,
         S.TOT_MOD_DME,
         S.TOT_MOD_LABXRAY,
         S.TOT_MOD_SURGERYM,
         S.TOT_INOUTLTC_NOART,
         S.TOT_INPT_OUTPT,
         S.TOT_REX AS TOT_RECORDS,
         /* MEMBER ID - Field 76*/
         case when  I.ID_MEDICAID2 = 0 then  0
         ELSE (trunc((I.ID_MEDICAID2 / S.TOT_REX),4))
         end as PCT_ID_MEDICAID,
         /* FROM DOS - Field 17 */
         case when  DOS_FROM2 = 0 then  0
         else  trunc((DOS_FROM2 / S.TOT_REX),4)
         end as PCT_DOS_FROM,
         /* THRU DOS - Field 18 */
         case when  DOS_THRU2 = 0 then  0
         else  trunc((DOS_THRU2 / S.TOT_REX),4)
         end as PCT_DOS_THRU,
         /*  SERVICING PROVIDER ID - Field 50*/
         case when  SERV_PROV_ID2 = 0 then  0
         else  trunc((SERV_PROV_ID2 / S.TOT_REX),4)
         end as PCT_SERV_PROV_ID,
         /* SERVICING PROVIDER ID TYPE - Field 51 */
         CASE WHEN SERV_PROV_ID_TYP2 = 0 THEN 0
         ELSE trunc((SERV_PROV_ID_TYP2/S.TOT_REX),4)
         END AS PCT_SERV_PROV_ID_TYP,
         CASE WHEN SERV_PROV_TYP2 = 0 THEN 0
         ELSE trunc((SERV_PROV_TYP2/S.TOT_REX),4)
         END AS PCT_SERV_PROV_TYP,
         CASE WHEN SERV_PROV_spec2 = 0 THEN 0
         ELSE trunc((SERV_PROV_spec2/S.TOT_REX),4)
         END AS PCT_SERV_PROV_spec,
         /* BILLING PROVIDER ID - Field 58*/
         case when  BILL_PROV_ID2 = 0 then  0
         else  trunc((BILL_PROV_ID2 / S.TOT_REX),4)
         end as PCT_BILL_PROV_ID,
         /* BILLING PROVIDER ID TYPE - Field 93 */
         CASE WHEN BILL_PROV_ID_TYP2 = 0 THEN 0
         ELSE trunc((BILL_PROV_ID_TYP2/S.TOT_REX),4)
         END AS PCT_BILL_PROV_ID_TYP,
         /* PRESCRIBING PROVIDER ID - ON PHARM CLAIMS ONLY EXCLUDE OTC- Field 81 */
         case when  PRESCRIBE_PROV2 = 0 then  0
         else  trunc((PRESCRIBE_PROV2 / S.TOT_PHARM_SCRIPT),4)
         end as PCT_PRESCRIBE_PROV_ID,
         /* PRESCRIBING PROVIDER ID TYPE - ON PHARM CLAIMS ONLY EXCLUDE OTC- Field 95 */
         CASE WHEN PRES_PROV_ID_TYP2 = 0 THEN 0
         ELSE trunc((PRES_PROV_ID_TYP2/S.TOT_PHARM_SCRIPT),4)
         END AS PCT_PRES_PROV_ID_TYP,
         /* PRIMARY DIAGNOSIS */
         case when primary_diag2 = 0 then 0
         else trunc((primary_diag2 / S.TOT_NON_PHRM_DENTQ2),4)
         END AS PCT_PRIMARY_DIAG,
         /* ICD VERSION */
         case when cde_icd_version2 = 0 then 0
         else trunc((cde_icd_version2 / S.TOT_INP_OP_LTC_M_EXCQ2),4)
         END AS PCT_ICD_VERSION,
         /* PROCEDURE CODE */
         case when proc_code2 = 0 then 0
         else trunc((proc_code2 / (S.TOT_OUTPTQ2+S.TOT_DENTQ2+S.TOT_MEDQ2)),4)
         END AS PCT_PROC_CODE,
         case when proc_code2_o_d = 0 or (s.tot_outptQ2=0 and s.tot_dentQ2=0) then 0
         else trunc((proc_code2_o_d / (S.TOT_OUTPTQ2+S.TOT_DENTQ2)),4)
         END AS PCT_PROC_CODE_O_D,
         case when proc_code2_m = 0 or (s.tot_medQ2=0) then 0
         else trunc((proc_code2_m / (S.TOT_MEDQ2)),4)
         END AS PCT_PROC_CODE_M,
         /* PROC MODIFIER */
         case when proc_mod_dme2 = 0 then 0
         else trunc((proc_mod_dme2 / (S.TOT_MOD_DME)),4)
         END AS PCT_PROC_mod_DME,
         case when proc_mod_labxray2 = 0 then 0
         else trunc((proc_mod_labxray2 / (S.TOT_MOD_LABXRAY)),4)
         END AS PCT_PROC_mod_LABXRAY,
         case when proc_mod_surgerym2 = 0 then 0
         else trunc((proc_mod_surgerym2 / (S.TOT_MOD_SURGERYM)),4)
         END AS PCT_PROC_mod_SURGERYM,
         case when qty_unit_bill2 =0 then 0
         else trunc ((qty_unit_bill2 / (S.TOT_NONPHARM)),4)
         END AS PCT_qty_unit_bill,
         /* BILLING PROVIDER NPI */
         case when bill_npi2 = 0 then 0
         else trunc((bill_npi2 / S.TOT_NON_PHRM_DENTQ2),4)
         END AS PCT_BILL_NPI,
         /* SERVICING PROVIDER NPI */
         case when serv_npi2 = 0 then 0
         else trunc((serv_npi2 / S.TOT_NON_PHRM_DENTQ2),4)
         END AS PCT_SERV_NPI,
         /* DATE SCRIPT WRITTEN */
         case when  SCRIPTWRIT2 = 0 then  0
         ELSE (trunc((SCRIPTWRIT2 / S.TOT_PHARM_SCRIPT),4))
         end as PCT_SCRIPT_WRITTEN,
         case when REFILL2 = 0 THEN 0
         ELSE (trunc((REFILL2 / S.TOT_PHARM_SCRIPT),4))
         end as PCT_REFILL,
         case when DISPENSE2 = 0 THEN 0
         ELSE (trunc((DISPENSE2 / S.TOT_PHARM_SCRIPT),4))
         end as PCT_DISPENSE,
         case when SCRIPT2 = 0 THEN 0
         ELSE (trunc((SCRIPT2 / S.TOT_PHARM_SCRIPT),4))
         end as PCT_SCRIPT,
         case when FEE2 = 0 THEN 0
         ELSE (trunc((FEE2 / S.TOT_PHARM_SCRIPT),4))
         end as PCT_FEE,
         case when NDC2 = 0 THEN 0
         ELSE (trunc((NDC2 / S.TOT_PHARMSCRIPT_NOTCOMP),4))
         end as PCT_NDC,
         case when CLAIMCAT2 = 0 THEN 0
         ELSE (trunc((CLAIMCAT2 / S.TOT_REX),4))
         end as PCT_CLAIMCAT,
         case when svccat2 =0 then 0
         else trunc ((svccat2 / (S.TOT_rex)),4)
         END AS PCT_svc_cat,
         case when RECIND2 = 0 THEN 0
         ELSE (trunc((RECIND2 / S.TOT_REX),4))
         end as PCT_RECIND,
         case when AMTBILL2 = 0 THEN 0
         ELSE (trunc((AMTBILL2 / S.TOT_REX),4))
         end as PCT_AMTBILL,
         case when AMTPAY2 = 0 THEN 0
         ELSE (trunc((AMTPAY2 / S.TOT_REX),4))
         end as PCT_AMTPAY,
         case when AMTALLOW2 = 0 THEN 0
         ELSE (trunc((AMTALLOW2 / S.TOT_REX),4))
         end as PCT_AMTALLOW,
         case when  ADMITDT2 = 0 then  0
         ELSE (trunc((ADMITDT2 / (S.TOT_INPT_LTC)),4))
         end as PCT_ADMITDT,
         case when DISCHARGEDT2 = 0 THEN 0
         ELSE (trunc((DISCHARGEDT2 / S.TOT_INPAT_FILTER1),4))
         end as PCT_DISCHARGEDT,
         case when CDE_DIAG_ADMIT2 = 0 THEN 0
         ELSE (trunc((CDE_DIAG_ADMIT2 / S.TOT_INPAT_FILTER2),4))
         end as PCT_DIAG_ADMIT,
         case when CDE_PATIENT_STATUS2 = 0 THEN 0
         ELSE (trunc((CDE_PATIENT_STATUS2 / S.TOT_INPT_OUTPT),4))
         end as PCT_PATIENT_STATUS,
         case when CDE_ADMIT_TYPE2 = 0 THEN 0
         ELSE (trunc((CDE_ADMIT_TYPE2 / S.TOT_INPT_LTC),4))
         end as PCT_ADMIT_TYPE,
         case when CDE_ADMIT_SOURCE2 = 0 THEN 0
         ELSE (trunc((CDE_ADMIT_SOURCE2 / S.TOT_INPT_LTC),4))
         end as PCT_ADMIT_SOURCE,
         case when REV_CODE2 = 0 THEN 0
         ELSE (trunc((REV_CODE2 / S.TOT_INOUTLTC_NOART),4))
         end as PCT_REV_CODE,
         case when POS_CODE2 = 0 THEN 0
         ELSE (trunc((POS_CODE2 / S.TOT_NON_PHRM_DENT),4))
         end as PCT_POS_CODE,
         case when POS_TYPE2 = 0 THEN 0
         ELSE (trunc((POS_TYPE2 / S.TOT_NON_PHRM_DENT),4))
         end as PCT_POS_TYPE,
         case when  PAID_DT2 = 0 then  0
         else  trunc((PAID_DT2 / S.TOT_REX),4)
         end as PCT_PAID_DT,
         CASE WHEN SERV_ID_LOC2 = 0 THEN 0
         ELSE trunc((SERV_ID_LOC2/S.TOT_REX),4)
         END AS PCT_SERV_ID_LOC,
         CASE WHEN BILL_ID_LOC2 = 0 THEN 0
         ELSE trunc((BILL_ID_LOC2/S.TOT_REX),4)
         END AS PCT_BILL_ID_LOC,
         CASE WHEN PRS_ID_LOC2 = 0 THEN 0
         ELSE trunc((PRS_ID_LOC2/S.TOT_PHARM_SCRIPT),4)
         END AS PCT_PRS_ID_LOC,
         CASE WHEN ACO2 = 0 THEN 0
         ELSE trunc((ACO2/S.TOT_REX),4)
         END AS PCT_ACO,
         /* TPL AMOUNT */
         CASE WHEN AMTTPL2 = 0 THEN 0
         ELSE TRUNC((AMTTPL2/S.TOT_REX),4)
         END AS PCT_TPL,
         /* AMT COPAY */
         CASE WHEN AMTCOPAY2 = 0 THEN 0
         ELSE TRUNC((AMTCOPAY2/S.TOT_REX),4)
         END AS PCT_COPAY,
         /* AMT COINSURANCE */
         CASE WHEN AMTCOINS2 = 0 THEN 0
         ELSE TRUNC((AMTCOINS2/S.TOT_REX),4)
         END AS PCT_COINS,
         /* RECORD TYPE */
         CASE WHEN CLMDISP2 = 0 THEN 0
         ELSE TRUNC((CLMDISP2/S.TOT_REX),4)
         END AS PCT_CLMDISP,
         /* CLAIM NUMBER */
         CASE WHEN CLMNUM2 = 0 THEN 0
         ELSE TRUNC((CLMNUM2/S.TOT_REX),4)
         END AS PCT_CLMNUM,
         /* CLAIM SUFFIX */
         CASE WHEN CLMSUF2 = 0 THEN 0
         ELSE TRUNC((CLMSUF2/S.TOT_REX),4)
         END AS PCT_CLMSUF,
         /* MOTHER-CHILD CLAIM ID */
         CASE WHEN NUMLOGCLM2 = 0 THEN 0
         ELSE TRUNC((NUMLOGCLM2/S.TOT_REX),4)
         END AS PCT_NUMLOGCLM
         FROM MHTEAM.DWDQ.INF_B_SC_MCO_MBH_FRPDOS_~MON_output~ I
         INNER JOIN MHTEAM.DWDQ.INF_B_SC_MCO_MBH_TPDOS_~MON_output~ S ON I.CDE_ENC_MCO = S.CDE_ENC_MCO AND I.DOS_YRMONTH=S.DOS_YRMONTH AND I.ACO = S.ACO AND I.RUN_DATE = S.RUN_DATE
         WHERE I.RUN_DATE = TO_DATE('~ASOFDT_output~','YYYYMMDD')
         ORDER BY cde_enc_mco,dos_yrmonth,aco;
create table MHTEAM.DWDQ.INF_B_SC_MCO_MBH_REP_TRANSPOSE_~MON~
AS
select * from (
select
  CDE_ENC_MCO,
  DOS_YRMONTH,
  ACO,
  PCT_ID_MEDICAID,
  PCT_DOS_FROM   ,
  PCT_DOS_THRU   ,
  PCT_SERV_PROV_ID,
  PCT_SERV_PROV_ID_TYP,
  PCT_SERV_PROV_TYP,
  PCT_SERV_PROV_SPEC,
  PCT_BILL_PROV_ID,
  PCT_BILL_PROV_ID_TYP,
  PCT_PRESCRIBE_PROV_ID,
  PCT_PRES_PROV_ID_TYP,
  PCT_PRIMARY_DIAG,
  PCT_ICD_VERSION,
  PCT_PROC_CODE  ,
  PCT_PROC_CODE_O_D,
  PCT_PROC_CODE_M,
  PCT_PROC_MOD_DME,
  PCT_PROC_MOD_LABXRAY,
  PCT_PROC_MOD_SURGERYM,
  PCT_QTY_UNIT_BILL,
  PCT_BILL_NPI   ,
  PCT_SERV_NPI   ,
  PCT_SCRIPT_WRITTEN,
  PCT_REFILL     ,
  PCT_DISPENSE   ,
  PCT_SCRIPT     ,
  PCT_FEE        ,
  PCT_NDC        ,
  PCT_CLAIMCAT   ,
  PCT_SVC_CAT    ,
  PCT_RECIND     ,
  PCT_AMTBILL    ,
  PCT_AMTPAY     ,
  PCT_AMTALLOW   ,
  PCT_ADMITDT    ,
  PCT_DISCHARGEDT,
  PCT_DIAG_ADMIT ,
  PCT_PATIENT_STATUS,
  PCT_ADMIT_TYPE ,
  PCT_ADMIT_SOURCE,
  PCT_REV_CODE   ,
  PCT_POS_CODE   ,
  PCT_POS_TYPE   ,
  PCT_PAID_DT    ,
  PCT_SERV_ID_LOC,
  PCT_BILL_ID_LOC,
  PCT_PRS_ID_LOC ,
  PCT_ACO        ,
  PCT_TPL        ,
  PCT_COPAY      ,
  PCT_COINS      ,
  PCT_CLMDISP    ,
  PCT_CLMNUM     ,
  PCT_CLMSUF     ,
  PCT_NUMLOGCLM  
from MHTEAM.DWDQ.INF_B_SC_MCO_MBH_PTPDOS_~MON~
) s
unpivot (
 actuals for meas in (
   PCT_ID_MEDICAID,
  PCT_DOS_FROM   ,
  PCT_DOS_THRU   ,
  PCT_SERV_PROV_ID,
  PCT_SERV_PROV_ID_TYP,
  PCT_SERV_PROV_TYP,
  PCT_SERV_PROV_SPEC,
  PCT_BILL_PROV_ID,
  PCT_BILL_PROV_ID_TYP,
  PCT_PRESCRIBE_PROV_ID,
  PCT_PRES_PROV_ID_TYP,
  PCT_PRIMARY_DIAG,
  PCT_ICD_VERSION,
  PCT_PROC_CODE  ,
  PCT_PROC_CODE_O_D,
  PCT_PROC_CODE_M,
  PCT_PROC_MOD_DME,
  PCT_PROC_MOD_LABXRAY,
  PCT_PROC_MOD_SURGERYM,
  PCT_QTY_UNIT_BILL,
  PCT_BILL_NPI   ,
  PCT_SERV_NPI   ,
  PCT_SCRIPT_WRITTEN,
  PCT_REFILL     ,
  PCT_DISPENSE   ,
  PCT_SCRIPT     ,
  PCT_FEE        ,
  PCT_NDC        ,
  PCT_CLAIMCAT   ,
  PCT_SVC_CAT    ,
  PCT_RECIND     ,
  PCT_AMTBILL    ,
  PCT_AMTPAY     ,
  PCT_AMTALLOW   ,
  PCT_ADMITDT    ,
  PCT_DISCHARGEDT,
  PCT_DIAG_ADMIT ,
  PCT_PATIENT_STATUS,
  PCT_ADMIT_TYPE ,
  PCT_ADMIT_SOURCE,
  PCT_REV_CODE   ,
  PCT_POS_CODE   ,
  PCT_POS_TYPE   ,
  PCT_PAID_DT    ,
  PCT_SERV_ID_LOC,
  PCT_BILL_ID_LOC,
  PCT_PRS_ID_LOC ,
  PCT_ACO        ,
  PCT_TPL        ,
  PCT_COPAY      ,
  PCT_COINS      ,
  PCT_CLMDISP    ,
  PCT_CLMNUM     ,
  PCT_CLMSUF     ,
  PCT_NUMLOGCLM   
 ))
order by
CDE_ENC_MCO,
DOS_YRMONTH,
ACO;

create table MHTEAM.DWDQ.INF_B_SC_MCO_MBH_REP_STEP1_~MON~
AS
select
'~ASOFDT~' as query_month, /*UPDATE*/
dos_yrmonth as month_service,
meas,
case when meas ='PCT_ID_MEDICAID' or meas ='PCT_DOS_FROM' or meas ='PCT_DOS_THRU' or 
          meas ='PCT_SERV_PROV_ID' or meas ='PCT_SERV_PROV_ID_TYP' or meas ='PCT_SERV_PROV_TYP' or
          meas ='PCT_SERV_PROV_SPEC' or meas ='PCT_BILL_PROV_ID' or meas ='PCT_BILL_PROV_ID_TYP' or  
          meas='PCT_SVC_CAT' or meas='PCT_CLAIMCAT' or 
          meas='PCT_RECIND' or meas='PCT_AMTBILL' or meas='PCT_AMTALLOW' or meas='PCT_AMTPAY' or
          meas='PCT_PAID_DT' or meas='PCT_SERV_ID_LOC' or meas='PCT_BILL_ID_LOC' or meas='PCT_TPL' or
          meas='PCT_COPAY' or meas='PCT_COINS' or meas='PCT_CLMDISP' or meas='PCT_CLMNUM' or
          meas='PCT_CLMSUF' or meas='PCT_NUMLOGCLM' or meas='PCT_ACO'
     then 'All Claim Types' 

     when meas='PCT_QTY_UNIT_BILL' then 'Non Pharmacy'

     when meas='PCT_PRESCRIBE_PROV_ID' or meas='PCT_PRES_PROV_ID_TYP' or meas='PCT_SCRIPT_WRITTEN' or
          meas='PCT_REFILL' or meas='PCT_DISPENSE' or meas='PCT_SCRIPT' or meas='PCT_FEE' or 
          meas='PCT_PRS_ID_LOC'
     then 'Pharmacy (prescriptions only, not OTC)'

     when meas='PCT_NDC' then 'Pharmacy (prescriptions only, not OTC and not compounded)'

     when meas='PCT_PRIMARY_DIAG' or meas='PCT_ICD_VERSION' or meas='PCT_POS_CODE' or 
          meas='PCT_POS_TYPE' or meas='PCT_SERV_NPI' or meas='PCT_BILL_NPI' 
     then 'Inpatient, Outpatient, Professional, and LTC'

     when meas='PCT_PROC_CODE_O_D' then 'Outpatient' 

     when meas='PCT_PROC_CODE_M' or meas='PCT_PROC_MOD_LABXRAY' or meas='PCT_PROC_MOD_SURGERYM' 
     then 'Professional'

     when meas='PCT_PROC_MOD_DME' then 'Professional (modifier=RR,NU,UE)'

     when meas='PCT_ADMITDT' or meas='PCT_ADMIT_TYPE' or meas='PCT_ADMIT_SOURCE' then 'Inpatient and LTC'

     when meas='PCT_DISCHARGEDT' or meas='PCT_DIAG_ADMIT' then 'Inpatient'

     when meas='PCT_PATIENT_STATUS' then 'Inpatient and Outpatient'

     when meas='PCT_REV_CODE' then 'Inpatient, Outpatient, and LTC'
end as claimtype,
cde_enc_mco as plan,
aco,
ROUND((actuals)*100,2) as actuals /*converting rate to a percent and rounding 2 decimal places*/
from MHTEAM.DWDQ.INF_B_SC_MCO_MBH_REP_TRANSPOSE_~MON~;

create table MHTEAM.DWDQ.INF_B_SC_MCO_MBH_REP_STEP2_~MON~ 
as
select query_month, month_service, meas, claimtype, plan, aco, claim_count, actuals
from
(
select rpt1.*,
case when meas ='PCT_ID_MEDICAID' or meas ='PCT_DOS_FROM' or meas ='PCT_DOS_THRU' or 
          meas ='PCT_SERV_PROV_ID' or meas ='PCT_SERV_PROV_ID_TYP' or meas ='PCT_SERV_PROV_TYP' or
          meas ='PCT_SERV_PROV_SPEC' or meas ='PCT_BILL_PROV_ID' or meas ='PCT_BILL_PROV_ID_TYP' or  
          meas='PCT_SVC_CAT' or meas='PCT_CLAIMCAT' or 
          meas='PCT_RECIND' or meas='PCT_AMTBILL' or meas='PCT_AMTALLOW' or meas='PCT_AMTPAY' or
          meas='PCT_PAID_DT' or meas='PCT_SERV_ID_LOC' or meas='PCT_BILL_ID_LOC' or meas='PCT_TPL' or
          meas='PCT_COPAY' or meas='PCT_COINS' or meas='PCT_CLMDISP' or meas='PCT_CLMNUM' or
          meas='PCT_CLMSUF' or meas='PCT_NUMLOGCLM' or meas='PCT_ACO'
          then TOT_RECORDS
when meas='PCT_PRESCRIBE_PROV_ID' or meas='PCT_PRES_PROV_ID_TYP' or meas='PCT_SCRIPT_WRITTEN' or
     meas='PCT_REFILL' or meas='PCT_DISPENSE' or meas='PCT_SCRIPT' or meas='PCT_FEE' or
     meas='PCT_PRS_ID_LOC' then TOT_PHARM_SCRIPT
when meas='PCT_NDC' then TOT_PHARMSCRIPT_NOTCOMP
when meas='PCT_QTY_UNIT_BILL' then TOT_NONPHARM 
when meas='PCT_PRIMARY_DIAG' or meas='PCT_SERV_NPI' or meas='PCT_BILL_NPI' then TOT_NON_PHRM_DENTQ2 
when meas='PCT_ADMITDT' or meas='PCT_ADMIT_TYPE' or meas='PCT_ADMIT_SOURCE' then TOT_INPT_LTC
when meas='PCT_PRIMARY_DIAG' then TOT_NON_PHRM_DENTQ2
when meas='PCT_ICD_VERSION' then TOT_INP_OP_LTC_M_EXCQ2
when meas='PCT_PROC_CODE_M' then TOT_MEDQ2
when meas='PCT_PROC_CODE_O_D' then TOT_OUTPTQ2
when meas='PCT_PROC_MOD_DME' then TOT_MOD_DME
when meas='PCT_PROC_MOD_LABXRAY' then TOT_MOD_LABXRAY
when meas='PCT_PROC_MOD_SURGERYM' then TOT_MOD_SURGERYM
when meas='PCT_POS_CODE' or meas='PCT_POS_TYPE' then TOT_NON_PHRM_DENT
when meas='PCT_REV_CODE' then TOT_INOUTLTC_NOART
when meas='PCT_PATIENT_STATUS' then TOT_INPT_OUTPT
when meas='PCT_DIAG_ADMIT' then TOT_INPAT_FILTER2
when meas='PCT_DISCHARGEDT' then TOT_INPAT_FILTER1
end as claim_count
from MHTEAM.DWDQ.INF_B_SC_MCO_MBH_REP_STEP1_~MON~ rpt1
inner join (select cde_enc_mco, dos_yrmonth, aco, TOT_INPAT, TOT_PHARM, TOT_OUTPT, TOT_OUTPTQ2, TOT_DENT, TOT_DENTQ2, 
                   TOT_MED, TOT_MEDQ2, TOT_NON_PHRM_DENTQ2, TOT_PHARM_SCRIPT, TOT_INPT_LTC, 
                   TOT_INPT_OUTPT_LTC, TOT_INP_OP_LTC_M_EXCQ2, TOT_NON_PHRM_DENT, 
                   TOT_INPAT_FILTER1, TOT_INPAT_FILTER2, TOT_MOD_DME, TOT_MOD_LABXRAY, 
                   TOT_MOD_SURGERYM, TOT_INOUTLTC_NOART, TOT_INPT_OUTPT, TOT_PHARMSCRIPT_NOTCOMP,TOT_NONPHARM,
                   TOT_RECORDS
            from MHTEAM.DWDQ.INF_B_SC_MCO_MBH_PTPDOS_~MON~
            )rpt2
on rpt1.plan=rpt2.cde_enc_mco and rpt1.month_service=rpt2.dos_yrmonth and rpt1.aco=rpt2.aco);

INSERT INTO MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_TIMELINESS
select 
       TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
       TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
       cde_enc_mco AS MCO,
       RANK() OVER (PARTITION BY cde_enc_mco ORDER BY metadata_date_created,zip_file_name,date_file_processed) ID,
       zip_file_name as FILE_NAME,
       zip_file_created,
       metadata_date_created,
       date_file_processed,
       ind_manual_override AS manual_override,
       ind_amendment AS Amendment
from (
select distinct
       CASE
         WHEN stat.cde_enc_mco = 'TFT' THEN 'CHA'  
         ELSE stat.cde_enc_mco
       END AS cde_enc_mco,
       --stat.cde_enc_mco,
       zip_file_name,
       metadata_date_created,
       metadata_date_created as zip_file_created, 
       to_date(max(to_char(process_end_tm,'mm/dd/yyyy')) over (partition by zip_file_name), 'MM/DD/YYYY') as DATE_FILE_PROCESSED, -- as processdt2,
       ind_manual_override,
       ind_amendment,
 CASE
         WHEN md_batch_seq_scrub IS NULL THEN 'File Failed'  
            WHEN md_batch_seq_nw  IS NULL THEN 'File processed but not loaded'        
          ELSE 'Successfully Loaded'
       END
       load_status,
       cde_load_status
from MHDWPROD.NW.nw_enc_statistics stat
inner join MHDWPROD.NW.ods_encounter enc
on enc.md_batch_seq=stat.md_batch_seq_ods and stat.cde_enc_mco=enc.cde_enc_mco
where 1=1 
and metadata_date_created between 
TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE('~RUN_DATE~','YYYYMMDD'),'MONTH'), -5)) AND
TO_CHAR(LAST_DAY(TRUNC(TO_DATE('~RUN_DATE~','YYYYMMDD'),'MONTH'))) --rolling history of 6months
order by cde_enc_mco, metadata_date_created
) t;


-- FAILS PART 1 & 2

-- PART 1

INSERT INTO MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_FAILS
-- MCO_FAIL1
SELECT * FROM (
WITH MCO_FAIL1 AS (
SELECT DISTINCT
1 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'ADMIT_DT' AS DESC2, TO_CHAR(ADMIT_DT,'YYYYMMDD') AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE IN('I','L') and ( (ADMIT_DT IS NULL) 
  OR ( ADMIT_DT IS NOT NULL AND DISCHARGE_DT IS NOT NULL AND ADMIT_DT > DISCHARGE_DT) )
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL1 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL2
SELECT * FROM (
WITH MCO_FAIL2 AS (
SELECT DISTINCT
2 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_TYPE_OF_BILL_ENC' AS DESC2, CDE_TYPE_OF_BILL_ENC AS VALUE2, 'CDE_DIAG_ADMIT' AS DESC3, CDE_DIAG_ADMIT AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='I' AND SUBSTR(CDE_TYPE_OF_BILL_ENC,1,2) NOT IN('12','22','42','62','81','82')  
AND CDE_DIAG_ADMIT  IN ('+','-', ' ')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL2 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL3
SELECT * FROM (
WITH MCO_FAIL3 AS (
SELECT DISTINCT
3 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'AMT_ALLOWED' AS DESC1, TO_CHAR(AMT_ALLOWED,'999,999,999.99') AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND (AMT_ALLOWED  < 0 or AMT_ALLOWED IS NULL)
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX

)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL3 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL4
SELECT * FROM (
WITH MCO_FAIL4 AS (
SELECT DISTINCT
4 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'AMT_BILLED' AS DESC1, TO_CHAR(AMT_BILLED,'999,999,999.99') AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND (AMT_BILLED  < 0 OR AMT_BILLED IS NULL)
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL4 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL5
SELECT * FROM (
WITH MCO_FAIL5 AS (
SELECT DISTINCT
5 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'BILL_PROV_ID' AS DESC1, BILL_PROV_ID AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND BILL_PROV_ID IN (' ','-','+','#')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL5 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL6
SELECT * FROM (
WITH MCO_FAIL6 AS (
SELECT DISTINCT
6 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'BILL_PROV_ID_TYPE' AS DESC1, BILL_PROV_ID_TYPE AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND SUBSTR(BILL_PROV_ID_TYPE,1,1) NOT IN ('1','6','9')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL6 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL7
SELECT * FROM (
WITH MCO_FAIL7 AS (
SELECT DISTINCT
7 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'BILL_NPI' AS DESC3, BILL_NPI AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE NOT IN ('P','D') and BILL_NPI IN('MISSING','+','-',' ','0')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL7 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL8
SELECT * FROM (
WITH MCO_FAIL8 AS (
SELECT DISTINCT
8 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'DSC_ENC_CLAIM_CAT' AS DESC1, DSC_ENC_CLAIM_CAT AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND SUBSTR(DSC_ENC_CLAIM_CAT,1,1) NOT IN ('1','2','3','4','5','6','7')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL8 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL9
SELECT * FROM (
WITH MCO_FAIL9 AS (
SELECT DISTINCT
9 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'DATE_SCRIPT_WRITTEN' AS DESC3, TO_CHAR(DATE_SCRIPT_WRITTEN,'YYYYMMDD') AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND DATE_SCRIPT_WRITTEN IS NULL
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL9 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL10
SELECT * FROM (
WITH MCO_FAIL10 AS (
SELECT DISTINCT
10 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_TYPE_OF_BILL_ENC' AS DESC2, CDE_TYPE_OF_BILL_ENC AS VALUE2, 'DSC_PATIENT_STATUS' AS DESC3, DSC_PATIENT_STATUS AS VALUE3,
'DISCHARGE_DT' AS DESC4, TO_CHAR(DISCHARGE_DT,'YYYYMMDD') AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND (CLAIM_TYPE='I' AND SUBSTR(CDE_TYPE_OF_BILL_ENC,1,2) <> '21' and SUBSTR(DSC_PATIENT_STATUS,1,2) NOT BETWEEN '30' AND '39') 
      AND ( DISCHARGE_DT IS NULL OR ( ADMIT_DT IS NOT NULL AND DISCHARGE_DT < ADMIT_DT ) )  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL10 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL11
SELECT * FROM (
WITH MCO_FAIL11 AS (
SELECT DISTINCT
11 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'DSC_ENC_DISP_AS_WRTN' AS DESC3, DSC_ENC_DISP_AS_WRTN AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND SUBSTR(DSC_ENC_DISP_AS_WRTN,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9')  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL11 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL12
SELECT * FROM (
WITH MCO_FAIL12 AS (
SELECT DISTINCT
12 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'AMT_NDC_PROFEE' AS DESC3, TO_CHAR(AMT_NDC_PROFEE,'999999999.99') AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND AMT_NDC_PROFEE IS NULL  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL12 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL13
SELECT * FROM (
WITH MCO_FAIL13 AS (
SELECT DISTINCT
13 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'DOS_FROM' AS DESC1, TO_CHAR(DOS_FROM,'YYYYMMDD') AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
--WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
WHERE DOS_FROM IS NULL  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL13 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL14
SELECT * FROM (
WITH MCO_FAIL14 AS (
SELECT DISTINCT
14 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'CDE_ICD_VERSION' AS DESC3, TO_CHAR(CDE_ICD_VERSION,'99') AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND CDE_ICD_VERSION NOT IN(9,10)  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL14 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL15
SELECT * FROM (
WITH MCO_FAIL15 AS (
SELECT DISTINCT
15 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'IND_ENC_COMPOUND' AS DESC3, IND_ENC_COMPOUND AS VALUE3,
'CDE_NDC' AS DESC4, CDE_NDC AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND IND_ENC_COMPOUND='2' AND CDE_NDC IN (' ','-','+','#')  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL15 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL16
SELECT * FROM (
WITH MCO_FAIL16 AS (
SELECT DISTINCT
16 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'AMT_PAID' AS DESC1, TO_CHAR(AMT_PAID,'999,999,999.99') AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND (AMT_PAID < 0 OR AMT_PAID IS NULL)  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL16 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL17
SELECT * FROM (
WITH MCO_FAIL17 AS (
SELECT DISTINCT
17 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'ID_MEDICAID' AS DESC1, ID_MEDICAID AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND SUBSTR(ID_MEDICAID,1,1) <> '1'  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL17 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL18
SELECT * FROM (
WITH MCO_FAIL18 AS (
SELECT DISTINCT
18 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_PATIENT_STATUS' AS DESC2, CDE_PATIENT_STATUS AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE IN('I','O') AND CDE_PATIENT_STATUS IN ('+', '-', ' ')  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL18 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL19
-- changed OR
SELECT * FROM (
WITH MCO_FAIL19 AS (
SELECT DISTINCT
19 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_CLAIM_CAT' AS DESC2, CDE_ENC_CLAIM_CAT AS VALUE2, 'CDE_TYPE_OF_BILL_ENC' AS DESC3, CDE_TYPE_OF_BILL_ENC AS VALUE3,
'CDE_PLACE_OF_SERVICE_ENC' AS DESC4, CDE_PLACE_OF_SERVICE_ENC AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE NOT IN('P','D') AND                                                                                    
      ( SUBSTR(CDE_PLACE_OF_SERVICE_ENC,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9') OR
        SUBSTR(CDE_PLACE_OF_SERVICE_ENC,2,1) NOT IN('0','1','2','3','4','5','6','7','8','9'))
       AND
      ( SUBSTR(CDE_TYPE_OF_BILL_ENC,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9') OR
        SUBSTR(CDE_TYPE_OF_BILL_ENC,2,1) NOT IN('0','1','2','3','4','5','6','7','8','9'))
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL19 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL20
SELECT * FROM (
WITH MCO_FAIL20 AS (
SELECT DISTINCT
20 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'ENC_PRES_PROV_ID' AS DESC3, ENC_PRES_PROV_ID AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS='F' AND ENC_PRES_PROV_ID IN ('+','-',' ')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL20 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
);

-- PART 2

INSERT INTO MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_FAILS
-- MCO_FAIL21
SELECT * FROM (
WITH MCO_FAIL21 AS (
SELECT DISTINCT
21 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'PRES_PROV_ID_TYPE' AS DESC3, PRES_PROV_ID_TYPE AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND SUBSTR(PRES_PROV_ID_TYPE,1,1) NOT IN ('1','6','8')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL21 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL22
SELECT * FROM (
WITH MCO_FAIL22 AS (
SELECT DISTINCT
22 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'RX_NUMBER' AS DESC3, RX_NUMBER AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND RX_NUMBER IN (' ','-','+','#')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL22 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL23
SELECT * FROM (
WITH MCO_FAIL23 AS (
SELECT DISTINCT
23 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'PRIMARY_DIAG' AS DESC3, PRIMARY_DIAG AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND PRIMARY_DIAG in ('+','-', ' ')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL23 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL24
SELECT * FROM (
WITH MCO_FAIL24 AS (
SELECT DISTINCT
24 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'PROC_CODE' AS DESC3, PROC_CODE AS VALUE3,
'CDE_ENC_PROC_TYPE' AS DESC4, CDE_ENC_PROC_TYPE AS VALUE4, 'PROC_CODE_ENC' AS DESC5, PROC_CODE_ENC AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN ('M') AND (PROC_CODE in(' ','-','+','#') OR 
(CDE_ENC_PROC_TYPE ='7' AND PROC_CODE_ENC IN (' ','-','+','#')))
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL24 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL25
SELECT * FROM (
WITH MCO_FAIL25 AS (
SELECT DISTINCT
25 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'QTY_UNITS_BILLED' AS DESC2, TO_CHAR(QTY_UNITS_BILLED, '999,999,999,999.99') AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE NOT IN('P') and QTY_UNITS_BILLED IS NULL
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL25 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL26
/* JPL 20230927, include 8 and 9)*/
SELECT * FROM (
WITH MCO_FAIL26 AS (
SELECT DISTINCT
26 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'DSC_ENC_REC_IND' AS DESC1,  DSC_ENC_REC_IND AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND SUBSTR(DSC_ENC_REC_IND,1,1) NOT IN ('0','1','2','3','4','5','6','7','8','9')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL26 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL27
SELECT * FROM (
WITH MCO_FAIL27 AS (
SELECT DISTINCT
27 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_DRUG_CLASS' AS DESC2, CDE_DRUG_CLASS AS VALUE2, 'QTY_REFILL' AS DESC3, TO_CHAR(QTY_REFILL, '9,999,999,999.99') AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND (QTY_REFILL IS NULL or QTY_REFILL < 0)
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL27 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL28
SELECT * FROM (
WITH MCO_FAIL28 AS (
SELECT DISTINCT
28 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'DSC_REVENUE' AS DESC3, DSC_REVENUE AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE IN('I','O','L') and CDE_ENC_REC_IND <> '0' AND SUBSTR(DSC_REVENUE,1,1) NOT IN ('0','1','2','3','4','5','6','7','8','9')
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL28 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL29
SELECT * FROM (
WITH MCO_FAIL29 AS (
SELECT DISTINCT
29 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'SERV_NPI' AS DESC3, SERV_NPI AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE NOT IN ('P','D') AND SERV_NPI IN('MISSING','+','-',' ','0') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL29 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL30
SELECT * FROM (
WITH MCO_FAIL30 AS (
SELECT DISTINCT
30 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_REC_IND' AS DESC2, CDE_ENC_REC_IND AS VALUE2, 'SERV_NPI' AS DESC3, SERV_NPI AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE NOT IN ('P','D') AND SERV_NPI IN('MISSING','+','-',' ','0') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL30 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL31
SELECT * FROM (
WITH MCO_FAIL31 AS (
SELECT DISTINCT
31 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'ENC_SERV_PROV_ID' AS DESC1, ENC_SERV_PROV_ID AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND ENC_SERV_PROV_ID IN (' ','-','+','#') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL31 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL32
SELECT * FROM (
WITH MCO_FAIL32 AS (
SELECT DISTINCT
32 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'SERV_PROV_ID_TYPE' AS DESC1, SERV_PROV_ID_TYPE AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND SUBSTR(SERV_PROV_ID_TYPE,1,1) NOT IN ('1','6','9') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL32 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL33
SELECT * FROM (
WITH MCO_FAIL33 AS (
SELECT DISTINCT
33 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'ENC_SERV_PROV_TYPE' AS DESC1, ENC_SERV_PROV_TYPE AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND ENC_SERV_PROV_TYPE IN (' ','-','+','#') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL33 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL34
SELECT * FROM (
WITH MCO_FAIL34 AS (
SELECT DISTINCT
34 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_ADMIT_SOURCE' AS DESC2, CDE_ADMIT_SOURCE AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE IN('I','L') AND CDE_ADMIT_SOURCE NOT IN ('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F') 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL34 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL35
SELECT * FROM (
WITH MCO_FAIL35 AS (
SELECT DISTINCT
35 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'DOS_THRU' AS DESC1, TO_CHAR(DOS_THRU,'YYYYMMDD') AS VALUE1, NULL AS DESC2, NULL AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND DOS_THRU IS NULL 
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL35 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL36
SELECT * FROM (
WITH MCO_FAIL36 AS (
SELECT DISTINCT
36 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1, CLAIM_TYPE AS VALUE1, 'CDE_ADMIT_TYPE' AS DESC2, CDE_ADMIT_TYPE AS VALUE2, NULL AS DESC3, NULL AS VALUE3,
NULL AS DESC4, NULL AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE IN('I','L') AND CDE_ADMIT_TYPE NOT IN ('1','2','3','4','5','6','7','8','9')  
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL36 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
)
UNION
-- MCO_FAIL37
-- changed OR
SELECT * FROM (
WITH MCO_FAIL37 AS (
SELECT DISTINCT
37 AS ID, 
CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX,CDE_CLM_DISPOSITION,DOS_FROM,CLAIM_TYPE,
'CLAIM_TYPE' AS DESC1,  CLAIM_TYPE AS VALUE1, 'CDE_ENC_CLAIM_CAT' AS DESC2, CDE_ENC_CLAIM_CAT AS VALUE2, 'CDE_TYPE_OF_BILL_ENC' AS DESC3, CDE_TYPE_OF_BILL_ENC AS VALUE3,
'CDE_PLACE_OF_SERVICE_ENC' AS DESC4, CDE_PLACE_OF_SERVICE_ENC AS VALUE4, NULL AS DESC5, NULL AS VALUE5
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBHP_DOS 
WHERE TO_CHAR(DOS_FROM,'YYYYMM') = SUBSTR('~MAXS~',1,6)
AND CLAIM_TYPE NOT IN('P','D') AND                                                                                    
     ((CDE_ENC_CLAIM_CAT IN('2','3','4','5') AND 
       SUBSTR(CDE_PLACE_OF_SERVICE_ENC,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9') OR
       SUBSTR(CDE_PLACE_OF_SERVICE_ENC,2,1) NOT IN('0','1','2','3','4','5','6','7','8','9'))
       OR
       (CDE_ENC_CLAIM_CAT in('1','6') AND 
       SUBSTR(CDE_TYPE_OF_BILL_ENC,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9') OR
       SUBSTR(CDE_TYPE_OF_BILL_ENC,2,1) NOT IN('0','1','2','3','4','5','6','7','8','9')))
ORDER BY CDE_ENC_MCO,CDE_ENC_ACO,ENC_CLAIM_NO,ENC_CLAIM_SUFFIX
)
SELECT
  TO_DATE('~RUN_DATE~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  L.ID,
  L.BENCHMARK,
  L.FIELD_ID,
  L.BENCHMARK_THRESHOLD,
  F.CDE_ENC_MCO,
  F.CDE_ENC_ACO,
  F.ENC_CLAIM_NO,
  F.ENC_CLAIM_SUFFIX,
  F.CDE_CLM_DISPOSITION,
  F.DOS_FROM,
  F.CLAIM_TYPE,
  NULL AS ETL_CHECK,
  F.DESC1, 
  F.VALUE1, 
  F.DESC2, 
  F.VALUE2,
  F.DESC3, 
  F.VALUE3,
  F.DESC4, 
  F.VALUE4,
  F.DESC5, 
  F.VALUE5
FROM  
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L
JOIN MCO_FAIL37 F ON L.ID = F.ID 
ORDER BY L.ID, CDE_ENC_MCO, CDE_ENC_ACO, ENC_CLAIM_NO, ENC_CLAIM_SUFFIX
);

-- Step 1 to Step 3 for Maplet Data

--truncate table INF_B_SC_STG_MCO_MBH_REP_STEP1; is in the pre-SQL of first read

insert into MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP1
select
'~QUERY_MONTH~' as query_month,
dos_yrmonth as month_service,
meas,
case when meas ='PCT_ID_MEDICAID' or meas ='PCT_DOS_FROM' or meas ='PCT_DOS_THRU' or 
          meas ='PCT_SERV_PROV_ID' or meas ='PCT_SERV_PROV_ID_TYP' or meas ='PCT_SERV_PROV_TYP' or
          meas ='PCT_SERV_PROV_SPEC' or meas ='PCT_BILL_PROV_ID' or meas ='PCT_BILL_PROV_ID_TYP' or  
          meas='PCT_SVC_CAT' or meas='PCT_CLAIMCAT' or 
          meas='PCT_RECIND' or meas='PCT_AMTBILL' or meas='PCT_AMTALLOW' or meas='PCT_AMTPAY' or
          meas='PCT_PAID_DT' or meas='PCT_SERV_ID_LOC' or meas='PCT_BILL_ID_LOC' or meas='PCT_TPL' or
          meas='PCT_COPAY' or meas='PCT_COINS' or meas='PCT_CLMDISP' or meas='PCT_CLMNUM' or
          meas='PCT_CLMSUF' or meas='PCT_NUMLOGCLM' or meas='PCT_ACO'
     then 'All Claim Types' 

     when meas='PCT_QTY_UNIT_BILL' then 'Non Pharmacy'

     when meas='PCT_PRESCRIBE_PROV_ID' or meas='PCT_PRES_PROV_ID_TYP' or meas='PCT_SCRIPT_WRITTEN' or
          meas='PCT_REFILL' or meas='PCT_DISPENSE' or meas='PCT_SCRIPT' or meas='PCT_FEE' or 
          meas='PCT_PRS_ID_LOC'
     then 'Pharmacy (prescriptions only, not OTC)'

     when meas='PCT_NDC' then 'Pharmacy (prescriptions only, not OTC and not compounded)'

     when meas='PCT_PRIMARY_DIAG' or meas='PCT_ICD_VERSION' or meas='PCT_POS_CODE' or 
          meas='PCT_POS_TYPE' or meas='PCT_SERV_NPI' or meas='PCT_BILL_NPI' 
     then 'Inpatient, Outpatient, Professional, and LTC'

     when meas='PCT_PROC_CODE_O_D' then 'Outpatient' 

     when meas='PCT_PROC_CODE_M' or meas='PCT_PROC_MOD_LABXRAY' or meas='PCT_PROC_MOD_SURGERYM' 
     then 'Professional'

     when meas='PCT_PROC_MOD_DME' then 'Professional (modifier=RR,NU,UE)'

     when meas='PCT_ADMITDT' or meas='PCT_ADMIT_TYPE' or meas='PCT_ADMIT_SOURCE' then 'Inpatient and LTC'

     when meas='PCT_DISCHARGEDT' or meas='PCT_DIAG_ADMIT' then 'Inpatient'

     when meas='PCT_PATIENT_STATUS' then 'Inpatient and Outpatient'

     when meas='PCT_REV_CODE' then 'Inpatient, Outpatient, and LTC'
end as claimtype,
cde_enc_mco as plan,
aco,
ROUND((actuals)*100,2) as actuals /*converting rate to a percent and rounding 2 decimal places*/
from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_TRANSPOSE;

--truncate table INF_B_SC_STG_MCO_MBH_REP_STEP2; done in pre-SQL step of first read

insert into MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2
select query_month, month_service, meas, claimtype, plan, aco, claim_count, actuals
from
(
select rpt1.*,
case when meas ='PCT_ID_MEDICAID' or meas ='PCT_DOS_FROM' or meas ='PCT_DOS_THRU' or 
          meas ='PCT_SERV_PROV_ID' or meas ='PCT_SERV_PROV_ID_TYP' or meas ='PCT_SERV_PROV_TYP' or
          meas ='PCT_SERV_PROV_SPEC' or meas ='PCT_BILL_PROV_ID' or meas ='PCT_BILL_PROV_ID_TYP' or  
          meas='PCT_SVC_CAT' or meas='PCT_CLAIMCAT' or 
          meas='PCT_RECIND' or meas='PCT_AMTBILL' or meas='PCT_AMTALLOW' or meas='PCT_AMTPAY' or
          meas='PCT_PAID_DT' or meas='PCT_SERV_ID_LOC' or meas='PCT_BILL_ID_LOC' or meas='PCT_TPL' or
          meas='PCT_COPAY' or meas='PCT_COINS' or meas='PCT_CLMDISP' or meas='PCT_CLMNUM' or
          meas='PCT_CLMSUF' or meas='PCT_NUMLOGCLM' or meas='PCT_ACO'
          then TOT_RECORDS
when meas='PCT_PRESCRIBE_PROV_ID' or meas='PCT_PRES_PROV_ID_TYP' or meas='PCT_SCRIPT_WRITTEN' or
     meas='PCT_REFILL' or meas='PCT_DISPENSE' or meas='PCT_SCRIPT' or meas='PCT_FEE' or
     meas='PCT_PRS_ID_LOC' then TOT_PHARM_SCRIPT
when meas='PCT_NDC' then TOT_PHARMSCRIPT_NOTCOMP
when meas='PCT_QTY_UNIT_BILL' then TOT_NONPHARM 
when meas='PCT_PRIMARY_DIAG' or meas='PCT_SERV_NPI' or meas='PCT_BILL_NPI' then TOT_NON_PHRM_DENTQ2 
when meas='PCT_ADMITDT' or meas='PCT_ADMIT_TYPE' or meas='PCT_ADMIT_SOURCE' then TOT_INPT_LTC
when meas='PCT_PRIMARY_DIAG' then TOT_NON_PHRM_DENTQ2
when meas='PCT_ICD_VERSION' then TOT_INP_OP_LTC_M_EXCQ2
when meas='PCT_PROC_CODE_M' then TOT_MEDQ2
when meas='PCT_PROC_CODE_O_D' then TOT_OUTPTQ2
when meas='PCT_PROC_MOD_DME' then TOT_MOD_DME
when meas='PCT_PROC_MOD_LABXRAY' then TOT_MOD_LABXRAY
when meas='PCT_PROC_MOD_SURGERYM' then TOT_MOD_SURGERYM
when meas='PCT_POS_CODE' or meas='PCT_POS_TYPE' then TOT_NON_PHRM_DENT
when meas='PCT_REV_CODE' then TOT_INOUTLTC_NOART
when meas='PCT_PATIENT_STATUS' then TOT_INPT_OUTPT
when meas='PCT_DIAG_ADMIT' then TOT_INPAT_FILTER2
when meas='PCT_DISCHARGEDT' then TOT_INPAT_FILTER1
end as claim_count
from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP1 rpt1
inner join (select cde_enc_mco, dos_yrmonth, aco, TOT_INPAT, TOT_PHARM, TOT_OUTPT, TOT_OUTPTQ2, TOT_DENT, TOT_DENTQ2, 
                   TOT_MED, TOT_MEDQ2, TOT_NON_PHRM_DENTQ2, TOT_PHARM_SCRIPT, TOT_INPT_LTC, 
                   TOT_INPT_OUTPT_LTC, TOT_INP_OP_LTC_M_EXCQ2, TOT_NON_PHRM_DENT, 
                   TOT_INPAT_FILTER1, TOT_INPAT_FILTER2, TOT_MOD_DME, TOT_MOD_LABXRAY, 
                   TOT_MOD_SURGERYM, TOT_INOUTLTC_NOART, TOT_INPT_OUTPT, TOT_PHARMSCRIPT_NOTCOMP,TOT_NONPHARM,
                   TOT_RECORDS
            from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_PTPDOS
            )rpt2
on rpt1.plan=rpt2.cde_enc_mco and rpt1.month_service=rpt2.dos_yrmonth and rpt1.aco=rpt2.aco);

-- Step2 Snapshot SQLs

--Delete the dummy month -  switch the dash to underscore
delete from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
where QUERY_MONTH = translate('~QUERY_MONTH~','-','_');

--Add the real data
insert into MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
(
  RUN_DATE,
  IND_ACTIVE,
  QUERY_MONTH,
  MON,
  MONTH_SERVICE,
  MEAS,
  CLAIMTYPE,
  PLAN,
  ACO,
  CLAIM_COUNT,
  ACTUALS
)
SELECT 
  TO_DATE('~Src_ASOFDT~','YYYYMMDD') AS RUN_DATE,
  'Y' AS IND_ACTIVE,
  '~QUERY_MONTH~' AS QUERY_MONTH,
  '~Src_MON~' AS MON,
  MONTH_SERVICE,
  MEAS,
  CLAIMTYPE,
  PLAN,
  ACO,
  CLAIM_COUNT,
  ACTUALS
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2;

-- Insert the new dummy month (4 of these)
insert into MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
(
  RUN_DATE,
  IND_ACTIVE,
  QUERY_MONTH,
  MON,
  MONTH_SERVICE,
  MEAS,
  CLAIMTYPE,
  PLAN,
  ACO,
  CLAIM_COUNT,
  ACTUALS
)
select distinct
  TO_DATE('~ASOFDT~','YYYYMMDD') AS RUN_DATE,
  'Y' AS IND_ACTIVE,
  '~QUERY_MON_PLUS_3~' AS QUERY_MONTH,
  '~DUMMY_MON~' AS MON,
  '~DUMMY_DOS_1~' AS MONTH_SERVICE,
  MEAS,
  CLAIMTYPE,
  PLAN,
  ACO,
  NULL AS CLAIM_COUNT,
  NULL AS ACTUALS
from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2;

-- Just to make sure they are all underscores for STEP3 - will reverse in final views
update MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
set 
query_month = substr(query_month,1,4) || '_' || substr(query_month,6,2),
month_service = substr(month_service,1,4) || '_' || substr(month_service,6,2);

-- Step2 Snapshots Delete
--Delete the dummy month -  switch the dash to underscore
delete from MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
where QUERY_MONTH = translate('~QUERY_MONTH~','-','_');

-- Step2 Update

-- Just to make sure they are all underscores for STEP3 - will reverse in final views
update MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
set 
query_month = substr(query_month,1,4) || '_' || substr(query_month,6,2),
month_service = substr(month_service,1,4) || '_' || substr(month_service,6,2);

-- Step3

-- to break SQL CREATE TABLE INF_B_SC_STG_MCO_MBH_REP_STEP3 AS
INSERT INTO MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP3
SELECT
  T.PLAN,
  T.ACO,
  L.ID,
  L.BENCHMARK,
  L.BENCHMARK_NAME,
  L.FIELD_ID,
  L.CLAIM_TYPE,
  L.BENCHMARK_THRESHOLD,
  T.A_MONTH_SERVICE,
  C.A_CLM,
  T.A_ACT_4,
  T.A_ACT_3,
  T.A_ACT_2,
  T.A_ACT_1,
  T.B_MONTH_SERVICE,
  C.B_CLM,
  T.B_ACT_5,
  T.B_ACT_4,
  T.B_ACT_3,
  T.B_ACT_2,
  T.C_MONTH_SERVICE,
  C.C_CLM,
  T.C_ACT_6,
  T.C_ACT_5,
  T.C_ACT_4,
  T.C_ACT_3,
  T.D_MONTH_SERVICE,
  C.D_CLM,
  T.D_ACT_7,
  T.D_ACT_6,
  T.D_ACT_5,
  T.D_ACT_4,
  '~RUN_DATE_STR~' AS RUN_DATE_STR,
  '~LAST_SUB_STR~' AS LAST_SUB_STR,
  TO_DATE('~ASOFDT~','YYYYMMDD') AS RUN_DATE,
  TO_NUMBER('~DQ_BATCH_SEQ~','99999999') AS DQ_BATCH_SEQ,  
  '~REP_DOS1~' AS A_CLM_HDR,    
  '~REP_MON4~' AS A_ACT_4_HDR,    
  '~REP_MON3~' AS A_ACT_3_HDR,    
  '~REP_MON2~' AS A_ACT_2_HDR,    
  '~REP_MON1~' AS A_ACT_1_HDR,    
  '~REP_DOS2~' AS B_CLM_HDR,    
  '~REP_MON5~' AS B_ACT_5_HDR,    
  '~REP_MON4~' AS B_ACT_4_HDR,    
  '~REP_MON3~' AS B_ACT_3_HDR,    
  '~REP_MON2~' AS B_ACT_2_HDR,    
  '~REP_DOS3~' AS C_CLM_HDR,    
  '~REP_MON6~' AS C_ACT_6_HDR,    
  '~REP_MON5~' AS C_ACT_5_HDR,    
  '~REP_MON4~' AS C_ACT_4_HDR,    
  '~REP_MON3~' AS C_ACT_3_HDR,    
  '~REP_DOS4~' AS D_CLM_HDR,    
  '~REP_MON7~' AS D_ACT_7_HDR,    
  '~REP_MON6~' AS D_ACT_6_HDR,    
  '~REP_MON5~' AS D_ACT_5_HDR,    
  '~REP_MON4~' AS D_ACT_4_HDR  
FROM (
WITH COMP AS (
SELECT PLAN, ACO, MEAS, MONTH_SERVICE,
"'ACT_~REP_MON7~'" AS ACT_~REP_MON7~,
"'ACT_~REP_MON6~'" AS ACT_~REP_MON6~,
"'ACT_~REP_MON5~'" AS ACT_~REP_MON5~,
"'ACT_~REP_MON4~'" AS ACT_~REP_MON4~,
"'ACT_~REP_MON3~'" AS ACT_~REP_MON3~,
"'ACT_~REP_MON2~'" AS ACT_~REP_MON2~,
"'ACT_~REP_MON1~'" AS ACT_~REP_MON1~
FROM 
(
SELECT 
  PLAN,
  ACO,
  MEAS,
  MONTH_SERVICE,
  'ACT_' || QUERY_MONTH AS QUERY_MONTH,
  ACTUALS
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
WHERE MONTH_SERVICE IN ('~REP_DOS1~','~REP_DOS2~','~REP_DOS3~','~REP_DOS4~')
AND IND_ACTIVE = 'Y'
ORDER BY PLAN, ACO, MONTH_SERVICE, MEAS, QUERY_MONTH 
)
PIVOT ( 
MAX(ACTUALS)
FOR QUERY_MONTH IN ('ACT_~REP_MON7~', 'ACT_~REP_MON6~', 'ACT_~REP_MON5~', 'ACT_~REP_MON4~', 'ACT_~REP_MON3~', 'ACT_~REP_MON2~', 'ACT_~REP_MON1~' ) 
)
ORDER BY PLAN, ACO, MONTH_SERVICE, MEAS
),
FILL AS (
SELECT DISTINCT PLAN, ACO, MEAS
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS 
WHERE IND_ACTIVE = 'Y' )
SELECT F.PLAN, F.ACO, F.MEAS,  
A.MONTH_SERVICE AS A_MONTH_SERVICE, 
A.ACT_~REP_MON4~ AS A_ACT_4, A.ACT_~REP_MON3~ AS A_ACT_3, A.ACT_~REP_MON2~ AS A_ACT_2, A.ACT_~REP_MON1~ AS A_ACT_1,
B.MONTH_SERVICE AS B_MONTH_SERVICE, 
B.ACT_~REP_MON5~ AS B_ACT_5, B.ACT_~REP_MON4~ AS B_ACT_4, B.ACT_~REP_MON3~ AS B_ACT_3, B.ACT_~REP_MON2~ AS B_ACT_2,
C.MONTH_SERVICE AS C_MONTH_SERVICE, 
C.ACT_~REP_MON6~ AS C_ACT_6, C.ACT_~REP_MON5~ AS C_ACT_5, C.ACT_~REP_MON4~ AS C_ACT_4, C.ACT_~REP_MON3~ AS C_ACT_3,
D.MONTH_SERVICE AS D_MONTH_SERVICE, 
D.ACT_~REP_MON7~ AS D_ACT_7, D.ACT_~REP_MON6~ AS D_ACT_6, D.ACT_~REP_MON5~ AS D_ACT_5, D.ACT_~REP_MON4~ AS D_ACT_4
FROM FILL F
LEFT JOIN COMP A ON A.MONTH_SERVICE = '~REP_DOS1~' AND A.PLAN = F.PLAN AND A.ACO = F.ACO AND A.MEAS = F.MEAS
LEFT JOIN COMP B ON B.MONTH_SERVICE = '~REP_DOS2~' AND B.PLAN = F.PLAN AND B.ACO = F.ACO AND B.MEAS = F.MEAS
LEFT JOIN COMP C ON C.MONTH_SERVICE = '~REP_DOS3~' AND C.PLAN = F.PLAN AND C.ACO = F.ACO AND C.MEAS = F.MEAS
LEFT JOIN COMP D ON D.MONTH_SERVICE = '~REP_DOS4~' AND D.PLAN = F.PLAN AND D.ACO = F.ACO AND D.MEAS = F.MEAS
ORDER BY F.PLAN, F.ACO, F.MEAS
) T,
(
WITH COMP AS (
SELECT PLAN, ACO, MEAS, MONTH_SERVICE,
"'CLM_~REP_MON7~'" AS CLM_~REP_MON7~,
"'CLM_~REP_MON6~'" AS CLM_~REP_MON6~,
"'CLM_~REP_MON5~'" AS CLM_~REP_MON5~,
"'CLM_~REP_MON4~'" AS CLM_~REP_MON4~,
"'CLM_~REP_MON3~'" AS CLM_~REP_MON3~,
"'CLM_~REP_MON2~'" AS CLM_~REP_MON2~,
"'CLM_~REP_MON1~'" AS CLM_~REP_MON1~
FROM 
(
SELECT 
  PLAN,
  ACO,
  MEAS,
  MONTH_SERVICE,
  'CLM_' || QUERY_MONTH AS QUERY_MONTH,
  CLAIM_COUNT
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS
WHERE MONTH_SERVICE IN ('~REP_DOS1~','~REP_DOS2~','~REP_DOS3~','~REP_DOS4~')
AND IND_ACTIVE = 'Y'
ORDER BY PLAN, ACO, MONTH_SERVICE, MEAS, QUERY_MONTH 
)
PIVOT ( 
MAX(CLAIM_COUNT)
FOR QUERY_MONTH IN ('CLM_~REP_MON7~', 'CLM_~REP_MON6~', 'CLM_~REP_MON5~', 'CLM_~REP_MON4~', 'CLM_~REP_MON3~', 'CLM_~REP_MON2~', 'CLM_~REP_MON1~' ) 
)
ORDER BY PLAN, ACO, MONTH_SERVICE, MEAS
),
FILL AS (
SELECT DISTINCT PLAN, ACO, MEAS
FROM MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_REP_STEP2_SNAPSHOTS 
WHERE IND_ACTIVE = 'Y' )
SELECT F.PLAN, F.ACO, F.MEAS,  
A.MONTH_SERVICE AS A_MONTH_SERVICE, 
A.CLM_~REP_MON4~ AS A_CLM,
B.MONTH_SERVICE AS B_MONTH_SERVICE, 
B.CLM_~REP_MON4~ AS B_CLM,
C.MONTH_SERVICE AS C_MONTH_SERVICE, 
C.CLM_~REP_MON4~ AS C_CLM,
D.MONTH_SERVICE AS D_MONTH_SERVICE, 
D.CLM_~REP_MON4~ AS D_CLM
FROM FILL F
LEFT JOIN COMP A ON A.MONTH_SERVICE = '~REP_DOS1~' AND A.PLAN = F.PLAN AND A.ACO = F.ACO AND A.MEAS = F.MEAS
LEFT JOIN COMP B ON B.MONTH_SERVICE = '~REP_DOS2~' AND B.PLAN = F.PLAN AND B.ACO = F.ACO AND B.MEAS = F.MEAS
LEFT JOIN COMP C ON C.MONTH_SERVICE = '~REP_DOS3~' AND C.PLAN = F.PLAN AND C.ACO = F.ACO AND C.MEAS = F.MEAS
LEFT JOIN COMP D ON D.MONTH_SERVICE = '~REP_DOS4~' AND D.PLAN = F.PLAN AND D.ACO = F.ACO AND D.MEAS = F.MEAS
ORDER BY F.PLAN, F.ACO, F.MEAS
) C,
MHTEAM.DWDQ.INF_B_SC_STG_MCO_MBH_SCORECARD_LOOKUP L 
WHERE 1=1
AND T.MEAS = L.BENCHMARK_NAME
AND T.PLAN = C.PLAN AND T.ACO = C.ACO AND T.MEAS = C.MEAS 
AND T.A_MONTH_SERVICE = C.A_MONTH_SERVICE
ORDER BY T.PLAN, T.ACO, L.ID, T.A_MONTH_SERVICE;

