insert overwrite table unicom_oss.wty_5g_phone_sale
partition(day = '20210523', province = 'qh')
select msisdn, imei, apps, 
social_days, social_durition, social_traff, 
game_days, game_durition, game_traff, 
shop_days, shop_durition, shop_traff, 
video_days, video_durition, video_traff
from
(
select abcd.msisdn, abcd.apps, abcd.imei, 
abcd.social_days, abcd.social_durition, abcd.social_traff, 
abcd.game_days, abcd.game_durition, abcd.game_traff, 
abcd.shop_days, abcd.shop_durition, abcd.shop_traff, 
nvl(e0.video_days,0) video_days, nvl(e0.video_durition,0) video_durition, nvl(e0.video_traff,0) video_traff
from
(
select abc.msisdn, abc.apps, abc.imei, 
abc.social_days, abc.social_durition, abc.social_traff,
abc.game_days, abc.game_durition, abc.game_traff,
nvl(d0.shop_days,0) shop_days, nvl(d0.shop_durition,0) shop_durition, nvl(d0.shop_traff,0) shop_traff
from
(
select ab.msisdn, ab.apps, ab.imei, 
ab.social_days, ab.social_durition, ab.social_traff,
nvl(c0.game_days,0) game_days, nvl(c0.game_durition,0) game_durition, nvl(c0.game_traff,0) game_traff
from
(
select a1.msisdn, a1.apps, a1.imei, 
nvl(b0.social_days,0) social_days, nvl(b0.social_durition,0) social_durition, nvl(b0.social_traff,0) social_traff
from
(
select msisdn, imei, apps
from
(
select msisdn, imei, 
count(distinct(substring(slicetime,1,8))) days, count(distinct(servname)) apps
from data_db.qh_lte_s1u_http
where substring(slicetime,1,8) between 20210517 and 20210523
and length(msisdn) = 11
and substring(msisdn,1,3) not in('145','146')
group by msisdn, imei
) a0
where days >= 5
) a1
left join
(
select msisdn, count(distinct(substring(slicetime,1,8))) as social_days, 
round(sum(durition)/1000) social_durition, sum(total_traff) social_traff
from data_db.qh_lte_s1u_http
where substring(slicetime,1,8) between 20210517 and 20210523
and length(msisdn) = 11
and substring(msisdn,1,3) not in('145','146')
and cast(durition as decimal) >= 0
and cast(total_traff as decimal) >= 0
and cast(servname as int) in(300,304,308,330,2000002,2000071,2000115,2000158)
group by msisdn
) b0
on a1.msisdn = b0.msisdn
) ab
left join
(
select msisdn, count(distinct(substring(slicetime,1,8))) as game_days, 
round(sum(durition)/1000) game_durition, sum(total_traff) game_traff
from data_db.qh_lte_s1u_http
where substring(slicetime,1,8) between 20210517 and 20210523
and length(msisdn) = 11
and substring(msisdn,1,3) not in('145','146')
and cast(durition as decimal) >= 0
and cast(total_traff as decimal) >= 0
and (cast(servname as int) in(651,652,653,658)
or instr(host,'sgz.ejoy.com') > 0 
or instr(host,'launcher.ejoy.com') > 0 
or instr(host,'gangplank.ejoy.com') > 0 
or instr(host,'whjx-cdn.38ejed.com') > 0 
or instr(host,'whjx.shiyuegame.com') > 0 
or instr(host,'yuanshen.com') > 0 
or instr(lower(uri),'com.mihoyo.yuanshen') > 0 
or instr(lower(user_agent),'yuanshen') > 0 
or instr(host,'yinxydls.leiting.com') > 0 
or instr(uri,'/yinxy') > 0 
or instr(uri,'com.lilithgames.rok.offical.cn') > 0 
or instr(host,'rok.lilithgames.com') > 0 
or instr(host,'drpf-pm03.proxima.nie.netease.com') > 0 
or instr(host,'dream.163.com') > 0 
or instr(host,'dsgroup3.cfm.qq.com') > 0 
or instr(host,'pvp.qq.com') > 0 
or instr(host,'smoba.qq.com') > 0 
or instr(host,'hpjy-op.tga.qq.com') > 0 
or instr(host,'gp.qq.com') > 0 
or instr(host,'file.igamecj.com') > 0  
or instr(user_agent,'ShadowTrackerExtra') > 0  
or instr(uri,'.qq.com/jdqssy/') > 0
or (instr(host,'.qq.com') > 0 and (instr(user_agent,'Survive/') > 0
or instr(uri,'com.tencent.tmgp.pubgmhd') > 0)) 
or instr(host,'my.163.com') > 0 
or instr(host,'xyq.163.com') > 0 
or instr(host,'.gph.netease.com') > 0
or (instr(host,'.netease.com') > 0 and (instr(user_agent,'xyqmobile') > 0 
or instr(host,'my.') > 0 
or instr(host,'nie') > 0 
or instr(host,'my-') > 0 
or instr(host,'gl8') > 0)) 
or instr(host,'.xy2.163.com') > 0 
or instr(host,'.dh2.netease.com') > 0 
or instr(host,'.dh2.163.com') > 0  
or instr(host,'.xy.163.com') > 0  
or (instr(uri,'gray.cc.163.com') > 0 and instr(uri,'type=dh2') > 0))
group by msisdn
) c0
on ab.msisdn = c0.msisdn
) abc
left join
(
select msisdn, count(distinct(day)) as shop_days, 
round(sum(durition)/1000) shop_durition, sum(data_flow) shop_traff
from unicom_oss.zqq_dw_third_level_label
where province = 'qh'
and day between 20210517 and 20210523
and length(msisdn) = 11
and substring(msisdn,1,3) not in('145','146')
and cast(durition as decimal) >= 0
and cast(data_flow as decimal) >= 0
and substring(third_label_id,1,6) = '004005'
group by msisdn
) d0 
on abc.msisdn = d0.msisdn
) abcd
left join
(
select msisdn, count(distinct(day)) as video_days, 
round(sum(durition)/1000) video_durition, sum(data_flow) video_traff
from unicom_oss.zqq_dw_third_level_label
where province = 'qh'
and day between 20210517 and 20210523
and length(msisdn) = 11
and substring(msisdn,1,3) not in('145','146')
and cast(durition as decimal) >= 0
and cast(data_flow as decimal) >= 0
and substring(third_label_id,1,6) = '004006'
group by msisdn
) e0 
on abcd.msisdn = e0.msisdn
) final;
