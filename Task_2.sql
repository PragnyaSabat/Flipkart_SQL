# Answer 1 Below query finds difference between actual delivery date and expected delivery date for each order 
select datediff(actual_delivery_date,expected_delivery_date) as delay_days from orders;

# Answer 2 Below query ranks distinct routes according to there delay days in descending order and uses traffic delay time for tie breaker  
select  a.route_id,b.start_location,b.end_location,
datediff(a.actual_delivery_date,a.expected_delivery_date) as delay_days,b.traffic_delay_min
from orders a join routes b on a.route_id=b.route_id order by delay_days desc,traffic_delay_min desc limit 10;

# Answer 3 Below query ranks all orders within each warehouse on the basis of delay days 
select warehouse_id,order_id,
datediff(actual_delivery_date,expected_delivery_date) as delay,
dense_rank() over(partition by warehouse_id order by  datediff(actual_delivery_date,expected_delivery_date), order_id) as rank_num
from orders;
