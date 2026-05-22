****************************************************************************************
PROGRAM:    STEP3 GENERATE REPORT v2.0.SAS
RE:         OUTPUTS EXCEL SPREADSHEET SCO MEASURES 
            USER: UPDATE %LET MACRO VARIABLES
LOCATION:   \\ehs-clu-bos-001\W\APPLICATION ANALYSIS\PILOT SCO ENCOUNTERS REPORT CARD
PROGRAMMER: NT
DATE:       5.2018
UPDATE:     Added Denominator to report (6 new columns)
NOTE:       GENERATES EXCEL SPREADSHEET. 
            NEED TO MANUALLY FORMAT XLS (ARIAL 10,BORDERS,COLUMN WIDTH FOR MCOS 9.0,
            TITLE: SCO REPORT CARD DOS MON YYYY THRU MON YYYY,HIGHLIGHT FAILS IN YELLOW)
*****************************************************************************************;
options compress=binary;
options ps=50 ls=80 nodate;

libname nw1 oracle path=dwp1rac schema=tibbettsn dbprompt=yes defer=no user=tibbettsn;

proc sql;
connect to oracle (path=dwp1rac dbprompt=NO defer=NO user=tibbettsn password=tibbs002);

*TO BE UPDATED;
%LET QTR = Q4;
%LET STRTDT = OCT 2017;
%LET ENDDT  = DEC 2017;

proc sort data=nw1.sco_percents_&QTR. out=sco_percents_&QTR.;
by cde_enc_mco;
run;

proc transpose data=sco_percents_&QTR. out=sco_percents_&QTR._t name = Measure;
id cde_enc_mco;
run;

data report(drop=_LABEL_);
format Measure $char32. BHP CCA NAV SWH TFT UHC percent12.2;
set sco_percents_&QTR._t;
where measure not in('TOT_NONART' 'TOT_INPAT' 'TOT_PHARM' 'TOT_OUTPT' 'TOT_OUTPTQ2' 
'TOT_DENT' 'TOT_DENTQ2' 'TOT_MED' 'TOT_MEDQ2' 'TOT_NON_PHRM_DENTQ2' 'TOT_PHARM_SCRIPT'
'TOT_INPT_LTC' 'TOT_INPT_OUTPT_LTC' 'TOT_INP_OP_LTC_M_EXCQ2' 'TOT_NON_PHRM_DENT' 
'TOT_INPAT_FILTER1' 'TOT_INPAT_FILTER2' 'TOT_INPTQ2' 'TOT_MOD_DME' 'TOT_MOD_LABXRAY'
'TOT_MOD_SURGERYM' 'TOT_RECORDS');
run;

proc transpose data=nw1.sco_tot_rex_q4 out=sco_tot_rex_q4_t(rename=(_name_=claim_count)) ;
id cde_enc_mco;
run;

proc print data=report;run;
proc print data=sco_tot_rex_q4_t;run;

