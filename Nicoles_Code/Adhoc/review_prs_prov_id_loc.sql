/*need to restrict numerator to claimtype=P and OTC that is why %>100*/

/*Prescribing Provider ID address location code- field 224*/    
case when prs_prov_id_loc_code not in(' ','+','#','-') then 1 else 0 end as prs_id_loc1,


/* PRESCRIBING PROVIDER ID ADDRESS LOCATION  */   
CASE WHEN PRS_ID_LOC2 = 0 THEN 0 
            ELSE trunc((PRS_ID_LOC2/S.TOT_PHARM_SCRIPT),4)
END AS PCT_PRS_ID_LOC,

select sum(prs_id_loc2)
FROM MCO_MBH_FLDREX_feb2017_jan2018 where cde_enc_mco='NHP'  --262979
select case when CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS = 'F' and prs_prov_id_loc_code not in(' ','+','#','-') then 1 else 0 end as prs_id_loc1,
select cde_enc_mco,tot_pharm_script,pct_prs_id_loc
from mco_mbh_pcnt_feb2017_jan2018 where rownum<3

select *  --claim_count=235242
from mco_mbh_report_feb2017_jan2018
where actual>100

select *  --tot_pharm_script=235,242; denom
from MCO_MBH_TDOS_feb2017_jan2018 where cde_enc_mco='NHP' and dos_yrmonth='2017-08'

select *  --prs_id_loc2 = 260,307; numerator: this is why >100 b/c didn't restrict on clmtype and otc!
from MCO_MBH_FRDOS_feb2017_jan2018 where cde_enc_mco='NHP' and dos_yrmonth='2017-08'

select tot_pharm_script,dos_yrmonth,pct_prs_id_loc from mco_mbh_pctdos_feb2017_jan2018 where cde_enc_mco='NHP'
--tot_pharm_script=235242; dosmonth=8-2017; pct 1.1065
