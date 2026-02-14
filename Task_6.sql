select * from shipment_tracking order by Order_ID;
select * from orders;

# Answer 1 Below query finds last checkpoint and time for each order
WITH RankedCheckpoints AS (
    SELECT
        Order_ID,
        Checkpoint,
        Checkpoint_Time,
        
        -- This assigns a rank to each row within its OrderID group,
        -- starting with 1 for the newest (DESC) checkpoint time.
        ROW_NUMBER() OVER(
            PARTITION BY Order_ID 
            ORDER BY Checkpoint_Time DESC
        ) AS rn
    FROM
        shipment_tracking
)
-- Now, just select the rows where the rank is 1
SELECT
    Order_ID,
    Checkpoint,
    Checkpoint_Time
FROM
    RankedCheckpoints
WHERE
    rn = 1
ORDER BY
    Order_ID;
    
# Answer 2 Below query finds frequency of most common delay reson except 'None'
select delay_reason, count(delay_reason) as frequency from shipment_tracking 
group by Delay_Reason having Delay_Reason <> 'None' order by frequency desc;

# Answer 3 Below query filters orders with delayed checkpoints > 2
select order_id,count(checkpoint) as checkpoint_count from shipment_tracking where Delay_Reason <> 'None' 
group by Order_ID having checkpoint_count>2 order by order_id;

