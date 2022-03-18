beeline -u "jdbc:hive2://gdlt-b-master01.cnbdcu.com:2181,gdlt-b-master02.cnbdcu.com:2181,\
gdlt-b-master03.cnbdcu.com:2181,gdlt-b-master04.cnbdcu.com:2181,gdlt-b-master05.cnbdcu.com:2181\
/default;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2" \
--showHeader=true --outputformat=dsv --delimiterForDSV=',' -e "
select msisdn, imei, apps, 
social_days, social_durition, social_traff, game_days, game_durition, game_traff, 
shop_days, shop_durition, shop_traff, video_days, video_durition, video_traff
from unicom_oss.wty_5g_phone_sale
where day = '20210419'
and province = 'qh';
" > /data1/home/unicom_oss/unicom_wty/qh_5g_phone_sale/qh_5g_phone_sale-20210419.csv