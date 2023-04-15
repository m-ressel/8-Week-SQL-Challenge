# B. Product Funnel Analysis
  
**In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:**
 
Using a single SQL query - create a new output table which has the following details:

* How many times was each product viewed?</li>
* How many times was each product added to cart?</li>
* How many times was each product added to a cart but not purchased (abandoned)?</li>
* How many times was each product purchased?</li></ul>

```
WITH purchased_visit_id AS(
  SELECT
  visit_id
  FROM events
  WHERE event_type = 3)
  
  
SELECT
page_name AS product_name,
SUM(CASE
WHEN event_type=1 THEN 1
ELSE 0
END) AS viewed_count,
SUM(CASE
WHEN event_type=2 THEN 1
ELSE 0
END) AS added_count,
SUM(CASE
WHEN e.visit_id NOT IN (SELECT visit_id from purchased_visit_id) AND event_type=2 THEN 1
ELSE 0
END) AS abandoned_count,
SUM(CASE
WHEN e.visit_id IN (SELECT visit_id from purchased_visit_id) AND event_type=2 THEN 1
ELSE 0
END) AS purchased_count
FROM events AS e
JOIN page_hierarchy AS ph ON e.page_id=ph.page_id
WHERE product_category IS NOT NULL
GROUP BY page_name
ORDER BY page_name;
```

Output:

| product_name   | viewed_count | added_count | abandoned_count | purchased_count |
| -------------- | ------------ | ----------- | --------------- | --------------- |
| Abalone        | 1525         | 932         | 233             | 699             |
| Black Truffle  | 1469         | 924         | 217             | 707             |
| Crab           | 1564         | 949         | 230             | 719             |
| Kingfish       | 1559         | 920         | 213             | 707             |
| Lobster        | 1547         | 968         | 214             | 754             |
| Oyster         | 1568         | 943         | 217             | 726             |
| Russian Caviar | 1563         | 946         | 249             | 697             |
| Salmon         | 1559         | 938         | 227             | 711             |
| Tuna           | 1515         | 931         | 234             | 697             |


Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

```
WITH purchased_visit_id AS(
  SELECT
  visit_id
  FROM events
  WHERE event_type = 3)
  
  
SELECT
product_category,
SUM(CASE
WHEN event_type=1 THEN 1
ELSE 0
END) AS viewed_count,
SUM(CASE
WHEN event_type=2 THEN 1
ELSE 0
END) AS added_count,
SUM(CASE
WHEN e.visit_id NOT IN (SELECT visit_id from purchased_visit_id) AND event_type=2 THEN 1
ELSE 0
END) AS abandoned_count,
SUM(CASE
WHEN e.visit_id IN (SELECT visit_id from purchased_visit_id) AND event_type=2 THEN 1
ELSE 0
END) AS purchased_count
FROM events AS e
JOIN page_hierarchy AS ph ON e.page_id=ph.page_id
WHERE product_category IS NOT NULL
GROUP BY product_category
ORDER BY product_category;
```

Output:

| product_category | viewed_count | added_count | abandoned_count | purchased_count |
| ---------------- | ------------ | ----------- | --------------- | --------------- |
| Fish             | 4633         | 2789        | 674             | 2115            |
| Luxury           | 3032         | 1870        | 466             | 1404            |
| Shellfish        | 6204         | 3792        | 894             | 2898            |

---

**1. Which product had the most views, cart adds and purchases?**

The most views: oyster

The most cart adds and purchases: lobster

**2. Which product was most likely to be abandoned?**

The most likely product to be abandoned is russian caviar.

**3. Which product had the highest view to purchase percentage?**

```
SELECT 
product_name, 
ROUND(100 * purchased_count/viewed_count::numeric, 2) AS purchase_per_view_percentage
FROM B_product_name
ORDER BY purchase_per_view_percentage DESC
LIMIT 1;
```

| product_name | purchase_per_view_percentage | 
| -------------| ---------------------------- |
| Lobster      | 48.74                        | 

Lobster has the highest view to purchase percentage at 48.74%.

**4. What is the average conversion rate from view to cart add?**
**5. What is the average conversion rate from cart add to purchase?**

Conversion rate from A to B is a fraction B/A in percentage.

```
SELECT 
ROUND(AVG(100 * added_count/viewed_count::numeric), 2) AS conversion_view_to_add_to_cart,
ROUND(AVG(100 * purchased_count/added_count::numeric), 2) AS conversion_added_to_purchased
FROM B_product_name;
```

For products:

| conversion_view_to_add_to_cart | conversion_added_to_purchased | 
| -------------------------------| ----------------------------- |
| 60.95                          | 75.93                         |


For categories:

| conversion_view_to_add_to_cart | conversion_added_to_purchased | 
| -------------------------------| ----------------------------- |
| 61.00                          | 75.78                         |

