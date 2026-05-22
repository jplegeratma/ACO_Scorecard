****************************************************************************************
PROGRAM:    STEP3 GENERATE REPORT.SAS
RE:         OUTPUTS EXCEL SPREADSHEET  MCO/MBH MEASURES 
            USER: UPDATE %LET MACRO VARIABLES
                  MAKE SURE 'REPORTS' SUBFOLDER HAS BEEN CREATED FOR OUTPUT
LOCATION:   \\ehs-clu-bos-001\W\APPLICATION ANALYSIS\MCO AND MBHP EVALUATION SCORECARD
PROGRAMMER: NT
DATE:       9.2020
UPDATE:     7.16.2018 NT: Update report: Add additional column 'ACO'. Data will be
            populated post 3.2018
NOTE:       GENERATES EXCEL SPREADSHEET. 
            NEED TO MANUALLY FORMAT XLS (CALIBRI 11, $1:$1 ROWS TO REPEAT)
            TITLE:  MCO/MBHP ENCOUNTER DATA SCORECARD: 
                    DOS MON YYYY THRU MON YYYY,HIGHLIGHT FAILS IN YELLOW)
TO DO:      Before running this code USER needs to: 
            (1)update STRTDT, ENDDT, TF macro variable values and
            (2)update query month 'value' and 
            (3)create the subfolder: 'REPORTS' off of 'TF' (jun2018_sep2018 folder)
               so the excel spreadsheet can be output there
*****************************************************************************************;
options compress=binary;
options ps=50 ls=80 nodate;
*options dkricond=nowarning dkrocond=nowarning ; /*to surpress warnings*/

libname nw1 oracle path=dwp1rac schema=tibbettsn dbprompt=yes defer=no user=tibbettsn;

proc sql;
connect to oracle (path=dwp1rac dbprompt=NO defer=NO user=tibbettsn password='Rdb#87smR');

*TO BE UPDATED;
%LET STRTDT = JUN 2020;
%LET ENDDT  = SEP 2020;
%LET TF = JUN2020_SEP2020;

proc sort data=nw1.mco_mbh_ptpdos_&TF. out=mco_mbh_ptpdos_&TF.;
by cde_enc_mco dos_yrmonth aco;
run;

proc transpose data=mco_mbh_ptpdos_&TF. /*(where=(cde_enc_mco='BMC'))*/
               out=mco_mbh_ptpdos_&TF._t (drop=TOT_INPAT TOT_PHARM TOT_OUTPT TOT_OUTPTQ2 TOT_DENT TOT_DENTQ2 TOT_MED
                      TOT_MEDQ2 TOT_NON_PHRM_DENTQ2 TOT_PHARM_SCRIPT TOT_INPT_LTC TOT_INPT_OUTPT_LTC
                      TOT_INP_OP_LTC_M_EXCQ2 TOT_NON_PHRM_DENT TOT_INPAT_FILTER1 TOT_INPAT_FILTER2
                      TOT_MOD_DME TOT_MOD_LABXRAY TOT_MOD_SURGERYM TOT_INOUTLTC_NOART TOT_INPT_OUTPT
                      TOT_PHARMSCRIPT_NOTCOMP TOT_NONPHARM TOT_RECORDS _label_ rename=(_name_=measure col1=actual));
var pct_id_medicaid -- pct_numlogclm;
by cde_enc_mco dos_yrmonth aco;
run;

