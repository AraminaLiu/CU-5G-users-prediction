CREATE EXTERNAL TABLE wty.phone_5g_sale_bss(
user_no STRING, 
msisdn STRING,
age INT,
gender INT,
net_type STRING,
month_fee DOUBLE,
overdue_owe DOUBLE,
term_svc STRING,
phone_company STRING,
phone_model STRING,
phone_used_months INT,
phones_owned INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/wty.db/phone_5g_sale_bss';