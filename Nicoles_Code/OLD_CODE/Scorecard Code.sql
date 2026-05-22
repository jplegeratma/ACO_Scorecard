/*Same as 'Feedback on Report Distribution Code*/
/*Data to populate Summary tab and Timeliness Tabs*/

--Summary Tab rollup
--Use load_status per Alla
select month, count(distinct zip_file_name)
from(
select TO_CHAR(metadata_date_created,'YYYY-MM') AS MONTH ,zip_file_name,
CASE  WHEN md_batch_seq_scrub IS NULL THEN 'File Failed'  
      WHEN md_batch_seq_nw  IS NULL THEN 'File processed but not loaded'        
    ELSE 'Successfully Loaded'
END as LOAD_STATUS
from nw_enc_statistics stat
inner join ods_encounter enc
on enc.md_batch_seq=stat.md_batch_seq_ods and stat.cde_enc_mco=enc.cde_enc_mco
where stat.cde_enc_mco='BMC' --and cde_load_status='Success'
and metadata_date_created between TO_DATE('20180801','yyyymmdd') and TO_DATE('20190131','yyyymmdd') --rolling history of 6months
)
where load_status='Successfully Loaded'
group by month 

--Timeliness tab zip file detail
--how can wh insert date be < metadata date created?
--using process_end_tm date instead
select distinct zip_file_name,metadata_date_created,
 max(process_end_tm) over (partition  by zip_file_name) as processdt,
 max(to_char(process_end_tm,'mm/dd/yyyy')) over (partition by zip_file_name) as processdt2,
 --max(wh_insert_dt_tm) over (partition  by zip_file_name) as loaddt,
 --max(to_char(wh_insert_dt_tm,'mm/dd/yyyy')) over (partition by zip_file_name) as loaddt2,
 ind_manual_override,ind_amendment,
 /*added this case statement per Alla*/
 CASE
         WHEN md_batch_seq_scrub IS NULL THEN 'File Failed'  
            WHEN md_batch_seq_nw  IS NULL THEN 'File processed but not loaded'        
          ELSE 'Successfully Loaded'
       END
          Load_status,cde_load_status

--md_batch_seq_nw,stat.cde_enc_mco,zip_file_name,metadata_date_created,metadata_from_dt,metadata_thru_dt,
--ind_manual_override,ind_amendment,process_start_tm,cde_load_status,md_batch_seq
from nw_enc_statistics stat
inner join ods_encounter enc
on enc.md_batch_seq=stat.md_batch_seq_ods and stat.cde_enc_mco=enc.cde_enc_mco
where stat.cde_enc_mco='BMC' 
and metadata_date_created between TO_DATE('20180801','yyyymmdd') and TO_DATE('20190131','yyyymmdd') --rolling history of 6months
order by metadata_date_created

--Completeness

