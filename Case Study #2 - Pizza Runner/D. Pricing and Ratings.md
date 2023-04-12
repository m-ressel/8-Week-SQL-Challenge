# D. Pricing and Ratings
---

**1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?**

```
    SELECT SUM(CASE 
    WHEN p.pizza_name = 'Meatlovers' THEN 12
    ELSE 10
    END)
    AS pizza_cost FROM customer_orders as c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    JOIN pizza_names AS p ON p.pizza_id = c.pizza_id
    WHERE r.cancellation = '';
```

| pizza_cost |
| ---------- |
| 138        |

---
**2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra.**

```
    SELECT SUM(CASE 
    WHEN p.pizza_name = 'Meatlovers' THEN 12
    ELSE 10
    END + CASE 
    WHEN LENGTH(c.extras) = 4 AND c.extras Ilike '%4%' THEN 3
    WHEN LENGTH(c.extras) = 4 THEN 2
    WHEN LENGTH(c.extras) = 1 AND c.extras Ilike '%4%' THEN 2
    WHEN LENGTH(c.extras) = 1 THEN 1
    ELSE 0
    END) as cost_with_extras
    FROM customer_orders as c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    JOIN pizza_names AS p ON p.pizza_id = c.pizza_id
    WHERE r.cancellation = '';
```

| cost_with_extras |
| ---------------- |
| 143              |


---
**3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.**

```
    CREATE TABLE runners_rating(
      order_id INTEGER,
      rating NUMERIC CHECK (rating IN (1,2,3,4,5))
    );

    INSERT INTO runners_rating
    VALUES
      (1, 3),
      (2, 4),
      (3, 4),
      (4, 2),
      (5, 5),
      (7, 4),
      (8, 1),
      (10, 2);

    SELECT * FROM runners_rating;
```

| order_id | rating |
| -------- | ------ |
| 1        | 3      |
| 2        | 4      |
| 3        | 4      |
| 4        | 2      |
| 5        | 5      |
| 7        | 4      |
| 8        | 1      |
| 10       | 2      |

---
**4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?**

```
    SELECT 
    c.customer_id, 
    c.order_id, 
    r.runner_id, 
    r_r.rating, 
    c.order_time, 
    r.pickup_time, 
    TO_CHAR(r.pickup_time-c.order_time, 'MI') AS order_pickup_diff, 
    r.duration, 
    ROUND(r.distance/(r.duration/60), 2) AS avg_speed, 
    COUNT(c.order_id) AS no_of_pizzas
    FROM customer_orders as c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    JOIN runners_rating as r_r ON r_r.order_id = c.order_id
    WHERE r.cancellation = ''
    GROUP BY 
    c.customer_id, 
    c.order_id, 
    r.runner_id, 
    r_r.rating, 
    c.order_time, 
    r.pickup_time, 
    order_pickup_diff, 
    r.duration, 
    avg_speed
    ORDER BY c.order_id;
```

| customer_id | order_id | runner_id | rating | order_time               | pickup_time              | order_pickup_diff | duration | avg_speed | no_of_pizzas |
| ----------- | -------- | --------- | ------ | ------------------------ | ------------------------ | ----------------- | -------- | --------- | ------------ |
| 101         | 1        | 1         | 3      | 2020-01-01T18:05:02.000Z | 2020-01-01T18:15:34.000Z | 10                | 32       | 37.50     | 1            |
| 101         | 2        | 1         | 4      | 2020-01-01T19:00:52.000Z | 2020-01-01T19:10:54.000Z | 10                | 27       | 44.44     | 1            |
| 102         | 3        | 1         | 4      | 2020-01-02T23:51:23.000Z | 2020-01-03T00:12:37.000Z | 21                | 20       | 40.20     | 2            |
| 103         | 4        | 2         | 2      | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | 29                | 40       | 35.10     | 3            |
| 104         | 5        | 3         | 5      | 2020-01-08T21:00:29.000Z | 2020-01-08T21:10:57.000Z | 10                | 15       | 40.00     | 1            |
| 105         | 7        | 2         | 4      | 2020-01-08T21:20:29.000Z | 2020-01-08T21:30:45.000Z | 10                | 25       | 60.00     | 1            |
| 102         | 8        | 2         | 1      | 2020-01-09T23:54:33.000Z | 2020-01-10T00:15:02.000Z | 20                | 15       | 93.60     | 1            |
| 104         | 10       | 1         | 2      | 2020-01-11T18:34:49.000Z | 2020-01-11T18:50:20.000Z | 15                | 10       | 60.00     | 2            |

---
**5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?**

```
    SELECT 
    ROUND(SUM(CASE 
    WHEN p.pizza_name = 'Meatlovers' THEN 12
    ELSE 10
    END - r.distance*0.3), 2)
    AS total_earning
    FROM customer_orders as c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    JOIN pizza_names AS p ON p.pizza_id = c.pizza_id
    WHERE cancellation = '' ;
```

| total_earning |
| ------------- |
| 73.38         |

