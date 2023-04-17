# A. High Level Sales Analysis
  
**1. What was the total quantity sold for all products?**

```
SELECT
SUM(qty) AS total_qty
FROM sales;
```

Answer:

| total_qty |
 ---------- |
| 45216     |

---

**2. What is the total generated revenue for all products before discounts?**

```
SELECT 
SUM(price*qty) AS total_revenue
FROM sales;
```

Answer:

| total_revenue |
| ------------- |
| 1289453       |

---
**3. What was the total discount amount for all products?**

```
SELECT 
ROUND(SUM(qty*price*discount::numeric/100), 2) AS total_discount
FROM sales;
```

Answer:

| total_discount |
| -------------- |
| 156229.14      |