proc sql;
create table report1 as
select 
case when measure='PCT_CLAIMCAT' then '2 Claim Category'
     when measure='PCT_RECIND' then '4 Record Indicator'
     when measure='PCT_DOS_FROM' then '17 From Service Date'
	 when measure='PCT_DOS_THRU' then '18 To Service Date'
     when measure='PCT_PRIMARY_DIAG' then '19 Primary Diagnosis'
	 when measure='PCT_PROC_CODE_O' then '26 Procedure Code Outpt'
     when measure='PCT_PROC_CODE_M' then '26 Procedure Code Prof_M'
	 /*when measure='PCT_PROC_CODE_I' then '26 Procedure Code Inpt'*/ /*removed from reporting*/
	 when measure='PCT_PROC_MOD_DME' then '27 Procedure Modifier DME'     
	 when measure='PCT_PROC_MOD_LABXRAY' then '27 Procedure Modifier LabXray'
	 when measure='PCT_PROC_MOD_SURGERYM' then '27 Procedure Modifier Surgery Prof_M'
	 when measure='PCT_QTY_UNIT_BILL' then '36 Quantity'
	 when measure='PCT_AMTPAY' then '68 Net Payment'
	 when measure='PCT_ID_MEDICAID' then '76 New Member ID'
	 when measure='PCT_MEDICARE_CODE' then '11 Medicare Code'
	 when measure='PCT_REV_CODE' then '31 Revenue Code'
	 when measure='PCT_POS_CODE' then '32 Place of Service'
	 when measure='PCT_POS_TYPE' then '33 Place of Service Type'
	 when measure='PCT_AMTBILL' then '60 Billed Charge'
	 when measure='PCT_AMT_GROSSPAY' then '61 Gross Payment Amount'
	 when measure='PCT_AMT_PAYMCARE' then '63 Medicare Amount'
	 when measure='PCT_SVC_CAT' then '80 Service Category'
	 when measure='PCT_AMTALLOW' then '86 Allowable Amount'
	 when measure='PCT_ICD_VERSION' then '193 ICD Version Qualifier'
     when measure='PCT_ADMITDT' then '15 Admission Date'
     when measure='PCT_DISCHARGEDT' then '16 Discharge Date'
	 when measure='PCT_ADMIT_TYPE' then '24	Type of Admission'
	 when measure='PCT_NDC' then '37 NDC Number' 
	 when measure='PCT_SERV_PROV_ID' then '50 Servicing Provider ID'
	 when measure='PCT_SERV_PROV_ID_TYP' then '51 Servicing Provider ID Type'
     when measure='PCT_SERV_PROV_TYP' then '55 Servicing Provider Type'
     when measure='PCT_SERV_PROV_SPEC' then '56 Servicing Provider Specialty'
	 when measure='PCT_BILL_PROV_ID' then '58 Billing Provider ID'
	 when measure='PCT_BILL_PROV_ID_TYP' then '93 Billing Provider ID Type'
	 when measure='PCT_BILL_PROV_SPEC' then ' Billing Provider Specialty'
	 when measure='PCT_PATIENT_STATUS' then '34 Patient Discharge Status'
	 when measure='PCT_DIAG_ADMIT' then '85 Admitting Diagnosis'
	 when measure='PCT_PAT_PAYAMT' then '124 Patient Pay Amount'
	 when measure='PCT_ADMIT_SOURCE' then '25 Source of Admission'
	 when measure='PCT_PRESCRIBE_PROV_ID' then '81 Prescribing Prov. ID'
	 when measure='PCT_PRES_PROV_ID_TYP' then '94 Prescribing Prov. ID Type'
	 when measure='PCT_REFILL' then '40 Refill Indicator'
	 when measure='PCT_DISPENSE' then '41 Dispense as Written Indicator'
	 when measure='PCT_FEE' then '67 Dispensing Fee'
	 when measure='PCT_SCRIPT_WRITTEN' then '82 Date Script Written'
	 when measure='PCT_SCRIPT' then '198 Prescription Number'
