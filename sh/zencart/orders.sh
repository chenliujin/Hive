#!/bin/bash

day=$1

[ -z $day ] && day=`date -d '-12 hour' +%Y-%m-%d`

/opt/hive/bin/hive -e "
FROM h_zencart_orders

INSERT OVERWRITE TABLE h_wa_orders
SELECT CONCAT('www.tinydeal.com_', purchased_at), 'www.tinydeal.com' AS site, purchased_at, SUM(order_total), COUNT(orders_id), COUNT(DISTINCT customers_id), weekofyear(purchased_at), month(purchased_at), year(purchased_at)
WHERE key >= '"$day"' AND orders_status IN (2,3,5)
GROUP BY purchased_at

INSERT OVERWRITE TABLE wa_countries_sales_day
PARTITION (site, created_date)
    SELECT delivery_country, SUM(order_total), 'www.tinydeal.com', purchased_at
    WHERE '"$day"' <= key AND orders_status IN (2,3,5)
    GROUP BY purchased_at, delivery_country
"