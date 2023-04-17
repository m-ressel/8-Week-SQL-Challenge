# C. Ingredient Optimisation

**1. What are the standard ingredients for each pizza?**

To convert toppings id to toppings name from list, I first change string into array using built-in function string_to_array() and split it to rows using unnest(). Then I join this table with pizza_toppings to get toppings name. Lastly, using string_agg() I change rows of topping names into string.

```
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
```

| pizza_name | toppings_list                                                         |
| ---------- | --------------------------------------------------------------------- |
| Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| Vegetarian | Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce            |

---
**2. What was the most commonly added extra?**

Here I do a similar thing as in the previous question - first I split not empty strings of extras into rows. Then I join them with table pizza_toppings to get topping names.

```
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
```


| topping_name | count |
| ------------ | ----- |
| Bacon        | 4     |

The most commonly added extra is bacon.

---
**3. What was the most common exclusion?**

In this question I use exactly the same process as in the previous question, this time on column exclusions instead of extras.

```
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
```

| topping_name | count |
| ------------ | ----- |
| Cheese       | 4     |

Cheese is the most common exclusion.

---
**4. Generate an order item for each record in the customers_orders table in the format of one of the following...**

In this task, I start with adding row number to each order in customer_orders. There's one order that contains 2 exactly the same pizzas so row number helps me with identifying them makes each row unique.

```
    WITH customer_orders_ordered AS(
      SELECT 
      row_number() over() as rownumber,
      *
      FROM customer_orders
    ), 
```
Then I split non-empty exclusion and extras column into 1 or 2 (depends how many toppings are in the string) using SPLIT_PART() and then changing them into integers.
```
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
```
In next table, toppings_text, I use table pizza_toppings to change INT topping_id in columns I've just created to topping_name. I also make strings in rows who have multiple extras or exclusions using CONCAT() to connect them before the final table.
```
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
```
Lastly, I again use CONCAT() function to make strings just like in this question's description. If there are no changes, I put only pizza name in column order_item.
```
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

```

| rownumber | order_id | customer_id | pizza_id | exclusions | extras | order_item                                                      |
| --------- | -------- | ----------- | -------- | ---------- | ------ | --------------------------------------------------------------- |
| 1         | 1        | 101         | 1        |            |        | Meatlovers                                                      |
| 2         | 2        | 101         | 1        |            |        | Meatlovers                                                      |
| 3         | 3        | 102         | 1        |            |        | Meatlovers                                                      |
| 4         | 3        | 102         | 2        |            |        | Vegetarian                                                      |
| 5         | 4        | 103         | 1        | 4          |        | Meatlovers - Exclude Cheese                                     |
| 6         | 4        | 103         | 1        | 4          |        | Meatlovers - Exclude Cheese                                     |
| 7         | 4        | 103         | 2        | 4          |        | Vegetarian - Exclude Cheese                                     |
| 8         | 5        | 104         | 1        |            | 1      | Meatlovers - Extra Bacon                                        |
| 9         | 6        | 101         | 2        |            |        | Vegetarian                                                      |
| 10        | 7        | 105         | 2        |            | 1      | Vegetarian - Extra Bacon                                        |
| 11        | 8        | 102         | 1        |            |        | Meatlovers                                                      |
| 12        | 9        | 103         | 1        | 4          | 1, 5   | Meatlovers - Exclude Cheese - Extra Bacon, Chicken              |
| 13        | 10       | 104         | 1        |            |        | Meatlovers                                                      |
| 14        | 10       | 104         | 1        | 2, 6       | 1, 4   | Meatlovers - Exclude BBQ Sauce, Mushrooms - Extra Bacon, Cheese |

---
**6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**

Similarly as in the previous question, I start with adding row numbers to customer_orders. Additionally, I select only rows of orders that were not cancelled.

```
    WITH customer_orders_ordered AS(
      SELECT 
      row_number() over() as rownumber,
      co.*
      FROM customer_orders AS co
      LEFT JOIN runner_orders AS ro ON co.order_id = ro.order_id
      WHERE cancellation = ''), 
```
After that, I split each pizza's toppings' string into rows and check how many times each pizza was delivered. I also count how many times each extra and exclusion was included in orders. 

```
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

```
My next step is putting all previously counted numbers together - for each topping_id I select how many times it was in standard ingredients of ordered pizzas, how many was ordered as extra and how many times was excluded. To those last 2 colums, I use function COALESCE() that returns first not NULL value - thanks to that I have zeros in columns extras_count and excluded_count for toppings that were never excluded or ordered extra.
```
        ingridients_grouped AS(
          SELECT
          spt.topping_id,
          SUM(count) AS from_pizzas_count,
          COALESCE(count_ext, 0) AS extras_count,
          COALESCE(count_exc, 0) AS excluded_count
          FROM standart_pizza_toppings AS spt
          JOIN nr_of_delivered_pizzas AS nr
          ON spt.pizza_id = nr.pizza_id
          LEFT JOIN extras_count AS ext
          ON spt.topping_id = ext.topping_id
          LEFT JOIN exclusions_count AS exc
          ON spt.topping_id = exc.topping_id
          GROUP BY spt.topping_id, count_ext, count_exc
          ORDER BY spt.topping_id)
```
Lastly, I sum from_pizzas_count and extras_count values and substract excluded_count value for each topping and transform topping_id into topping_name.

```
    SELECT
    topping_name,
    SUM(from_pizzas_count + extras_count - excluded_count) AS count
    FROM ingridients_grouped as ig
    JOIN pizza_toppings AS pt ON pt.topping_id=ig.topping_id
    GROUP BY topping_name
    ORDER BY count DESC;
```

| topping_name | count |
| ------------ | ----- |
| Bacon        | 12    |
| Mushrooms    | 11    |
| Cheese       | 10    |
| Pepperoni    | 9     |
| Chicken      | 9     |
| Salami       | 9     |
| Beef         | 9     |
| BBQ Sauce    | 8     |
| Tomato Sauce | 3     |
| Onions       | 3     |
| Tomatoes     | 3     |
| Peppers      | 3     |


As we can see, the most popular topping is bacon.

---
