insert overwrite table wty.phone_5g_sale_bss
select user_no, msisdn, age, gender, net_type, month_fee, overdue_owe, 
term_svc, phone_company, phone_model, phone_used_months, phones_owned
from
(
select a.user_no, a.msisdn, a.age, a.gender, a.net_type, a.month_fee, a.overdue_owe, 
b2.term_svc, b2.phone_company, b2.phone_model, b2.phone_used_months, b2.phones_owned,
count(*) over(partition by a.msisdn) data_per_msisdn
from
(
select user_no, svc_number as msisdn, 
2021-cast(substring(cert_num,7,4) as int) as age, 
if(substring(cert_num,17,1) in('1','3','5','7','9'),1,2) as gender,
if(instr(dinner_name,'5G') > 0, '5G', '4G') net_type, 
cast(payment_fee as double)+cast(this_owe_fee as double) month_fee, 
cast(overdue_owe as double) overdue_owe
from qh_bo_db.cb_v_m_user_info
where month_id = '202103'
and length(svc_number) = 11
and length(cert_num) = 18 
and cast(substring(cert_num,7,4) as int) between 2021-100 and 2021-10
and length(dinner_name) > 0
and cast(payment_fee as double) >= 0
and cast(this_owe_fee as double) >= 0
and cast(overdue_owe as double) >= 0
) a
inner join
(
select user_no, term_svc, phone_company, phone_model, phone_used_months, phones_owned
from
( 
select user_no, term_svc, phone_company, phone_model, 
count(distinct(month_id)) phone_used_months, 
count(*) over(partition by user_no) phones_owned,
rank() over(partition by user_no order by max(month_id) desc) phone_rank
from 
(
select month_id, svc_type as user_no, union_term as term_svc, 
use_net as phone_company, companyname as phone_model
from qh_bo_db.history_phone
) b0
where cast(month_id as int) between 201803 and 202103
and term_svc in('4G终端','5G终端')
and length(phone_company) > 0
and length(phone_model) > 0
group by user_no, term_svc, phone_company, phone_model
) b1
where phone_rank = 1
) b2
on a.user_no = b2.user_no
) ab
where data_per_msisdn = 1;