end as measure,
case when measure ='PCT_ID_MEDICAID' or measure ='PCT_DOS_FROM' or measure ='PCT_DOS_THRU' or 
          measure ='PCT_SERV_PROV_ID' or measure ='PCT_SERV_PROV_ID_TYP' or measure ='PCT_SERV_PROV_TYP' or
          measure ='PCT_SERV_PROV_SPEC' or measure ='PCT_BILL_PROV_ID' or measure ='PCT_BILL_PROV_ID_TYP' or  
          measure ='PCT_BILL_PROV_SPEC' or measure='PCT_QTY_UNIT_BILL' or measure='PCT_MEDICARE_CODE' or
          measure='PCT_AMT_GROSSPAY' or measure='PCT_AMT_PAYMCARE' or measure='PCT_SVC_CAT' or
          measure='PCT_PAT_PAYAMT' or measure='PCT_CLAIMCAT' or measure='PCT_RECIND' or measure='PCT_AMTBILL' or 
		  measure='PCT_AMTPAY' or measure='PCT_AMTALLOW'
     then 'All Claim Types' 
     when measure='PCT_PRESCRIBE_PROV_ID' or measure='PCT_PRES_PROV_ID_TYP' or measure='PCT_SCRIPT_WRITTEN' or
          measure='PCT_REFILL' or measure='PCT_DISPENSE' or measure='PCT_SCRIPT' or measure='PCT_FEE' 
     then 'Pharmacy (prescriptions only, not OTC)'
	 when measure='PCT_NDC' then 'Pharmacy (prescriptions only, not OTC and not compounded)'
	 when measure='PCT_PRIMARY_DIAG' or measure='PCT_ICD_VERSION' then 'Inpatient, Outpatient, Professional, and LTC'
	 when measure='PCT_PROC_CODE_O' then 'Outpatient' 
	 when measure='PCT_PROC_CODE_M' or measure='PCT_PROC_MOD_LABXRAY' or measure='PCT_PROC_MOD_SURGERYM' then 'Professional'
	 when measure='PCT_PROC_MOD_DME' then 'Professional (modifier=RR,NU,UE)'
	 when measure='PCT_ADMITDT' or measure='PCT_ADMIT_TYPE' or measure='PCT_ADMIT_SOURCE' then 'Inpatient and LTC'
	 when measure='PCT_DISCHARGEDT' or measure='PCT_DIAG_ADMIT' then 'Inpatient'
	 when measure='PCT_PATIENT_STATUS' then 'Inpatient and Outpatient'
	 when measure='PCT_REV_CODE' then 'Inpatient, Outpatient, and LTC'
	 when measure='PCT_POS_CODE' or measure='PCT_POS_TYPE' then 'Inpatient, Outpatient, Professional, and LTC'
end as claimtype,
case when measure in('PCT_ID_MEDICAID','PCT_DOS_FROM','PCT_DOS_THRU','PCT_SERV_PROV_ID','PCT_SERV_PROV_ID_TYP',
                      'PCT_SERV_PROV_TYP','PCT_BILL_PROV_ID','PCT_BILL_PROV_ID_TYP','PCT_PRESCRIBE_PROV_ID',
					  'PCT_PRES_PROV_ID_TYP','PCT_PRIMARY_DIAG','PCT_ICD_VERSION','PCT_QTY_UNIT_BILL', 
                      'PCT_MEDICARE_CODE','PCT_AMT_GROSSPAY','PCT_AMT_PAYMCARE','PCT_SVC_CAT','PCT_PAT_PAYAMT',
					  'PCT_SCRIPT_WRITTEN','PCT_REFILL','PCT_SCRIPT','PCT_FEE','PCT_NDC',
                      'PCT_CLAIMCAT','PCT_RECIND','PCT_AMTBILL','PCT_AMTPAY','PCT_AMTALLOW','PCT_ADMITDT','PCT_DISCHARGEDT',
                      'PCT_DIAG_ADMIT','PCT_PATIENT_STATUS','PCT_ADMIT_TYPE','PCT_ADMIT_SOURCE','PCT_REV_CODE',
                      'PCT_POS_CODE','PCT_POS_TYPE')  
     then '98.0%'
	 when measure in('PCT_DISPENSE','PCT_PROC_CODE_O','PCT_PROC_CODE_M','PCT_PROC_MOD_DME','PCT_PROC_MOD_LABXRAY') then '95.0%'
	 when measure in('PCT_PROC_MOD_SURGERYM') then '25.0%'
	 when measure in('PCT_SERV_PROV_SPEC','PCT_BILL_PROV_SPEC') then '50.0%'
