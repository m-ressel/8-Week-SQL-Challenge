# C. Product Analysis
  
**1. What are the top 3 products by total revenue before discount?**

```
SELECT 
pd.product_name,
SUM(s.qty*s.price) as revenue
FROM sales AS s
LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
GROUP BY pd.product_name
ORDER BY revenue DESC
LIMIT 3;
```

Answer:

| product_name                 | revenue |
| ---------------------------- | ------- |
| Blue Polo Shirt - Mens       | 217683  |
| Grey Fashion Jacket - Womens | 209304  |
| White Tee Shirt - Mens       | 152000  |

Top 3 products by total revenue are men blue polo shirt, women gray fashion jacket and men white tee shirt.

---

**2. What is the total quantity, revenue and discount for each segment?**

```
SELECT 
pd.segment_name,
SUM(s.qty) as qty_total,
SUM(s.qty*s.price) AS revenue_total,
SUM(s.qty*s.price*s.discount/100) AS discount_total
FROM sales AS s
LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
GROUP BY pd.segment_name
ORDER BY pd.segment_name;
```

Answer:

| segment_name | qty_total | revenue_total | discount_total |
| ------------ | --------- | ------------- | -------------- |
| Jacket       | 11385     | 366983        | 42451          |
| Jeans        | 11349     | 208350        | 23673          |
| Shirt        | 11265     | 406143        | 48082          |
| Socks        | 11217     | 307977        | 35280          |

---
**3. What is the top selling product for each segment?**


```
WITH count_segment AS(
  SELECT 
  segment_name,
  product_name,
  SUM(qty) as qty_total,
  RANK() OVER(PARTITION BY segment_name ORDER BY SUM(qty) desc)
  FROM sales AS s
  LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
  GROUP BY pd.segment_name, pd.product_name
  ORDER BY qty_total DESC)
  
SELECT
segment_name,
product_name,
qty_total
FROM count_segment
WHERE RANK=1;
```

Answer:

| segment_name | product_name                  | qty_total |
| ------------ | ----------------------------- | --------- |
| Jacket       | Grey Fashion Jacket - Womens  | 3876      |
| Jeans        | Navy Oversized Jeans - Womens | 3856      |
| Shirt        | Blue Polo Shirt - Mens        | 3819      |
| Socks        | Navy Solid Socks - Mens       | 3792      |

---

**4. What is the total quantity, revenue and discount for each category?**

```
SELECT 
pd.category_name,
SUM(s.qty) as qty_total,
SUM(s.qty*s.price) AS revenue_total,
ROUND(SUM((s.qty*s.price*s.discount)::numeric/100), 2) AS discount_total
FROM sales AS s
LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name
ORDER BY pd.category_name;
```

Answer:

| category_name | qty_total | revenue_total | discount_total |
| ------------- | --------- | ------------- | -------------- |
| Mens          | 22482     | 714120        | 86607.71       |
| Womens        | 22734     | 575333        | 69621.43       |

---
**5. What is the top selling product for each category?**

```
WITH count_category AS(
  SELECT 
  category_name,
  product_name,
  SUM(qty) as qty_total,
  RANK() OVER(PARTITION BY category_name ORDER BY SUM(qty) desc)
  FROM sales AS s
  LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
  GROUP BY category_name, product_name
  ORDER BY qty_total DESC)
  
SELECT
category_name,
product_name,
qty_total
FROM count_category
WHERE RANK=1;
```

Answer:

| category_name | product_name                 | qty_total |
| ------------- | ---------------------------- | --------- |
| Womens        | Grey Fashion Jacket - Womens | 3876      |
| Mens          | Blue Polo Shirt - Mens       | 3819      |

---

**6. What is the percentage split of revenue by product for each segment?**

```
WITH revenue_by_segment AS(
  SELECT pd.segment_name,
  pd.product_name,
  SUM(s.qty*s.price) AS revenue_total
  FROM sales AS s
  INNER JOIN product_details AS pd ON s.prod_id=pd.product_id
  GROUP BY pd.segment_name, pd.product_name
  ORDER BY pd.segment_name, pd.product_name)

SELECT 
segment_name, 
product_name, 
revenue_total, 
ROUND(100 * revenue_total/(SUM(revenue_total) OVER (PARTITION BY segment_name)), 2) AS percentage_in_segment
FROM revenue_by_segment
ORDER BY segment_name, percentage_in_segment DESC;
```

