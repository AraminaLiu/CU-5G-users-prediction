insert overwrite table unicom_oss.wty_gps_extract_user_home_v4
partition(province = 'qh', day = '20210511')
select msisdn, gps, eci, lng_ex, lat_ex, count(distinct(day)) days
from
(
select c1.day, c1.msisdn, c1.gps, c1.eci, c1.end_t, c1.lng_ex, c1.lat_ex,
rank() over(partition by c1.msisdn, c1.day order by c1.end_t) index_m,
rank() over(partition by c1.msisdn, c1.day order by c1.end_t desc) index_n
from
(
select a1.day, a1.msisdn, a1.eci, a1.end_t, a1.lng_ex, a1.lat_ex,
concat(cast(b1.longitude as decimal(10,6)),'-',cast(b1.latitude as decimal(10,6))) gps
from
(
select day, msisdn, eci,
cast(regexp_replace(substring(end_t,12,8),':','') as bigint) end_t,
cast(longitude_1 as decimal(10,4)) lng_ex, cast(latitude_1 as decimal(10,4)) lat_ex
from unicom_oss.wty_gps_extract_9p
where substring(day,1,8) between 20200907 and 20210511
and province = 'qh'
and length(msisdn) = 11
) a1
inner join
(
select * from unicom_oss.wty_gps_gc
where province = 'qh'
) b1
on a1.eci = b1.eci
where sqrt(power((a1.lng_ex-b1.longitude),2)+power((a1.lat_ex-b1.latitude),2))<=0.01
) c1
inner join 
(
select msisdn, eci
from
(
select msisdn, eci, count(*) over(partition by msisdn) eci_cnt
from unicom_oss.wty_gps_extract_eci_home
where province = 'qh' and period = '30'
) d1
where eci_cnt <= 2
) d2
on c1.msisdn = d2.msisdn and c1.eci = d2.eci
) e1
where index_n = 1 or index_m = 1
group by msisdn, gps, eci, lng_ex, lat_ex;
