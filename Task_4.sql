use flipkart;
select * from warehouses;
select * from orders;
select * from shipment_tracking;
# Answer 1 Below query finds average processing time and orders in descending order
select * from warehouses order by average_processing_time_min desc limit 3;

# Answer 2 Below query finds ratio for total vs delayed shipments for each warehouse
SELECT warehouse_id, COUNT(order_id) AS num_of_orders,
  SUM(CASE
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) > 0 THEN 1
        ELSE 0
      END) AS num_of_delay_orders
FROM orders GROUP BY warehouse_id ORDER BY warehouse_id;

# Answer 3 Below query finds bottleneck warehouses where processing time > global average
-- This query compares a warehouse's total delay vs. its total processing  
  /*
Step 1: The CTE. It calculates the total orders and delayed
orders for each warehouse.
*/
WITH calculation AS (
  SELECT warehouse_id, COUNT(order_id) AS num_of_orders,
  SUM(CASE
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) > 0 THEN 1
        ELSE 0
      END) AS num_of_delay_orders
FROM orders GROUP BY warehouse_id
)
/*
Step 2: The main query. We join all three data sources:
1. orders (o) - for row-level dates
2. warehouses (w) - for average processing time
3. calculation (c) - for the 'num_of_orders' aggregate
*/
SELECT DISTINCT
  w.warehouse_id
FROM
  orders o
  JOIN warehouses w ON o.warehouse_id = w.warehouse_id
  JOIN calculation c ON o.warehouse_id = c.warehouse_id 
WHERE
  -- This filter compares a single order's delay...
  (DATEDIFF(o.actual_delivery_date, o.expected_delivery_date) * 24 * 60) > 
  -- ...to a warehouse-level total
  (w.average_processing_time_min * c.num_of_orders) order by warehouse_id;


# Answer 4
-- Step 1: By using original CTE to get the base counts.
WITH calculated_table AS(
  SELECT
    warehouse_id,
    COUNT(order_id) AS num_of_orders,
    SUM(CASE
          WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) > 0 THEN 1
          ELSE 0
        END) AS num_of_delay_orders
  FROM
    orders
  GROUP BY
    warehouse_id
),

/*
Step 2: A new CTE to calculate the percentage from Step 1's results.
*/
percentage_calculation AS (
  SELECT
    warehouse_id,
    num_of_orders,
    num_of_delay_orders,
    
    CASE
      WHEN num_of_orders = 0 THEN 0
      ELSE ((num_of_orders - num_of_delay_orders) * 100.0 / num_of_orders)
    END AS on_time_delivery_percentage
    
  FROM
    calculated_table
)

/*
Step 3: Final SELECT. Now 'on_time_delivery_percentage' is a known column,
so now the RANK() function can be used.
*/
SELECT
  warehouse_id,
  num_of_orders,
  num_of_delay_orders,
  on_time_delivery_percentage,
  
  -- RANK() ranks by percentage, highest (best) first
  RANK() OVER (ORDER BY on_time_delivery_percentage DESC) AS delivery_rank
  
FROM
  percentage_calculation
ORDER BY
  delivery_rank; -- Order the final output by the rank