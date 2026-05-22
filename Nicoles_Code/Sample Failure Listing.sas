options compress=binary;
options ps=50 ls=80 nodate;

libname nw1 oracle path=dwp1rac schema=tibbettsn dbprompt=yes defer=no user=tibbettsn;

/*********************************************************************************************
 PROGRAM:    SAMPLE FAILURE LISTING.SQL
 RE:         This program generates sample failure listings for those measures not 
             meeting the benchmark for the MCO Disincentive Project. 
             An excel spreadsheet is created for MCO, with each measure as a worksheet. 
 DATE        10.2018
 NOTE:       Review the Report Card and only call macros for those fields not meeting the 
             benchmark (Whitney typically sends an email requesting the specific fields
             and notes MCO/ACO)
 NOTE:       This listing is based on DOS MAR-JUN 2018 (SAMPLE LIST FOR JUNE ONLY)
             User to edit/replace nw1 tables in the macros
             REFERENCE JIRA TICKET 19977 AND 20034.  
 NOTE:       A new spreadsheet will be created for each MCO/ACO combination (each measure
             will contain a sample failure listing of up to 25 claims per worksheet)
             
 *********************************************************************************************/
**TO BE UPDATED**; 
%LET MOYRST = MAR2018; *update! DATA PULL TABLE NAME WITH STARTING MONTH/YEAR;
%LET MOYREND = APR2018; *update! DATA PULL TABLE NAME WITH ENDING MONTH/YEAR; 
%LET JT = DWHS-20136 BMC encounter duplicate claims review of logic versus cognos logic; *update! full jira ticket folder name for excel output;

proc sql;
connect to oracle (path=dwp1rac dbprompt=NO defer=NO user=tibbettsn password=tibbs006);

options mprint mlogic;