Answer:

| segment_name | product_name                     | revenue_total | percentage_in_segment |
| ------------ | -------------------------------- | ------------- | --------------------- |
| Jacket       | Grey Fashion Jacket - Womens     | 209304        | 57.03                 |
| Jacket       | Khaki Suit Jacket - Womens       | 86296         | 23.51                 |
| Jacket       | Indigo Rain Jacket - Womens      | 71383         | 19.45                 |
| Jeans        | Black Straight Jeans - Womens    | 121152        | 58.15                 |
| Jeans        | Navy Oversized Jeans - Womens    | 50128         | 24.06                 |
| Jeans        | Cream Relaxed Jeans - Womens     | 37070         | 17.79                 |
| Shirt        | Blue Polo Shirt - Mens           | 217683        | 53.60                 |
| Shirt        | White Tee Shirt - Mens           | 152000        | 37.43                 |
| Shirt        | Teal Button Up Shirt - Mens      | 36460         | 8.98                  |
| Socks        | Navy Solid Socks - Mens          | 136512        | 44.33                 |
| Socks        | Pink Fluro Polkadot Socks - Mens | 109330        | 35.50                 |
| Socks        | White Striped Socks - Mens       | 62135         | 20.18                 |


---
**7. What is the percentage split of revenue by segment for each category?**

```
WITH revenue_by_category AS(
  SELECT pd.category_name,
  pd.segment_name,
  SUM(s.qty*s.price) AS revenue_total
  FROM sales AS s
  LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
  GROUP BY pd.category_name, pd.segment_name
  ORDER BY pd.category_name, pd.segment_name)

SELECT 
category_name, 
segment_name, 
revenue_total, 
ROUND(100 * revenue_total/(SUM(revenue_total) OVER (PARTITION BY category_name)), 2) AS percentage_in_category
FROM revenue_by_category
ORDER BY category_name DESC, percentage_in_category DESC;
```

Answer:

 category_name | segment_name | revenue_total | percentage_in_category |
| ------------- | ------------ | ------------- | ---------------------- |
| Womens        | Jacket       | 366983        | 63.79                  |
| Womens        | Jeans        | 208350        | 36.21                  |
| Mens          | Shirt        | 406143        | 56.87                  |
| Mens          | Socks        | 307977        | 43.13                  |

---

**8. What is the percentage split of total revenue by category?**

```
SELECT 
pd.category_name,
ROUND(100 * SUM(s.qty*s.price)/(SELECT SUM(qty*price) FROM sales)::numeric, 2) AS revenue_percentage
FROM sales AS s
LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name;
```


Answer:

| category_name | revenue_percentage |
| ------------- | ------------------ |
| Mens          | 55.38              |
| Womens        | 44.62              |

---

**9. What is the total transaction “penetration” for each product?**

Penetration is a number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions.

```
SELECT 
pd.product_name,
ROUND(100 * COUNT(DISTINCT txn_id)/(SELECT COUNT(DISTINCT txn_id) FROM sales)::numeric, 2) AS penetration_percentage
FROM sales AS s
LEFT JOIN product_details AS pd ON s.prod_id=pd.product_id
WHERE s.qty>0
GROUP BY pd.product_name
ORDER BY penetration_percentage DESC;
```

Answer:


| product_name                     | penetration_percentage |
| -------------------------------- | ---------------------- |
| Navy Solid Socks - Mens          | 51.24                  |
| Grey Fashion Jacket - Womens     | 51.00                  |
| Navy Oversized Jeans - Womens    | 50.96                  |
| White Tee Shirt - Mens           | 50.72                  |
| Blue Polo Shirt - Mens           | 50.72                  |
| Pink Fluro Polkadot Socks - Mens | 50.32                  |
| Indigo Rain Jacket - Womens      | 50.00                  |
| Khaki Suit Jacket - Womens       | 49.88                  |
| Black Straight Jeans - Womens    | 49.84                  |
| Cream Relaxed Jeans - Womens     | 49.72                  |
| White Striped Socks - Mens       | 49.72                  |
| Teal Button Up Shirt - Mens      | 49.68                  |

---
