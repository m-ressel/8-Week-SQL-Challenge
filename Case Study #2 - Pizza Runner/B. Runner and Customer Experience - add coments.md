# Runner and Customer Experience
---
**1. How many runners signed up for each 1 week period?**

```
    SELECT 
    TO_CHAR(registration_date, 'WW') AS weeks, 
    COUNT(runner_id) AS count
    FROM runners
    GROUP BY weeks
    ORDER BY weeks;
```

| weeks | count |
| ----- | ----- |
| 01    | 2     |
| 02    | 1     |
| 03    | 1     |

---
**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**

```
    WITH orders_time AS (
      SELECT 
      runner_id,
      ro.order_id,
      order_time,
      pickup_time,
      pickup_time - order_time AS diff 
      FROM runner_orders AS ro
      JOIN customer_orders AS co ON ro.order_id = co.order_id
      WHERE cancellation=''
      GROUP BY runner_id, ro.order_id, order_time, pickup_time) 
    
    SELECT 
    runner_id,
    TO_CHAR(AVG(diff), 'MI') AS avg_time
    FROM orders_time
    GROUP BY runner_id
    ORDER BY runner_id;
```

| runner_id | avg_time |
| --------- | -------- |
| 1         | 14       |
| 2         | 20       |
| 3         | 10       |

---
**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

```
    WITH orders_time AS (
      SELECT 
      ro.order_id,
      COUNT(*) AS count,
      ro.pickup_time - co.order_time AS diff 
      FROM runner_orders AS ro
      JOIN customer_orders AS co ON ro.order_id = co.order_id
      WHERE ro.cancellation=''
      GROUP BY ro.order_id, diff) 
    
    SELECT
    count,
    TO_CHAR(AVG(diff), 'MI') AS avg_time
    FROM orders_time
    GROUP BY count
    ORDER BY count;
```

| count | avg_time |
| ----- | -------- |
| 1     | 12       |
| 2     | 18       |
| 3     | 29       |

---
**4. What was the average distance travelled for each customer?**

```
    SELECT 
    co.customer_id, 
    ROUND(AVG(ro.distance),2) AS average_distance 
    FROM customer_orders AS co
    JOIN runner_orders AS ro ON ro.order_id = co.order_id
    WHERE ro.cancellation = ''
    GROUP BY co.customer_id;
```

| customer_id | average_distance |
| ----------- | ---------------- |
| 101         | 20.00            |
| 102         | 16.73            |
| 103         | 23.40            |
| 104         | 10.00            |
| 105         | 25.00            |

---
**5. What was the difference between the longest and shortest delivery times for all orders?**

```
    WITH orders_time AS(
      SELECT 
      co.order_id, 
      order_time, 
      pickup_time, 
      pickup_time - order_time AS diff
      FROM customer_orders AS co
      JOIN runner_orders AS ro
      ON co.order_id = ro.order_id
      WHERE cancellation = ''
      GROUP BY co.order_id, order_time, pickup_time)
    
    SELECT 
    TO_CHAR(MAX(diff) - MIN(diff), 'MI') AS max_min_diff
    FROM orders_time;
```
| max_min_diff |
| ------------ |
| 19           |

---
**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**
```
    SELECT 
    runner_id,
    order_id,
    ROUND(distance/(duration/60), 2) AS speed
    FROM runner_orders
    WHERE cancellation = ''
    ORDER BY runner_id, order_id;
```
| runner_id | order_id | speed |
| --------- | -------- | ----- |
| 1         | 1        | 37.50 |
| 1         | 2        | 44.44 |
| 1         | 3        | 40.20 |
| 1         | 10       | 60.00 |
| 2         | 4        | 35.10 |
| 2         | 7        | 60.00 |
| 2         | 8        | 93.60 |
| 3         | 5        | 40.00 |

---
**7. What is the successful delivery percentage for each runner?**
```
    SELECT 
    runner_id, 
    ROUND(100*SUM(
      CASE 
      WHEN cancellation = '' THEN 1 
      ELSE 0 
      END)/COUNT(cancellation),0) AS successful_delivery_percentage
    FROM runner_orders
    GROUP BY runner_id
    ORDER BY runner_id;
```
| runner_id | successful_delivery_percentage |
| --------- | ------------------------------ |
| 1         | 100                            |
| 2         | 75                             |
| 3         | 50                             |

---