%MACRO MCO_FAIL1(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,id_medicaid
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and substr(ID_MEDICAID,1,1) <> '1' 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL1;

%MACRO MCO_FAIL2(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and dos_from is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL2;

%MACRO MCO_FAIL3(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_thru
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and dos_thru is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL3;

%MACRO MCO_FAIL4(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,enc_serv_prov_id
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and ENC_SERV_PROV_ID IN (' ','-','+','#')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL4;

%MACRO MCO_FAIL5(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,serv_prov_id_type
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and substr(SERV_PROV_ID_TYPE,1,1)  NOT IN ('1','6','9')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL5;

%MACRO MCO_FAIL6(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,enc_serv_prov_type
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and ENC_SERV_PROV_TYPE IN (' ','-','+','#')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL6;

%MACRO MCO_FAIL7(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,serv_prov_specialty
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and SERV_PROV_SPECIALTY IN (' ','-','+','#') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL7;

%MACRO MCO_FAIL8(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,bill_prov_id
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and bill_prov_id IN (' ','-','+','#')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL8;

%MACRO MCO_FAIL9(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,bill_prov_id_type
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and substr(BILL_PROV_ID_TYPE,1,1) NOT IN ('1','6','9')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL9;

%MACRO MCO_FAIL10(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,
dos_from,claim_type,cde_drug_class,ENC_PRES_PROV_ID 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS='F' AND ENC_PRES_PROV_ID IN ('+','-',' ')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL10;

%MACRO MCO_FAIL11(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_drug_class,PRES_PROV_ID_TYPE 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE='P' AND CDE_DRUG_CLASS='F' AND substr(PRES_PROV_ID_TYPE,1,1) not in ('1','6','8')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL11;

%MACRO MCO_FAIL12(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,primary_diag 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND primary_diag in ('+','-', ' ')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL12;

%MACRO MCO_FAIL13(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,cde_icd_version
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE IN('I','M','O','L') AND cde_icd_version not in(9,10)
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL13;

%MACRO MCO_FAIL14(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,
cde_enc_rec_ind,claim_type,proc_code
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND claim_type in('M') and (proc_code in(' ','-','+','#') or 
(cde_enc_proc_type ='7' and proc_code_enc not in(' ','-','+','#')))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL14;

%MACRO MCO_FAIL15(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,proc_code
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND ((claim_type in('O') and 
(proc_code in(' ','-','+','#') and ((cde_revenue not between 250 and 259) and (cde_revenue <> 260) and  (cde_revenue not between 262 and 279) and 
          (cde_revenue not between 370 and 372) and (cde_revenue <> 374) and (cde_revenue <> 379) and (cde_revenue <> 710) and
          (cde_revenue <> 839) and (cde_revenue <> 902) and (cde_revenue <> 946) and (cde_revenue <> 947) and (cde_revenue <> 961) and
          (cde_revenue <> 962) and (cde_revenue <> 963) and (cde_revenue <> 973) and (cde_revenue <> 974) and (cde_revenue <> 975) and
          (cde_revenue <> 981) and (cde_revenue <> 982) and (cde_revenue <> 983) and (cde_revenue <> 988))))  or
           (claim_type in ('O') and cde_enc_proc_type ='7' and proc_code_enc in(' ','-','+','#')))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL15;

%MACRO MCO_FAIL16(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,
proc_code,/*cde_enc_proc_type,proc_code_enc,*/proc_modifier1,proc_modifier2,proc_modifier3,proc_modifier4
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND claim_type in('M') and ((substr(proc_code,1,1) in('E','K') and proc_code not in('E0241','E0242','E0243','E0700')) or 
(cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('E','K') and proc_code_enc not in('E0241','E0242','E0243','E0700'))) and 
(proc_modifier1 not in('RR','NU','UE') and proc_modifier2 not in('RR','NU','UE') and proc_modifier3 not in('RR','NU','UE')
and proc_modifier4 not in('RR','NU','UE'))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL16;

%MACRO MCO_FAIL17(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,
proc_code,proc_modifier1,proc_modifier2,proc_modifier3,proc_modifier4
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND claim_type in('M') and (substr(proc_code,1,1) in('7')  or 
(cde_enc_proc_type ='7' and substr(proc_code_enc,1,1) in('7'))) and 
(proc_modifier1 in('+',' ','-') and proc_modifier2 in('+',' ','-') and proc_modifier3 in('+',' ','-') and proc_modifier4 in('+',' ','-'))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL17;

%MACRO MCO_FAIL18(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_rec_ind,claim_type,
proc_code,proc_modifier1,proc_modifier2,proc_modifier3,proc_modifier4
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and cde_enc_rec_ind <> '0' and claim_type in('M') and 
((proc_code between '10021' and '69990' and substr(proc_code,5,1) in('0','1','2','3','4','5','6','7','8','9') and 
proc_code_desc not in ('Unknown','N/A')) or (cde_enc_proc_type ='7' and proc_code_enc between '10021' and '69990' and substr(proc_code_enc,5,1) in('0','1','2','3','4','5','6','7','8','9') and
proc_code_enc_desc not in('Unknown','N/A'))) and 
(proc_modifier1 in('+',' ','-') and proc_modifier2 in('+',' ','-') and proc_modifier3 in('+',' ','-') and proc_modifier4 in('+',' ','-'))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL18;

%MACRO MCO_FAIL19(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,qty_units_billed
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type not in('P') and qty_units_billed is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL19;

%MACRO MCO_FAIL20(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,cde_enc_rec_ind,dos_from,claim_type,bill_npi
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE not in ('P','D') and BILL_NPI IN('MISSING','+','-',' ','0') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL20;

%MACRO MCO_FAIL21(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,cde_enc_rec_ind,dos_from,claim_type,serv_npi
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_REC_IND <> '0' AND CLAIM_TYPE not in ('P','D') and SERV_NPI IN('MISSING','+','-',' ','0') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL21;

%MACRO MCO_FAIL22(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_drug_class,date_script_written
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND DATE_SCRIPT_WRITTEN IS NULL 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL22;

%MACRO MCO_FAIL23(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_drug_class,qty_refill
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND (qty_refill is null or qty_refill < 0)
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL23;

%MACRO MCO_FAIL24(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_drug_class,dsc_enc_disp_as_wrtn
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND SUBSTR(DSC_ENC_DISP_AS_WRTN,1,1) NOT IN('0','1','2','3','4','5','6','7','8','9') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL24;

%MACRO MCO_FAIL25(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_drug_class,rx_number
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND RX_NUMBER IS NULL  
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL25;

%MACRO MCO_FAIL26(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,
cde_drug_class,amt_ndc_profee
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND AMT_NDC_PROFEE IS NULL
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL26;

%MACRO MCO_FAIL27(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,
claim_type,cde_drug_class,ind_enc_compound,cde_ndc
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type='P' AND CDE_DRUG_CLASS='F' AND IND_ENC_COMPOUND='2' AND CDE_NDC IN (' ','-','+','#') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL27;

%MACRO MCO_FAIL28(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_claim_cat,dsc_enc_claim_cat
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and SUBSTR(DSC_ENC_CLAIM_CAT,1,1) NOT IN ('1','2','3','4','5','6','7')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL28;

%MACRO MCO_FAIL29(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_enc_svc_cat
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CDE_ENC_SVC_CAT in(' ','-','+','#') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL29;

%MACRO MCO_FAIL30(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,dsc_enc_rec_ind
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and SUBSTR(DSC_ENC_REC_IND,1,1) NOT IN ('0','1','2','3','4','5','6','7') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL30;

%MACRO MCO_FAIL31(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,amt_billed
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and (AMT_BILLED < 0 or amt_billed is null)
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL31;

%MACRO MCO_FAIL32(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,AMT_PAID 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and (AMT_PAID  < 0 or AMT_PAID  is null)
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL32;

%MACRO MCO_FAIL33(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,AMT_ALLOWED 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and (AMT_ALLOWED  < 0 or AMT_ALLOWED  is null)
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL33;

%MACRO MCO_FAIL34(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,admit_dt
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type IN('I','L') and (admit_dt is null)  
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL34;

%MACRO MCO_FAIL35(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,
cde_type_of_bill_enc,dsc_patient_status,discharge_dt
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and (CLAIM_TYPE='I' AND substr(cde_type_of_bill_enc,1,2) <> '21' and SUBSTR(DSC_PATIENT_STATUS,1,2) NOT BETWEEN '30' AND '39') 
      AND DISCHARGE_DT IS NULL  
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL35;

%MACRO MCO_FAIL36(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,
cde_type_of_bill_enc,cde_diag_admit
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE='I' AND substr(cde_type_of_bill_enc,1,2) not in('12','22','42','62','81','82')  
AND CDE_DIAG_ADMIT  IN ('+','-', ' ')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL36;

%MACRO MCO_FAIL37(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_patient_status
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE IN('I','O') AND cde_patient_status in ('+', '-', ' ')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL37;

%MACRO MCO_FAIL38(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_admit_type
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND 
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE IN('I','L') AND cde_admit_type not in ('1','2','3','4','5','6','7','8','9') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL38;

%MACRO MCO_FAIL39(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_admit_source
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE IN('I','L') AND cde_admit_source not in ('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL39;

%MACRO MCO_FAIL40(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,cde_enc_rec_ind,
cde_revenue,dsc_revenue
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE IN('I','O','L') and cde_enc_rec_ind <> '0' AND substr(dsc_revenue,1,1) not in ('0','1','2','3','4','5','6','7','8','9')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL40;

%MACRO MCO_FAIL41(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,
cde_enc_claim_cat,cde_place_of_service_enc,cde_type_of_bill_enc
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE NOT IN('P','D') AND 
((cde_enc_claim_cat in('2','3','4','5') and 
        ( (substr(cde_place_of_service_enc,1,1) not in('0','1','2','3','4','5','6','7','8','9') and
       substr(cde_place_of_service_enc,2,1) not in('0','1','2','3','4','5','6','7','8','9'))
       or 
       (substr(cde_type_of_bill_enc,1,1) not in('0','1','2','3','4','5','6','7','8','9') and
       substr(cde_type_of_bill_enc,2,1) not in('0','1','2','3','4','5','6','7','8','9')))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL41;

%MACRO MCO_FAIL42(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,claim_type,
cde_enc_claim_cat,cde_place_of_service_enc,cde_type_of_bill_enc
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and claim_type not in('P','D') and                                                                                    
     ((cde_enc_claim_cat in('2','3','4','5') and 
       substr(cde_place_of_service_enc,1,1) not in('0','1','2','3','4','5','6','7','8','9') and
       substr(cde_place_of_service_enc,2,1) not in('0','1','2','3','4','5','6','7','8','9'))
       or 
       (cde_enc_claim_cat in('1','6') and 
       substr(cde_type_of_bill_enc,1,1) not in('0','1','2','3','4','5','6','7','8','9') and
       substr(cde_type_of_bill_enc,2,1) not in('0','1','2','3','4','5','6','7','8','9')))
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL42;

%MACRO MCO_FAIL43(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,paid_dt
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and PAID_DT IS NULL
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL43;

%MACRO MCO_FAIL44(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,
serv_prov_id,serv_prov_id_loc_code
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and serv_prov_id_loc_code in(' ','+','#','-') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL44;

%MACRO MCO_FAIL45(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,
bill_prov_id,bill_prov_id_loc_code
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and bill_prov_id_loc_code in(' ','+','#','-') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL45;

%MACRO MCO_FAIL46(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,
pres_prov_id,prs_prov_id_loc_code
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and CLAIM_TYPE = 'P' AND CDE_DRUG_CLASS = 'F' and prs_prov_id_loc_code in(' ','+','#','-') 
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL46;

%MACRO MCO_FAIL47(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and cde_enc_aco not in(' ','+','#','-')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL47;

%MACRO MCO_FAIL48(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,amt_tpl
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and amt_tpl is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL48;

%MACRO MCO_FAIL49(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,amt_copay 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and amt_copay is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL49;

%MACRO MCO_FAIL50(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,amt_coinsurance 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and amt_coinsurance is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL50;

%MACRO MCO_FAIL51(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,cde_clm_disposition 
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and cde_clm_disposition not in ('O','V','R','A')
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL51;

%MACRO MCO_FAIL52(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and enc_claim_no is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL52;

%MACRO MCO_FAIL53(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and enc_claim_suffix is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL53;

%MACRO MCO_FAIL54(MCO=,ACO=,YYYYMO=,YR=,MO=,DSN=,MEASURE=);
proc sql;
create table &DSN as
select distinct cde_enc_mco,cde_enc_aco,enc_claim_no,enc_claim_suffix,cde_clm_disposition,dos_from,num_logical_claim
from nw1.mco_mbhp_dos_&MOYRST._&MOYREND dtl
where cde_enc_mco="&MCO" and cde_enc_aco="&ACO" and put(datepart(dos_from),yymmd7.) = "&YYYYMO"
and num_logical_claim is null
order by cde_enc_mco,enc_claim_no,enc_claim_suffix;

proc export data=&DSN (obs=25)
outfile="P:\_JIRA\&JT\3_REPORT\FAIL_LIST_&MCO._&ACO._&YR&MO..XLS"
		      replace;			
sheet="&MEASURE";
run;
%MEND MCO_FAIL54;


/********************************************************************************
Only run for those not meeting benchmark (otherwise null worksheets are exported)
*********************************************************************************/
*user needs to edit each macro variable value: mco,aco,yyyymo,yr,mo;
**note: may need call macro for same measure but different mco/aco combination;

%mco_fail1(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m1,measure=76 Member ID);
%mco_fail2(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m2,measure=17 From Service Date);
%mco_fail3(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m3,measure=18 To Service Date);
%mco_fail4(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m4,measure=50 Servicing Provider ID);
%mco_fail5(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m5,measure=51 Servicing Provider ID Type);
%mco_fail6(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m6,measure=55 Servicing Provider Type);
%mco_fail7(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m7,measure=56 Servicing Provider Specialty);
%mco_fail8(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m8,measure=58 Billing Provider ID);
%mco_fail9(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m9,measure=93 Billing Provider ID Type;
%mco_fail10(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m10,measure=81 Prescribing Prov ID);
%mco_fail11(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m11,measure=94 Prescribing Prov ID Type);
%mco_fail12(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m12,measure=19 Primary Diagnosis);
%mco_fail13(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m13,measure=193 ICD Version Qualifier);
%mco_fail14(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m14,measure=26 Procedure Code Prof M);
%mco_fail15(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m15,measure=26 Procedure Code Outpt);
%mco_fail16(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m16,measure=27 Procedure Modifier DME);
%mco_fail17(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m17,measure=27 Procedure Modifier LabXray);
%mco_fail18(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m18,measure=27 Proc Modifier Surgery Prof_M);
%mco_fail19(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m19,measure=36 Qty Units Billed);
%mco_fail20(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m20,measure=Billing Provider NPI);
%mco_fail21(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m21,measure=Servicing Provider NPI);
%mco_fail22(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m22,measure=82 Date Script Written);
%mco_fail23(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m23,measure=40 Refill Indicator);
%mco_fail24(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m24,measure=41 Dispense as Written Indicat);
%mco_fail25(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m25,measure=198 Prescription Number);
%mco_fail26(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m26,measure=67 Dispensing Fee);
%mco_fail27(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m27,measure=37 NDC Number);
%mco_fail28(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m28,measure=2 Claim Category);
%mco_fail29(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m29,measure=80 Service Category);
%mco_fail30(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m30,measure=4 Record Indicator);
%mco_fail31(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m31,measure=60 Billed Charge);
%mco_fail32(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m32,measure=61 Gross Payment Amount);
%mco_fail33(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m33,measure=86 Allowable Amount);
%mco_fail34(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m34,measure=15 Admission Date);
%mco_fail35(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m35,measure=16 Discharge Date);
%mco_fail36(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m36,measure=85 Admitting Diagnosis);
%mco_fail37(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m37,measure=34 Patient Discharge Status);
%mco_fail38(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m38,measure=24 Type of Admission);
%mco_fail39(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m39,measure=25 Source of Admission);
%mco_fail40(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m40,measure=31 Revenue Code);
%mco_fail41(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m41,measure=32 Place of Service);
%mco_fail42(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m42,measure=33 Type of Bill);
%mco_fail43(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m43,measure=45 Paid Date);
%mco_fail44(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m44,measure=Servicing Provider ID Addr Loc);
%mco_fail45(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m45,measure=Billing Provider ID Addr Loc);
%mco_fail46(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m46,measure=Prescribing Prov ID Addr Loc);
%mco_fail47(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m47,measure=ACO);
%mco_fail48(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m48,measure=62 TPL Amount);
%mco_fail49(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m49,measure=64 Copay Amount);
%mco_fail50(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m50,measure=64 Coinsurance Amount);
%mco_fail51(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m51,measure=70 Record Type);
%mco_fail52(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m52,measure=5 Claim Number);
%mco_fail53(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m53,measure=6 Claim Suffix);
%mco_fail54(mco=BMC,aco=BMC-SIGN,yyyymo=2018-04,yr=2018,mo=APR,dsn=m54,measure=Mother-Child Claim ID);
