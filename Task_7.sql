select * from orders;
select * from delivery_agents;
select * from routes;
select * from shipment_tracking;
select * from warehouses;

# Answer 1 Below query finds average delivery delay per distinct start location
select start_location,sum(traffic_delay_min) as total_delay,count(Start_Location) as frequency,
sum(Traffic_Delay_Min)/count(start_location) as avg_delivery_delay_per_region
from routes group by Start_Location;

# Answer 2 Below query finds the on time delivery percentage
-- Below query finds on time delivery percentage for each order
select a.Order_ID,((datediff(a.actual_delivery_date,a.expected_delivery_date))*24*60) 
as delay_time,(b.average_travel_time_min*300) as travel_time,
(((b.average_travel_time_min*300)-((datediff(a.actual_delivery_date,a.expected_delivery_date))*24*60))/(b.average_travel_time_min*300))*100 
as percent from orders a join routes b on a.route_id=b.route_id;
-- Below query finds on time delivery percentage in whole
SELECT ( COUNT(
            CASE
                WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) <= 0 THEN 1
            END
        ) / COUNT(*)
    ) * 100 AS on_time_delivery_percent
FROM orders;

# Answer 3 Below query finds average traffic delay per route
select a.route_id,count(a.route_id) as frequency_of_route_id,
sum(b.traffic_delay_min) as total_delay,(sum(b.traffic_delay_min)/count(a.route_id)) as avg_traffic_delay_per_route
from orders a join routes b on a.route_id=b.route_id group by a.Route_ID order by a.route_id;