proc sql;
create table report_step1 as
select
'2021-02' as query_month, /*UPDATE*/
dos_yrmonth as month_service,
measure,
case when measure ='PCT_ID_MEDICAID' or measure ='PCT_DOS_FROM' or measure ='PCT_DOS_THRU' or 
          measure ='PCT_SERV_PROV_ID' or measure ='PCT_SERV_PROV_ID_TYP' or measure ='PCT_SERV_PROV_TYP' or
          measure ='PCT_SERV_PROV_SPEC' or measure ='PCT_BILL_PROV_ID' or measure ='PCT_BILL_PROV_ID_TYP' or  
          measure='PCT_SVC_CAT' or measure='PCT_CLAIMCAT' or 
          measure='PCT_RECIND' or measure='PCT_AMTBILL' or measure='PCT_AMTALLOW' or measure='PCT_AMTPAY' or
		  measure='PCT_PAID_DT' or measure='PCT_SERV_ID_LOC' or measure='PCT_BILL_ID_LOC' or measure='PCT_TPL' or
		  measure='PCT_COPAY' or measure='PCT_COINS' or measure='PCT_CLMDISP' or measure='PCT_CLMNUM' or
		  measure='PCT_CLMSUF' or measure='PCT_NUMLOGCLM' or measure='PCT_ACO'
     then 'All Claim Types' 

	 when measure='PCT_QTY_UNIT_BILL' then 'Non Pharmacy'

     when measure='PCT_PRESCRIBE_PROV_ID' or measure='PCT_PRES_PROV_ID_TYP' or measure='PCT_SCRIPT_WRITTEN' or
          measure='PCT_REFILL' or measure='PCT_DISPENSE' or measure='PCT_SCRIPT' or measure='PCT_FEE' or 
          measure='PCT_PRS_ID_LOC'
     then 'Pharmacy (prescriptions only, not OTC)'

	 when measure='PCT_NDC' then 'Pharmacy (prescriptions only, not OTC and not compounded)'

	 when measure='PCT_PRIMARY_DIAG' or measure='PCT_ICD_VERSION' or measure='PCT_POS_CODE' or 
          measure='PCT_POS_TYPE' or measure='PCT_SERV_NPI' or measure='PCT_BILL_NPI' 
     then 'Inpatient, Outpatient, Professional, and LTC'

	 when measure='PCT_PROC_CODE_O_D' then 'Outpatient' 

	 when measure='PCT_PROC_CODE_M' or measure='PCT_PROC_MOD_LABXRAY' or measure='PCT_PROC_MOD_SURGERYM' 
     then 'Professional'

     when measure='PCT_PROC_MOD_DME' then 'Professional (modifier=RR,NU,UE)'

	 when measure='PCT_ADMITDT' or measure='PCT_ADMIT_TYPE' or measure='PCT_ADMIT_SOURCE' then 'Inpatient and LTC'

	 when measure='PCT_DISCHARGEDT' or measure='PCT_DIAG_ADMIT' then 'Inpatient'

	 when measure='PCT_PATIENT_STATUS' then 'Inpatient and Outpatient'

	 when measure='PCT_REV_CODE' then 'Inpatient, Outpatient, and LTC'
end as claimtype,

cde_enc_mco as plan,
aco,
ROUND((actual)*100,.01) as actual /*converting rate to a percent and rounding 2 decimal places*/
from mco_mbh_ptpdos_&TF._t;
run;

*proc print data = report_step1;
*run;

