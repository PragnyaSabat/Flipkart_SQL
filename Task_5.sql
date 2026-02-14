use flipkart;
select * from delivery_agents;

# Answer 1 Below query ranks agents per route based on their on time delivery percentage
select agent_id,route_id,on_time_delivery_percentage, rank() over (partition by route_id
order by on_time_delivery_percentage) as rnk_agent from delivery_agents;

# Answer 2 Below query filters agents with on time delivery percentage < 80
select agent_id,agent_name,On_Time_Delivery_Percentage from delivery_agents where On_Time_Delivery_Percentage<80;

# Answer 3 Below query compares top 5 agents with bottom 5 agents
# This query finds top 5 agents
select agent_id,Avg_Speed_KMPH as top_speed from delivery_agents order by Avg_Speed_KMPH desc limit 5;
# This query finds bottom 5 agents
select agent_id,Avg_Speed_KMPH as bottom_speed from delivery_agents order by Avg_Speed_KMPH asc limit 5;
# This query finds top 5, bottom 5 and their prints difference to compare them
with topspeeds as(
select avg_speed_kmph from delivery_agents order by Avg_Speed_KMPH desc limit 5),
bottomspeeds as(
select avg_speed_kmph from delivery_agents order by Avg_Speed_KMPH asc limit 5)
select
(select avg(avg_speed_kmph) from topspeeds) as avg_top_5_speeds,
(select avg(avg_speed_kmph) from bottomspeeds) as avg_bottom_5_speeds,
(select avg(avg_speed_kmph) from topspeeds) - (select avg(avg_speed_kmph) from bottomspeeds) as difference
from dual limit 1;

# Answer 4 Below is the suggestion for low performers
/* The delivery agents are delivering slow thats why the speed of delivery must be increased and it also depends type of item 
delivered which might be costly so they must also be trained for special deliveries */ 
