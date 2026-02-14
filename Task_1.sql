create database if not exists flipkart;
use flipkart;
show tables;

# Answer 1- here first query table is seen and compared to 2nd query where distinct items are present. 
-- hence proved no duplicate rows are present.
select *  from delivery_agents;
select distinct * from delivery_agents;
select * from orders;
select distinct * from orders;
select * from routes;
select distinct * from routes;
select * from shipment_tracking;
select distinct * from shipment_tracking;
select * from warehouses;
select distinct * from warehouses;

# Answer 2 no traffic_delay_min values were 0
select distinct traffic_delay_min from routes;

# Answer 3 This query sets all dates of order_date column in 'yyyy-mm-dd' format
select date_format(order_date,'yyyy-mm-dd') as order_date from orders;

# Answer 4 This query checks whether any order date is greater than actual delivery date or not
select * from orders where order_date < actual_delivery_date;