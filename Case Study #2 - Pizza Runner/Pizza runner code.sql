DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

DROP TABLE IF EXISTS customer_orders_clean;
CREATE TABLE customer_orders_clean(
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);  

DROP TABLE IF EXISTS runner_orders_clean;
CREATE TABLE runner_orders_clean(
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO customer_orders_clean
SELECT 
order_id, 
customer_id, 
pizza_id, 
CASE
WHEN exclusions IS NULL or exclusions = 'null' THEN ''
ELSE exclusions 
END AS exclusions,
CASE
WHEN extras IS NULL or extras = 'null' THEN '' /* replacing nulls and "null" with "" */
ELSE extras 
END AS extras,
order_time
FROM customer_orders;


INSERT INTO runner_orders_clean
   SELECT order_id,
   runner_id, 
   CASE
   WHEN pickup_time = 'null' THEN NULL /* replacing "nulls" with "" */
   ELSE pickup_time 
   END AS pickup_time, 
   CASE
   WHEN distance = 'null' THEN '0'
   WHEN distance LIKE '%km%' THEN REPLACE(distance,'km','') 
   ELSE distance
   END AS distance, 
   CASE
   WHEN duration = 'null' THEN '0' 
   WHEN duration LIKE '%minutes%' THEN REPLACE(duration,'minutes','')
   WHEN duration LIKE '%mins%' THEN REPLACE(duration,'mins','')
   WHEN duration LIKE '%minute%' THEN REPLACE(duration,'minute','') 
   ELSE duration
   END AS duration, 
   CASE
   WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
   ELSE cancellation 
   END AS cancellation 
   FROM runner_orders;

   -- Create a temporary TIMESTAMP column
ALTER TABLE runner_orders_clean ADD COLUMN create_time_holder TIMESTAMP without time zone NULL;

-- Copy casted value over to the temporary column
UPDATE runner_orders_clean SET create_time_holder = pickup_time::TIMESTAMP;

-- Modify original column using the temporary column
ALTER TABLE runner_orders_clean 
ALTER COLUMN pickup_time TYPE TIMESTAMP without time zone USING create_time_holder;

-- Drop the temporary column (after examining altered column values)
ALTER TABLE runner_orders_clean DROP COLUMN create_time_holder;

ALTER TABLE runner_orders_clean 
ALTER COLUMN duration TYPE NUMERIC USING (duration::NUMERIC),
ALTER COLUMN distance TYPE NUMERIC USING (distance::NUMERIC);

DROP TABLE customer_orders;
ALTER TABLE customer_orders_clean RENAME TO customer_orders;

DROP TABLE runner_orders;
ALTER TABLE runner_orders_clean RENAME TO runner_orders;

-- A

SELECT COUNT(*) as total_count
FROM customer_orders;

SELECT 
COUNT(DISTINCT order_id) AS orders_count 
FROM customer_orders;

SELECT 
runner_id, 
COUNT(order_id) AS successful_orders 
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id;

SELECT 
pn.pizza_name, 
COUNT(co.pizza_id) AS count 
FROM customer_orders AS co
JOIN pizza_names AS pn ON pn.pizza_id = co.pizza_id
JOIN runner_orders AS ro ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY pn.pizza_name;

SELECT 
co.customer_id,
pn.pizza_name,
COUNT(*) AS count
FROM customer_orders AS co
JOIN pizza_names AS pn ON pn.pizza_id = co.pizza_id
GROUP BY pn.pizza_name, co.customer_id
ORDER BY co.customer_id;

SELECT MAX(count) AS maximum_number_of_delivered_pizzas
FROM(
  SELECT
  co.order_id, 
  COUNT(*) AS count 
  FROM customer_orders AS co
  JOIN runner_orders AS ro ON ro.order_id = co.order_id
  WHERE ro.cancellation = ''
  GROUP BY co.order_id) t;

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

SELECT 
SUM(CASE 
WHEN c.exclusions <> '' AND c.extras <> '' THEN 1 
ELSE 0 
END) AS count
FROM customer_orders AS c
JOIN runner_orders AS r ON r.order_id = c.order_id
WHERE r.cancellation = '';

SELECT 
EXTRACT(HOUR from order_time) AS hours, 
COUNT(*) AS pizza_count
FROM customer_orders
GROUP BY hours
ORDER BY hours;

SELECT 
TO_CHAR(order_time, 'Day') AS weekday,
COUNT(*) AS pizza_count
FROM customer_orders
GROUP BY weekday;

-- B

SELECT 
TO_CHAR(registration_date, 'WW') AS weeks, 
COUNT(runner_id) AS count
FROM runners
GROUP BY weeks
ORDER BY weeks;


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

SELECT 
co.customer_id, 
ROUND(AVG(ro.distance),2) AS average_distance 
FROM customer_orders AS co
JOIN runner_orders AS ro ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY co.customer_id;


SELECT
MIN(duration) AS min_delivery_time_in_minutes,
MAX(duration) AS max_delivery_time_in_minutes
FROM runner_orders
WHERE cancellation = '';
    

SELECT 
runner_id,
order_id,
ROUND(distance/(duration/60), 2) AS speed
FROM runner_orders
WHERE cancellation = ''
ORDER BY runner_id, order_id;

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

-- C

WITH split_pizza_toppings AS(
  SELECT 
  pizza_name,
  topping_name
  FROM (
    SELECT 
    pizza_name,
  unnest(string_to_array(toppings, ',')::int[]) AS topping_id
    FROM pizza_recipes AS pr
JOIN pizza_names AS pn ON pr.pizza_id=pn.pizza_id) AS t
  JOIN pizza_toppings AS pt ON pt.topping_id=t.topping_id)
  
SELECT
pizza_name,
string_agg(topping_name, ', ') AS toppings_list
FROM split_pizza_toppings
GROUP BY pizza_name
ORDER BY pizza_name;

WITH split_extras AS(
  SELECT 
  order_id,
  unnest(string_to_array(extras, ',')::int[]) AS topping_id
  FROM customer_orders
  WHERE extras!='')

SELECT
topping_name,
COUNT(*) AS count
FROM split_extras AS se
JOIN pizza_toppings AS pt ON pt.topping_id=se.topping_id
GROUP BY topping_name
ORDER BY count DESC
LIMIT 1;

WITH split_exclusions AS(
  SELECT 
  order_id,
  unnest(string_to_array(exclusions, ',')::int[]) AS topping_id
  FROM customer_orders
  WHERE exclusions!='')

SELECT
topping_name,
COUNT(*) AS count
FROM split_exclusions AS se
JOIN pizza_toppings AS pt ON pt.topping_id=se.topping_id
GROUP BY topping_name
ORDER BY count DESC
LIMIT 1;

WITH customer_orders_ordered AS(
  SELECT 
  row_number() over() as rownumber,
  *
  FROM customer_orders
), 
    
   customer_orders_toppings AS (
     SELECT *,
     CASE
     WHEN LENGTH(exclusions)>0 THEN CAST(SPLIT_PART(exclusions, ',', 1) AS INT)
     ELSE NULL
     END AS exclusions1,
     CASE
     WHEN LENGTH(exclusions)>1 THEN CAST(SPLIT_PART(exclusions, ',', 2) AS INT)
     ELSE NULL
     END AS exclusions2,
     CASE
     WHEN LENGTH(extras)>0 THEN CAST(SPLIT_PART(extras, ',', 1) AS INT)
     ELSE NULL
     END AS extras1,
     CASE
     WHEN LENGTH(extras)>1 THEN CAST(SPLIT_PART(extras, ',', 2) AS INT)
     ELSE NULL
     END AS extras2
     FROM customer_orders_ordered),
     
     toppings_text AS (
       SELECT
       rownumber,
       order_id,
       customer_id,
       cot.pizza_id,
       exclusions,
       extras,
       order_time,
       pizza_name,
       CASE
       WHEN cot.exclusions1 IS NOT NULL AND cot.exclusions2 IS NOT NULL THEN CONCAT(p1.topping_name, ', ', p2.topping_name)
       ELSE CONCAT(p1.topping_name, p2.topping_name)
       END AS exclusions_list,
       CASE
       WHEN cot.extras1 IS NOT NULL AND cot.extras2 IS NOT NULL THEN CONCAT(p3.topping_name, ', ', p4.topping_name)
       ELSE CONCAT(p3.topping_name, p4.topping_name)
       END AS extras_list
       FROM customer_orders_toppings AS cot
       LEFT JOIN pizza_toppings AS p1 ON p1.topping_id=cot.exclusions1
       LEFT JOIN pizza_toppings AS p2 ON p2.topping_id=cot.exclusions2
       LEFT JOIN pizza_toppings AS p3 ON p3.topping_id=cot.extras1
       LEFT JOIN pizza_toppings AS p4 ON p4.topping_id=cot.extras2
       JOIN pizza_names AS pn ON pn.pizza_id=cot.pizza_id
       ORDER BY rownumber)
   
   
SELECT
rownumber,
order_id,
customer_id,
pizza_id,
exclusions,
extras,
CASE
WHEN exclusions_list = '' AND extras_list = '' THEN pizza_name
WHEN exclusions_list IS NOT NULL AND extras_list = '' THEN CONCAT (pizza_name, ' - Exclude ', exclusions_list)
WHEN exclusions_list = '' AND extras_list IS NOT NULL THEN CONCAT (pizza_name, ' - Extra ', extras_list)
ELSE CONCAT(pizza_name, ' - Exclude ', exclusions_list, ' - Extra ', extras_list)
END AS order_item
FROM toppings_text;


WITH customer_orders_ordered AS(
  SELECT 
  row_number() over() as rownumber,
  co.*
  FROM customer_orders AS co
  LEFT JOIN runner_orders AS ro ON co.order_id = ro.order_id
  WHERE cancellation = ''), 
  
  	standart_pizza_toppings AS(
      SELECT 
      pizza_id,
      unnest(string_to_array(toppings, ',')::int[]) AS topping_id
      FROM pizza_recipes),

    	nr_of_delivered_pizzas AS(
      SELECT pizza_id, 
      COUNT(*) AS count 
      FROM customer_orders_ordered 
      GROUP BY pizza_id),
      
    split_exclusions_extras AS(
      SELECT 
      unnest(string_to_array(exclusions, ',')::int[]) AS exclusions_id,
      unnest(string_to_array(extras, ',')::int[]) AS extras_id
      FROM customer_orders_ordered
      WHERE exclusions!='' OR extras!=''),
      
    exclusions_count AS(
      SELECT
      exclusions_id AS topping_id,
      COUNT(exclusions_id) AS count_exc
      FROM split_exclusions_extras
      GROUP BY topping_id
      ),
      
    extras_count AS(
      SELECT
      extras_id AS topping_id,
      COUNT(extras_id) AS count_ext
      FROM split_exclusions_extras
      GROUP BY topping_id
    ),
    
    ingridients_grouped AS(
      SELECT
      spt.topping_id,
      SUM(count) AS from_pizzas_count,
      COALESCE(count_ext, 0) AS extras_count,
      COALESCE(count_exc, 0) AS excluded_extra
      FROM standart_pizza_toppings AS spt
      JOIN nr_of_delivered_pizzas AS nr
      ON spt.pizza_id = nr.pizza_id
      LEFT JOIN extras_count AS ext
      ON spt.topping_id = ext.topping_id
      LEFT JOIN exclusions_count AS exc
      ON spt.topping_id = exc.topping_id
      GROUP BY spt.topping_id, count_ext, count_exc
      ORDER BY spt.topping_id)


SELECT
topping_name,
SUM(from_pizzas_count + extras_count - excluded_extra) AS count
FROM ingridients_grouped as ig
JOIN pizza_toppings AS pt ON pt.topping_id=ig.topping_id
GROUP BY topping_name
ORDER BY count DESC;

-- D

SELECT SUM(CASE 
WHEN p.pizza_name = 'Meatlovers' THEN 12
ELSE 10
END)
AS pizza_cost FROM customer_orders as c
JOIN runner_orders AS r ON r.order_id = c.order_id
JOIN pizza_names AS p ON p.pizza_id = c.pizza_id
WHERE r.cancellation = '';

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