end as benchmark,
case when measure ='PCT_ID_MEDICAID' or measure ='PCT_DOS_FROM' or measure ='PCT_DOS_THRU' or 
          measure ='PCT_SERV_PROV_ID' or measure ='PCT_SERV_PROV_ID_TYP' or measure ='PCT_SERV_PROV_TYP' or
          measure ='PCT_SERV_PROV_SPEC' or measure ='PCT_BILL_PROV_ID' or measure ='PCT_BILL_PROV_ID_TYP' or  
          measure='PCT_QTY_UNIT_BILL' or measure='PCT_MEDICARE_CODE' or measure='PCT_GROSSPAY' or 
          measure='PCT_AMT_PAYMCARE' or measure='PCT_SVC_CAT' or measure='PCT_PAT_PAYAMT' or measure='PCT_CLAIMCAT' or
          measure='PCT_RECIND' or measure='PCT_AMTBILL' or measure='PCT_AMTPAY' or measure='PCT_AMTALLOW' 
		  then 'TOT_REX'
when measure='PCT_PRESCRIBE_PROV_ID' or measure='PCT_PRES_PROV_ID_TYP' or measure='PCT_SCRIPT_WRITTEN' or
     measure='PCT_REFILL' or measure='PCT_DISPENSE' or measure='PCT_SCRIPT' or measure='PCT_FEE' then 'TOT_PHARM_SCRIPT'
when measure='PCT_NDC' then 'TOT_PHARMSCRIPT_NOTCOMP'
when measure='PCT_PRIMARY_DIAG' then 'TOT_NON_PHRM_DENTQ2'
when measure='PCT_ADMITDT' or measure='PCT_ADMIT_TYPE' or measure='PCT_ADMIT_SOURCE' then 'TOT_INPT_LTC'
when measure='PCT_PRIMARY_DIAG' then 'TOT_NON_PHRM_DENTQ2'
when measure='PCT_ICD_VERSION' then 'TOT_INP_OP_LTC_M_EXCQ2'
when measure='PCT_PROC_CODE_M' then 'TOT_MEDQ2'
when measure='PCT_PROC_CODE_O' then 'TOT_OUTPTQ2'
when measure='PCT_PROC_CODE_I' then 'TOT_INPTQ2'
when measure='PCT_PROC_MOD_DME' then 'TOT_MOD_DME'
when measure='PCT_PROC_MOD_LABXRAY' then 'TOT_MOD_LABXRAY'
when measure='PCT_PROC_MOD_SURGERYM' then 'TOT_MOD_SURGERYM'
when measure='PCT_POS_CODE' or measure='PCT_POS_TYPE' then 'TOT_NON_PHRM_DENT'
when measure='PCT_REV_CODE' then 'TOT_INOUTLTC_NOART'
when measure='PCT_PATIENT_STATUS' then 'TOT_INPT_OUTPT'
when measure='PCT_DIAG_ADMIT' then 'TOT_INPAT_FILTER2'
when measure='PCT_DISCHARGEDT' then 'TOT_INPAT_FILTER1'
end as claim_count,
BHP, CCA, NAV, SWH, TFT, UHC
from report
;
run;

proc print data=report;run;
proc sql;
create table nw1.scoreport_q4&sysdate as 
select rp1.measure,rp1.claimtype,rp1.benchmark,rp1.bhp,rp2.bhp as bhp_denom, rp1.cca,rp2.cca as cca_denom,
rp1.nav,rp2.nav as nav_denom, rp1.swh,rp2. swh as swh_denom,
rp1.tft,rp2.tft as tft_denom, rp1.uhc,rp2.uhc as uhc_denom
from report1 rp1 
inner join sco_tot_rex_q4_t rp2 
on rp1.claim_count=rp2.claim_count;
run;
proc print;run;


proc export data=nw1.scoreport_q4&sysdate
            (KEEP =Measure claimtype benchmark BHP bhp_denom CCA cca_denom NAV nav_denom SWH swh_denom TFT tft_denom UHC uhc_denom)
outfile="W:\APPLICATION ANALYSIS\PILOT SCO ENCOUNTERS REPORT CARD\&QTR.\OCT2017_DEC2017\MONTHLY DETAILS\SCO_REPORT_CARD_&QTR..XLS"
		      replace;			
sheet="&SYSDATE";
run;