proc sql;
create table report_step2 as
select query_month, month_service, measure, claimtype, plan, aco, claim_count, actual
from
(
select rpt1.*,
case when measure ='PCT_ID_MEDICAID' or measure ='PCT_DOS_FROM' or measure ='PCT_DOS_THRU' or 
          measure ='PCT_SERV_PROV_ID' or measure ='PCT_SERV_PROV_ID_TYP' or measure ='PCT_SERV_PROV_TYP' or
          measure ='PCT_SERV_PROV_SPEC' or measure ='PCT_BILL_PROV_ID' or measure ='PCT_BILL_PROV_ID_TYP' or  
          measure='PCT_SVC_CAT' or measure='PCT_CLAIMCAT' or 
          measure='PCT_RECIND' or measure='PCT_AMTBILL' or measure='PCT_AMTALLOW' or measure='PCT_AMTPAY' or
		  measure='PCT_PAID_DT' or measure='PCT_SERV_ID_LOC' or measure='PCT_BILL_ID_LOC' or measure='PCT_TPL' or
		  measure='PCT_COPAY' or measure='PCT_COINS' or measure='PCT_CLMDISP' or measure='PCT_CLMNUM' or
		  measure='PCT_CLMSUF' or measure='PCT_NUMLOGCLM' or measure='PCT_ACO'
		  then TOT_RECORDS
when measure='PCT_PRESCRIBE_PROV_ID' or measure='PCT_PRES_PROV_ID_TYP' or measure='PCT_SCRIPT_WRITTEN' or
     measure='PCT_REFILL' or measure='PCT_DISPENSE' or measure='PCT_SCRIPT' or measure='PCT_FEE' or
     measure='PCT_PRS_ID_LOC' then TOT_PHARM_SCRIPT
when measure='PCT_NDC' then TOT_PHARMSCRIPT_NOTCOMP
when measure='PCT_QTY_UNIT_BILL' then TOT_NONPHARM 
when measure='PCT_PRIMARY_DIAG' or measure='PCT_SERV_NPI' or measure='PCT_BILL_NPI' then TOT_NON_PHRM_DENTQ2 
when measure='PCT_ADMITDT' or measure='PCT_ADMIT_TYPE' or measure='PCT_ADMIT_SOURCE' then TOT_INPT_LTC
when measure='PCT_PRIMARY_DIAG' then TOT_NON_PHRM_DENTQ2
when measure='PCT_ICD_VERSION' then TOT_INP_OP_LTC_M_EXCQ2
when measure='PCT_PROC_CODE_M' then TOT_MEDQ2
when measure='PCT_PROC_CODE_O_D' then TOT_OUTPTQ2
when measure='PCT_PROC_MOD_DME' then TOT_MOD_DME
when measure='PCT_PROC_MOD_LABXRAY' then TOT_MOD_LABXRAY
when measure='PCT_PROC_MOD_SURGERYM' then TOT_MOD_SURGERYM
when measure='PCT_POS_CODE' or measure='PCT_POS_TYPE' then TOT_NON_PHRM_DENT
when measure='PCT_REV_CODE' then TOT_INOUTLTC_NOART
when measure='PCT_PATIENT_STATUS' then TOT_INPT_OUTPT
when measure='PCT_DIAG_ADMIT' then TOT_INPAT_FILTER2
when measure='PCT_DISCHARGEDT' then TOT_INPAT_FILTER1
end as claim_count
from report_step1 rpt1
inner join (select cde_enc_mco, dos_yrmonth, aco, TOT_INPAT, TOT_PHARM, TOT_OUTPT, TOT_OUTPTQ2, TOT_DENT, TOT_DENTQ2, 
                   TOT_MED, TOT_MEDQ2, TOT_NON_PHRM_DENTQ2, TOT_PHARM_SCRIPT, TOT_INPT_LTC, 
                   TOT_INPT_OUTPT_LTC, TOT_INP_OP_LTC_M_EXCQ2, TOT_NON_PHRM_DENT, 
                   TOT_INPAT_FILTER1, TOT_INPAT_FILTER2, TOT_MOD_DME, TOT_MOD_LABXRAY, 
                   TOT_MOD_SURGERYM, TOT_INOUTLTC_NOART, TOT_INPT_OUTPT, TOT_PHARMSCRIPT_NOTCOMP,TOT_NONPHARM,
                   TOT_RECORDS
            from mco_mbh_ptpdos_&TF.
            /*where cde_enc_mco='BMC'*/)rpt2
on rpt1.plan=rpt2.cde_enc_mco and rpt1.month_service=rpt2.dos_yrmonth and rpt1.aco=rpt2.aco);
run;

proc sort data=report_step2 out=mco_mbh_report_&tf.;
by query_month plan month_service aco measure;
run;

proc print data=mco_mbh_report_&tf.;
var query_month month_service measure claimtype plan aco claim_count actual;
run;

proc export data=mco_mbh_report_&tf.
            (KEEP =query_month month_service measure claimtype plan aco claim_count actual where=(measure <> 'PCT_PROC_CODE'))
outfile="Z:\APPLICATION ANALYSIS\MCO and MBHP Evaluation Scorecard\&TF.\REPORTS\MCO_MBH_SCORECARD_&TF..XLS"
		      replace;			
sheet="&SYSDATE";
run;


proc sql;
create table nw1.mco_mbh_report_&tf. as
select query_month, month_service, measure, claimtype, plan, aco, claim_count, actual
from mco_mbh_report_&tf.;
run;
