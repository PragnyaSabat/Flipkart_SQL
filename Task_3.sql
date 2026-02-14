# Answer 1 Below query calculates average delivery delay converted to days by dividing (24*60) to average minutes
select route_id,start_location,end_location,average_travel_time_min/(24*60) as average_delivery_time_in_days from routes;

# Answer 2 Below query calculates average traffic delay in days
select route_id,avg(datediff(actual_delivery_date,expected_delivery_date)) as average_traffic_delay_in_days from orders 
group by route_id order by route_id;

# Answer 3 Below query calculates distance to time efficiency ratio
select route_id,distance_km/average_travel_time_min as distance_to_time_efficiency_ratio from routes;

# Answer 4 Below query calculates distance to time efficiency and orders it in ascending order because lowest efficiency is the worst 
select route_id,start_location,end_location,distance_km,distance_km/average_travel_time_min as distance_to_time_efficiency_ratio
from routes order by distance_to_time_efficiency_ratio limit 3;

# Answer 5 Below query finds percentage of delayed shipments and 20 % delay means 120 % delivery time and time is in denominator 
-- of distance to time ratio so it is inversely proportional and should be < 100/120
select route_id,start_location,end_location,distance_km,distance_km/average_travel_time_min as distance_to_time_efficiency_ratio
from routes where distance_km/average_travel_time_min<(100/120);

# Answer 6 Below are the suggestions for betterment of delivery efficiency
-- choose rt15 instead of rt13 as it has higher distance_to_time_efficiency_ratio   
-- choose rt16 instead of rt15 for optimization
-- choose rt20 instead of rt03 for optimization
