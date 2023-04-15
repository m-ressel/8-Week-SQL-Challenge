# A. Digital Analysis
  
**1. How many users are there?**

```
SELECT 
COUNT(DISTINCT(user_id)) AS user_count 
FROM users;
```

Answer:

| user_count |
| ---------- |
| 500        |

---

**2. How many cookies does each user have on average?**


```
WITH cookie AS(
  SELECT user_id,
  COUNT(cookie_id) AS cookie_count
  FROM users
  GROUP BY user_id)

SELECT 
ROUND(AVG(cookie_count)) AS avg_cookie
FROM cookie;
```

Answer:

| avg_cookie |
| ---------- |
| 4          |

---

**3. What is the unique number of visits by all users per month?**


```
SELECT 
EXTRACT('MONTH' from event_time) as month,
COUNT(DISTINCT visit_id) as visit_count
FROM events
GROUP BY month;
```

Answer:

| month | visit_count |
| ----- | ----------- |
| 1     | 876         |
| 2     | 1488        |
| 3     | 916         |
| 4     | 248         |
| 5     | 36          |

---

**4. What is the number of events for each event type?**


```
SELECT 
event_type,
COUNT(event_type) AS event_count 
FROM events
GROUP BY event_type
ORDER BY event_type;
```

Answer:

| event_type | event_count |
| ---------- | ----------- |
| 1          | 20928       |
| 2          | 8451        |
| 3          | 1777        |
| 4          | 876         |
| 5          | 702         |

---

**5. What is the percentage of visits which have a purchase event?**


```
SELECT 
ROUND(100 * COUNT(DISTINCT e.visit_id)/
    (SELECT COUNT(DISTINCT visit_id) FROM events)) AS percentage_purchase
FROM events AS e
JOIN event_identifier AS ei
  ON e.event_type = ei.event_type
WHERE ei.event_name = 'Purchase';
```

Answer:

| percentage_purchase |
| ------------------- |
| 49                  |

49% of visits have a purchase event.

---

**6. What is the percentage of visits which view the checkout page but do not have a purchase event?**

First, I'm counting how many visits have a purchase event and how many visited checkout page (page_id = 12). Then I'm calculating difference between those 2 values and calculate the percentage.

```
WITH purchase_count AS(
  SELECT 
  COUNT(DISTINCT e.visit_id) AS count
  FROM events AS e
  JOIN event_identifier AS ei
  ON e.event_type = ei.event_type
  WHERE ei.event_name = 'Purchase'),
  
  checkout_count AS(
  SELECT 
  COUNT(DISTINCT visit_id) AS count
  FROM events
  WHERE page_id = 12)
  
SELECT 
ROUND(100*(cc.count - pc.count)::numeric/(SELECT COUNT(DISTINCT visit_id) FROM events), 2) AS percentage
FROM purchase_count AS pc
CROSS JOIN checkout_count AS cc
;
```

Answer:

| percentage |
| ---------- |
| 9.15       |


9.15% of visits viewed the checkout page but do not have a purchase event.

---

**7. What are the top 3 pages by number of views?**


```
SELECT 
ph.page_name, 
COUNT(e.page_id) AS view_count
FROM events e
JOIN page_hierarchy AS ph ON ph.page_id = e.page_id
WHERE e.event_type = 1
GROUP BY ph.page_name
ORDER BY view_count DESC
LIMIT 3;
```

Answer:

| page_name    | view_count |
| ------------ | ---------- |
| All Products | 3174       |
| Checkout     | 2103       |
| Home Page    | 1782       |

Top 3 pages by number of views are "All products", "Checkout" and "Home Page".

---

**8. What is the number of views and cart adds for each product category?**

```
SELECT
product_category,
event_name,
COUNT(*)
FROM events AS e
JOIN page_hierarchy AS ph ON e.page_id=ph.page_id
JOIN event_identifier AS ei ON e.event_type=ei.event_type
WHERE e.event_type IN (1,2) AND product_id IS NOT null
GROUP BY product_category, event_name
ORDER BY product_category, event_name;
```

Answer:

| product_category | event_name  | count |
| ---------------- | ----------- | ----- |
| Fish             | Add to Cart | 2789  |
| Fish             | Page View   | 4633  |
| Luxury           | Add to Cart | 1870  |
| Luxury           | Page View   | 3032  |
| Shellfish        | Add to Cart | 3792  |
| Shellfish        | Page View   | 6204  |

---

**9. What are the top 3 products by purchases?**

Firstly, I extract visit_id of visits that ended with a purchase. Then I join them with table events and choose only rows that have event_type=2 which is "Add to Cart".

```
WITH purchased_visit_id AS(
  SELECT
  visit_id
  FROM events
  WHERE event_type = 3)
  
  
SELECT
page_name,
COUNT(*) AS view_count
FROM events AS e
RIGHT JOIN purchased_visit_id as pv ON pv.visit_id=e.visit_id
JOIN page_hierarchy AS ph ON e.page_id=ph.page_id
WHERE product_category IS NOT NULL AND event_type = 2
GROUP BY page_name
ORDER BY view_count DESC
LIMIT 3;
```

Answer:

| page_name | view_count |
| --------- | ---------- |
| Lobster   | 754        |
| Oyster    | 726        |
| Crab      | 719        |

Top 3 products by purchases are lobster, oyster and crab.

