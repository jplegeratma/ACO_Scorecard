
CREATE TABLE MCO_MBHP_DOS_test 
         NOLOGGING 
         COMPRESS 
         AS 
         SELECT 
         ENC.CDE_ENC_MCO, 
         enc.cde_enc_aco, --Provider ID/Service Location (PIDSL) 
         enc.remit_from_dt, --paid date     
         ENCATT.CDE_ENC_REC_IND, 
         ENCATT.DSC_ENC_REC_IND, 
         ENC.DOS_FROM_DT AS DOS_FROM, 
         svc_prov.cde_enc_prov_id_loc as servicing_provider_loc_code, --address location code of service prov
         SVC_PROV.ID_PROVIDER AS SERV_PROV_ID, 
         SVC_PROV.ENC_PROV_ID AS ENC_SERV_PROV_ID, 
         SVC_PROV.DSC_ENC_PROV_ID_TYPE AS SERV_PROV_ID_TYPE, 
         SVC_PROV.CDE_ENC_PROV_TYPE AS ENC_SERV_PROV_TYPE, 
         NCF.CDE_ENC_PROV_SPEC AS SERV_PROV_SPECIALTY,
         PROV.ID_PROVIDER AS BILL_PROV_ID, 
         PROV.ENC_PROV_ID AS ENC_BILL_PROV_ID, 
         PROV.DSC_ENC_PROV_ID_TYPE AS BILL_PROV_ID_TYPE, 
         prov.cde_enc_prov_id_loc as billing_provider_id_loc_code, --new field
         PRS_PROV.ID_PROVIDER AS PRES_PROV_ID, 
         PRS_PROV.ENC_PROV_ID AS ENC_PRES_PROV_ID, 
         PRS_PROV.DSC_ENC_PROV_ID_TYPE AS PRES_PROV_ID_TYPE,
         prs_prov.cde_enc_prov_id_loc as prs_provider_id_loc_code, --new field 
         ENC.CDE_CLM_TYPE AS CLAIM_TYPE, 
         ENC.ENC_CLAIM_NO, 
         ENC.ENC_CLAIM_SUFFIX 
         FROM NW_ENCOUNTER_HIST ENC 
         LEFT OUTER JOIN NW.NW_ENC_ATTRIBUTE ENCATT ON ENC.ATTRENC_SEQ = ENCATT.ATTRENC_SEQ 
         LEFT OUTER JOIN NW_CLAIM_SERVICE_ATTRIBUTE CSA ON ENC.ATTRSRV_SEQ = CSA.ATTRSRV_SEQ 
         LEFT OUTER JOIN NW_ENC_PROVIDER PROV ON ENC.BILL_ENCPRV_SEQ = PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN NW_ENC_PROVIDER SVC_PROV ON ENC.SRV_ENCPRV_SEQ = SVC_PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN NW_ENC_PROVIDER PRS_PROV ON ENC.PRS_ENCPRV_SEQ = PRS_PROV.ENCPRV_SEQ 
         LEFT OUTER JOIN NW_ENC_NONCONF_ATTRIBUTE NCF ON NCF.ATTRENC_NC_SEQ = ENC.ATTRENC_NC_SEQ 
 
         WHERE  ENC.DOS_FROM_DT BETWEEN TO_DATE('20170201','YYYYMMDD') and TO_DATE('20180131','YYYYMMDD')
         AND  ENC.REMIT_THRU_DT = TO_DATE('99991231','YYYYMMDD')   
         AND TO_DATE('20180429','YYYYMMDD') BETWEEN ENC.WH_FROM_DT AND ENC.WH_THRU_DT   
         AND ENC.CDE_CLM_DISPOSITION <> 'V' 
         AND ENC.IND_OFFSET = 'N' 
         AND ENC.CDE_ENC_MCO IN('BMC','CHA','FLN','NHP','HNE','MBH')
         
         select cde_enc_mco,cde_enc_aco,count(*)  -- + or # for all
         from MCO_MBHP_DOS_test  
         group by cde_enc_mco,cde_enc_aco
         
         select cde_enc_mco,billing_provider_id_loc_code,count(*)
         from MCO_MBHP_DOS_test  
         group by cde_enc_mco,billing_provider_id_loc_code
         
         select cde_enc_mco,count(*)
         from MCO_MBHP_DOS_test  
         where remit_from_dt is not null
         --where remit_from_dt is null
         group by cde_enc_mco