SELECT query_month,month_service,plan,aco,benchmark_name,measure,claim_count,actual/100 as pct,actual
from
(
select rpt.*,
case when measure='PCT_ADMITDT' then 'Admission Date'
when measure='PCT_DIAG_ADMIT' then 'Admitting Diagnosis'
when measure='PCT_AMTALLOW' then 'Allowable Amount'
when measure='PCT_AMTBILL' then 'Billed Amount'
when measure='PCT_BILL_PROV_ID' then 'Billing Provider ID'
when measure='PCT_BILL_PROV_ID_TYP' then 'Billing Provider ID Type'
when measure='PCT_BILL_NPI' then 'Billing Provider NPI'
when measure='PCT_CLAIMCAT' then 'Claim Category'
when measure='PCT_SCRIPT_WRITTEN' then 'Date Script Written'
when measure='PCT_DISCHARGEDT' then 'Discharge Date'
when measure='PCT_DISPENSE' then 'Dispense As Written'
when measure='PCT_FEE' then 'Dispensing Fee'
when measure='PCT_DOS_FROM' then 'From Service Date'
when measure='PCT_ICD_VERSION' then 'ICD Version Qualifier'
when measure='PCT_NDC' then 'NDC Number'
when measure='PCT_AMTPAY' then 'Net Amount Paid'
when measure='PCT_ID_MEDICAID' then 'Nzz Member ID' --had to change name b/c Whitney put out of alphabetical order in report and this adjusts for that in the sort
when measure='PCT_PATIENT_STATUS' then 'Patient Discharge Status'
when measure='PCT_POS_CODE' then 'Place of Service'
when measure='PCT_PRESCRIBE_PROV_ID' then 'Prescribing Prov. ID'
when measure='PCT_PRES_PROV_ID_TYP' then 'Prescribing Prov. ID Type'
when measure='PCT_SCRIPT' then 'Prescription Number'
when measure='PCT_PRIMARY_DIAG' then 'Primary Diagnosis'
when measure='PCT_PROC_CODE_M' then 'Procedure Code Prof_M'
when measure='PCT_QTY_UNIT_BILL' then 'Quantity'
when measure='PCT_RECIND' then 'Record Indicator'
when measure='PCT_REFILL' then 'Refill Indicator'
when measure='PCT_REV_CODE' then 'Revenue Code'
when measure='PCT_SVC_CAT' then 'Service Category'
when measure='PCT_SERV_NPI' then 'Servicing Prov NPI'
when measure='PCT_SERV_PROV_ID' then 'Servicing Provider ID'
when measure='PCT_SERV_PROV_ID_TYP' then 'Servicing Provider ID Type'
when measure='PCT_SERV_PROV_TYP' then 'Servicing Provider Type'
when measure='PCT_ADMIT_SOURCE' then 'Source of Admission'
when measure='PCT_DOS_THRU' then 'To Service Date'
when measure='PCT_ADMIT_TYPE' then 'Type of Admission'
when measure='PCT_POS_TYPE' then 'Type of Bill (Place of Service Type)'
end as benchmark_name
from MCO_MBH_REPORT_may2018_aug2018 rpt
where measure in(
'PCT_ADMITDT',
'PCT_DIAG_ADMIT',
'PCT_AMTALLOW',
'PCT_AMTBILL',
'PCT_BILL_PROV_ID',
'PCT_BILL_PROV_ID_TYP',
'PCT_BILL_NPI',
'PCT_CLAIMCAT',
'PCT_SCRIPT_WRITTEN',
'PCT_DISCHARGEDT',
'PCT_DISPENSE',
'PCT_FEE',
'PCT_DOS_FROM',
'PCT_ICD_VERSION',
'PCT_NDC',
'PCT_AMTPAY',
'PCT_ID_MEDICAID',
'PCT_PATIENT_STATUS',
'PCT_POS_CODE',
'PCT_PRESCRIBE_PROV_ID',
'PCT_PRES_PROV_ID_TYP',
'PCT_SCRIPT',
'PCT_PRIMARY_DIAG',
'PCT_PROC_CODE_M',
'PCT_QTY_UNIT_BILL',
'PCT_RECIND',
'PCT_REFILL',
'PCT_REV_CODE',
'PCT_SVC_CAT',
'PCT_SERV_NPI',
'PCT_SERV_PROV_ID',
'PCT_SERV_PROV_ID_TYP',
'PCT_SERV_PROV_TYP',
'PCT_ADMIT_SOURCE',
'PCT_DOS_THRU',
'PCT_ADMIT_TYPE',
'PCT_POS_TYPE')
and plan='BMC'
and aco='BMC-BACO' --ACO:BMC-MERCY; BMC-SIGN;BMC-SCOAST;BMC-BACO; NA;LAHEY
and month_service='2018-06' --2018-05 thru 2018-08
)order by benchmark_name


