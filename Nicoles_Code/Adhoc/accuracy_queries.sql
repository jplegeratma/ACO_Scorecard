/* PROGRAM:    ACCURACY_QUERIES.SQL
   PROGRAMMER: NT
   RE:         Specifications: Part B Queries to inform Accuracy - Request
   DATE:       5.2018
   LOCATION:   APPLICATION ANALYSIS\MCO AND MBHP EVALUATION SCORECARD\ADHOC
*/


/*Billing/Servicing Provider*/
select cde_enc_mco,
       case when tot_bill_serv_blank=0 then 0 
       else trunc((tot_bill_serv_blank/tot_bill_serv_equal),4) end as bill_serv_rate1,
       case when tot_bill_serv_eq_notblk=0 then 0
       else trunc((tot_bill_serv_eq_notblk/tot_bill_serv_equal),4) end as bill_serv_rate2,
       case when tot_bill_serv_noteq_notblk=0 then 0
       else trunc((tot_bill_serv_noteq_notblk/tot_bill_serv_notblk),4) end as bill_serv_rate3
from(      
select cde_enc_mco,sum(bill_serv_equal) as tot_bill_serv_equal,sum(bill_serv_blank) as tot_bill_serv_blank,
        sum(bill_serv_eq_notblk) as tot_bill_serv_eq_notblk, sum(bill_serv_noteq_notblk) as tot_bill_serv_noteq_notblk,
        sum(bill_serv_notblk) as tot_bill_serv_notblk
from(
select cde_enc_mco,
case when enc_serv_prov_id=enc_bill_prov_id then 1 else 0 end as bill_serv_equal,
case when enc_serv_prov_id in('+','-',' ') and enc_bill_prov_id in('+','-',' ') then 1 else 0 end as bill_serv_blank,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') and 
          enc_serv_prov_id=enc_bill_prov_id then 1 else 0 end as bill_serv_eq_notblk,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') and 
          enc_serv_prov_id<>enc_bill_prov_id then 1 else 0 end as bill_serv_noteq_notblk,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') then 1 else 0 end as bill_serv_notblk
from MCO_MBHP_DOS_FEB2017_JAN2018)
group by cde_enc_mco)

/*Servicing Provider Specialty*/
select cde_enc_mco, serv_prov_specialty,dsc_enc_prov_spec,count(*) 
from
(select ds1.cde_enc_mco, ds1.serv_prov_specialty,ncf.dsc_enc_prov_spec
from MCO_MBHP_DOS_FEB2017_JAN2018 ds1
inner join (select distinct cde_enc_mco,cde_enc_prov_spec,dsc_enc_prov_spec from NW_ENC_NONCONF_ATTRIBUTE) ncf on serv_prov_specialty=cde_enc_prov_spec and ds1.cde_enc_mco=ncf.cde_enc_mco)
group by cde_enc_mco,serv_prov_specialty,dsc_enc_prov_spec
order by cde_enc_mco,serv_prov_specialty,dsc_enc_prov_spec

/*ED Revenue Code*/
--per specs but seems like not the best approach?
select distinct proc_code_desc ,proc_code,substr(proc_code_desc,9,2)
from MCO_MBHP_DOS_FEB2017_JAN2018 --where proc_code in('99283')
where substr(proc_code_desc,9,2) in('ED') or substr(proc_code_desc,9,3) in('ENM')


select cde_enc_mco,proc_code,cde_revenue,dsc_revenue,count(*) --n=140 rows
from MCO_MBHP_DOS_FEB2017_JAN2018 
where proc_code in('99283', '99284', '99285', '99281', '99282') --is this a comprehensive listing?
group by cde_enc_mco,proc_code,cde_revenue,dsc_revenue

select cde_enc_mco,proc_code_enc,cde_revenue,dsc_revenue,count(*) --n=140 rows
from MCO_MBHP_DOS_FEB2017_JAN2018 
where proc_code_enc in('99283', '99284', '99285', '99281', '99282') --is this a comprehensive listing?
group by cde_enc_mco,proc_code_enc,cde_revenue,dsc_revenue
--proc_code_enc;proc_code_enc_desc
--proc_code;proc_code_desc


---test code
/*QA Billing/Servicing Provider*/
select cde_enc_mco,bill_serv_equal,bill_serv_blank,bill_serv_eq_notblk,bill_serv_noteq_notblk,bill_serv_notblk,count(*)
from(
select cde_enc_mco,
case when enc_serv_prov_id=enc_bill_prov_id then 1 else 0 end as bill_serv_equal,
case when enc_serv_prov_id in('+','-',' ') and enc_bill_prov_id in('+','-',' ') then 1 else 0 end as bill_serv_blank,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') and 
          enc_serv_prov_id=enc_bill_prov_id then 1 else 0 end as bill_serv_eq_notblk,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') and 
          enc_serv_prov_id<>enc_bill_prov_id then 1 else 0 end as bill_serv_noteq_notblk,
case when enc_serv_prov_id not in('+','-',' ') and enc_bill_prov_id not in('+','-',' ') then 1 else 0 end as bill_serv_notblk

from MCO_MBHP_DOS_FEB2017_JAN2018
where cde_enc_mco='BMC')
group by cde_enc_mco,bill_serv_equal,bill_serv_blank,bill_serv_eq_notblk,bill_serv_noteq_notblk,bill_serv_notblk