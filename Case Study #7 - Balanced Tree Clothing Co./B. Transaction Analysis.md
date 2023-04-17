# B. Transaction Analysis


**1. How many unique transactions were there?**

```
SELECT 
COUNT(DISTINCT txn_id) AS transactions_count
FROM sales;
```

Answer:

| transactions_count |
| ------------------ |
| 2500               |


---

**2. What is the average unique products purchased in each transaction?**

```
WITH txn_count AS (
  SELECT txn_id,
  COUNT(DISTINCT prod_id) AS count_unique
  FROM sales
  GROUP BY txn_id)
  
SELECT 
ROUND(AVG(count_unique)) AS avg_unique
FROM txn_count;
```

Answer:

| avg_unique |
| ---------- |
| 6          |


On average 6 unique products were bought in each transaction. 

---

**3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**

I'll use built-in function percentile_cont to calculate percentile values.

```
WITH revenue_per_transaction AS (
  SELECT txn_id,
  SUM(qty*price) AS revenue
  FROM sales
  GROUP BY txn_id)
  
SELECT 
percentile_cont(0.25) WITHIN GROUP (ORDER BY revenue) AS "25th_percentile",
percentile_cont(0.5) WITHIN GROUP (ORDER BY revenue) AS "50th_percentile",
percentile_cont(0.75) WITHIN GROUP (ORDER BY revenue) AS "75th_percentile"
FROM revenue_per_transaction;
```

Answer:

| 25th_percentile | 50th_percentile | 75th_percentile |
| --------------- | --------------- | --------------- |
| 375.75          | 509.5           | 647             |


---

**4. What is the average discount value per transaction?**

```
WITH discount_count AS (
  SELECT txn_id,
  SUM(qty*price*discount::numeric/100) AS discount_value
  FROM sales
  GROUP BY txn_id)
  
SELECT 
ROUND(AVG(discount_value), 2) AS avg_discount
FROM discount_count;
```

Answer:

| avg_discount |
| ------------ |
| 62.49        |

---

**5. What is the percentage split of all transactions for members vs non-members?**

```
WITH membership_table AS (
  SELECT txn_id,
  MAX(
    CASE 
    WHEN member='t' THEN 1
    ELSE 0
    END)::numeric AS members_count
  FROM sales
  GROUP BY txn_id)
  
SELECT 
ROUND(100*SUM(members_count)/COUNT(*), 2) AS member_percentage,
ROUND(100*(1-(SUM(members_count)/COUNT(*))), 2) AS nonmember_percentage
FROM membership_table;
```

Answer:

| member_percentage | nonmember_percentage |
| ----------------- | -------------------- |
| 60.20             | 39.80                |

---

**6. What is the average revenue for member transactions and non-member transactions?**

```
WITH membership_table AS (
  SELECT 
  txn_id,
  CASE 
    WHEN member='t' THEN SUM(qty*price)
    END AS members_revenue,
  CASE 
    WHEN member='f' THEN SUM(qty*price)
    END AS non_members_count
  FROM sales
  GROUP BY txn_id, member)
  
SELECT 
ROUND(AVG(members_revenue), 2) avg_members,
ROUND(AVG(non_members_count), 2) avg_non_members
FROM membership_table;
```

Answer:

| avg_members | avg_non_members |
| ----------- | --------------- |
| 516.27      | 515.04          |
