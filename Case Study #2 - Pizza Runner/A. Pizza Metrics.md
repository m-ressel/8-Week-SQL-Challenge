# A. Pizza Metrics

**1. How many pizzas were ordered?**

```
    SELECT COUNT(*) as total_count
    FROM customer_orders;
```

| total_count |
| ----------- |
| 14          |

---
**2. How many unique customer orders were made?**

```
    SELECT 
    COUNT(DISTINCT order_id) AS orders_count 
    FROM customer_orders;
```

| orders_count |
| ------------ |
| 10           |

---
**3. How many successful orders were delivered by each runner?**

```
    SELECT 
    runner_id, 
    COUNT(order_id) AS successful_orders 
    FROM runner_orders
    WHERE cancellation = ''
    GROUP BY runner_id;
```

| runner_id | successful_orders |
| --------- | ----------------- |
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

---
**4. How many of each type of pizza was delivered?**

```
    SELECT 
    pn.pizza_name, 
    COUNT(co.pizza_id) AS count 
    FROM customer_orders AS co
    JOIN pizza_names AS pn ON pn.pizza_id = co.pizza_id
    JOIN runner_orders AS ro ON ro.order_id = co.order_id
    WHERE ro.cancellation = ''
    GROUP BY pn.pizza_name;
```

| pizza_name | count |
| ---------- | ----- |
| Meatlovers | 9     |
| Vegetarian | 3     |

---
**5. How many Vegetarian and Meatlovers were ordered by each customer?**

```
    SELECT 
    co.customer_id,
    pn.pizza_name,
    COUNT(*) AS count
    FROM customer_orders AS co
    JOIN pizza_names AS pn ON pn.pizza_id = co.pizza_id
    GROUP BY pn.pizza_name, co.customer_id
    ORDER BY co.customer_id;
```

| customer_id | pizza_name | count |
| ----------- | ---------- | ----- |
| 101         | Meatlovers | 2     |
| 101         | Vegetarian | 1     |
| 102         | Meatlovers | 2     |
| 102         | Vegetarian | 1     |
| 103         | Meatlovers | 3     |
| 103         | Vegetarian | 1     |
| 104         | Meatlovers | 3     |
| 105         | Vegetarian | 1     |

---
**6. What was the maximum number of pizzas delivered in a single order?**

```
    SELECT MAX(count) AS maximum_number_of_delivered_pizzas
    FROM(
      SELECT
      co.order_id, 
      COUNT(*) AS count 
      FROM customer_orders AS co
      JOIN runner_orders AS ro ON ro.order_id = co.order_id
      WHERE ro.cancellation = ''
      GROUP BY co.order_id) t;
```

| maximum_number_of_delivered_pizzas |
| ---------------------------------- |
| 3                                  |

---
**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**

```
    SELECT 
    c.customer_id,
    SUM(
      CASE 
      WHEN c.exclusions = '' AND c.extras = '' THEN 1 
      ELSE 0 
      END) AS no_changes,
    SUM(
      CASE 
      WHEN c.exclusions <> '' OR c.extras <> '' then 1 else 0 end) AS at_least_1_change
    FROM customer_orders AS c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    WHERE r.cancellation = ''
    GROUP BY c.customer_id;
```

| customer_id | no_changes | at_least_1_change |
| ----------- | ---------- | ----------------- |
| 101         | 2          | 0                 |
| 102         | 3          | 0                 |
| 105         | 0          | 1                 |
| 104         | 1          | 2                 |
| 103         | 0          | 3                 |

---
**8. How many pizzas were delivered that had both exclusions and extras?**

```
    SELECT 
    SUM(CASE 
        WHEN c.exclusions <> '' AND c.extras <> '' THEN 1 
        ELSE 0 
        END) AS count
    FROM customer_orders AS c
    JOIN runner_orders AS r ON r.order_id = c.order_id
    WHERE r.cancellation = '';
```

| count |
| ----- |
| 1     |

---
**9. What was the total volume of pizzas ordered for each hour of the day?**

```
    SELECT 
    EXTRACT(HOUR from order_time) AS hours, 
    COUNT(*) AS pizza_count
    FROM customer_orders
    GROUP BY hours
    ORDER BY hours;
```

| hours | pizza_count |
| ----- | ----------- |
| 11    | 1           |
| 13    | 3           |
| 18    | 3           |
| 19    | 1           |
| 21    | 3           |
| 23    | 3           |

---
**10. What was the volume of orders for each day of the week?**

```
    SELECT 
    TO_CHAR(order_time, 'Day') AS weekday,
    COUNT(*) AS pizza_count
    FROM customer_orders
    GROUP BY weekday;
```

| weekday   | pizza_count |
| --------- | ----------- |
| Saturday  | 5           |
| Thursday  | 3           |
| Friday    | 1           |
| Wednesday | 5           |

---
