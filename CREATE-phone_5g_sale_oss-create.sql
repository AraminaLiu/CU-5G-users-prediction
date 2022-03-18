CREATE EXTERNAL TABLE wty.phone_5g_sale_oss(
msisdn STRING,
imei STRING,
apps BIGINT,
social_days BIGINT,
social_durition BIGINT,
social_traff BIGINT,
game_days BIGINT,
game_durition BIGINT,
game_traff BIGINT,
shop_days BIGINT,
shop_durition BIGINT,
shop_traff BIGINT,
video_days BIGINT,
video_durition BIGINT,
video_traff BIGINT
)
PARTITIONED BY(
day STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/wty.db/phone_5g_sale_oss';