--Completeness: BMC Aggregate
SELECT query_month,month_service,plan,benchmark_name,measure,claim_count,actual/100 as pct
from
(
select rpt.*,
case when measure='PCT_ADMITDT' then 'Admission Date'
when measure='PCT_DIAG_ADMIT' then 'Admitting Diagnosis'
when measure='PCT_AMTALLOW' then 'Allowable Amount'
when measure='PCT_AMTBILL' then 'Billed Amount'
when measure='PCT_BILL_PROV_ID' then 'Billing Provider ID'
when measure='PCT_BILL_PROV_ID_TYP' then 'Billing Provider ID Type'
when measure='PCT_BILL_NPI' then 'Billing Provider NPI'
when measure='PCT_CLAIMCAT' then 'Claim Category'
when measure='PCT_SCRIPT_WRITTEN' then 'Date Script Written'
when measure='PCT_DISCHARGEDT' then 'Discharge Date'
when measure='PCT_DISPENSE' then 'Dispense As Written'
when measure='PCT_FEE' then 'Dispensing Fee'
when measure='PCT_DOS_FROM' then 'From Service Date'
when measure='PCT_ICD_VERSION' then 'ICD Version Qualifier'
when measure='PCT_NDC' then 'NDC Number'
when measure='PCT_AMTPAY' then 'Net Amount Paid'
when measure='PCT_ID_MEDICAID' then 'Nzz Member ID' --had to change name b/c Whitney put out of alphabetical order in report and this adjusts for that in the sort
when measure='PCT_PATIENT_STATUS' then 'Patient Discharge Status'
when measure='PCT_POS_CODE' then 'Place of Service'
when measure='PCT_PRESCRIBE_PROV_ID' then 'Prescribing Prov. ID'
when measure='PCT_PRES_PROV_ID_TYP' then 'Prescribing Prov. ID Type'
when measure='PCT_SCRIPT' then 'Prescription Number'
when measure='PCT_PRIMARY_DIAG' then 'Primary Diagnosis'
when measure='PCT_PROC_CODE_M' then 'Procedure Code Prof_M'
when measure='PCT_QTY_UNIT_BILL' then 'Quantity'
when measure='PCT_RECIND' then 'Record Indicator'
when measure='PCT_REFILL' then 'Refill Indicator'
when measure='PCT_REV_CODE' then 'Revenue Code'
when measure='PCT_SVC_CAT' then 'Service Category'
when measure='PCT_SERV_NPI' then 'Servicing Prov NPI'
when measure='PCT_SERV_PROV_ID' then 'Servicing Provider ID'
when measure='PCT_SERV_PROV_ID_TYP' then 'Servicing Provider ID Type'
when measure='PCT_SERV_PROV_TYP' then 'Servicing Provider Type'
when measure='PCT_ADMIT_SOURCE' then 'Source of Admission'
when measure='PCT_DOS_THRU' then 'To Service Date'
when measure='PCT_ADMIT_TYPE' then 'Type of Admission'
when measure='PCT_POS_TYPE' then 'Type of Bill (Place of Service Type)'
end as benchmark_name
from MCO_REPORT_BMCmay2018_aug2018 rpt
where measure in(
'PCT_ADMITDT',
'PCT_DIAG_ADMIT',
'PCT_AMTALLOW',
'PCT_AMTBILL',
'PCT_BILL_PROV_ID',
'PCT_BILL_PROV_ID_TYP',
'PCT_BILL_NPI',
'PCT_CLAIMCAT',
'PCT_SCRIPT_WRITTEN',
'PCT_DISCHARGEDT',
'PCT_DISPENSE',
'PCT_FEE',
'PCT_DOS_FROM',
'PCT_ICD_VERSION',
'PCT_NDC',
'PCT_AMTPAY',
'PCT_ID_MEDICAID',
'PCT_PATIENT_STATUS',
'PCT_POS_CODE',
'PCT_PRESCRIBE_PROV_ID',
'PCT_PRES_PROV_ID_TYP',
'PCT_SCRIPT',
'PCT_PRIMARY_DIAG',
'PCT_PROC_CODE_M',
'PCT_QTY_UNIT_BILL',
'PCT_RECIND',
'PCT_REFILL',
'PCT_REV_CODE',
'PCT_SVC_CAT',
'PCT_SERV_NPI',
'PCT_SERV_PROV_ID',
'PCT_SERV_PROV_ID_TYP',
'PCT_SERV_PROV_TYP',
'PCT_ADMIT_SOURCE',
'PCT_DOS_THRU',
'PCT_ADMIT_TYPE',
'PCT_POS_TYPE')
and plan='BMC'--Aggregate
and month_service='2018-08' --2018-05 thru 2018-08
)order by benchmark_name