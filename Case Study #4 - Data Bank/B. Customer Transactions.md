# B. Customer Transactions


**1. What is the unique count and total amount for each transaction type?**

```
SELECT txn_type as types, 
COUNT(*) as count, 
SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type;
```

Answer:


| types      | count | total_amount |
| ---------- | ----- | ------------ |
| purchase   | 1617  | 806537       |
| deposit    | 2671  | 1359168      |
| withdrawal | 1580  | 793003       |


The most common transaction type is deposit which is also reflected in its total amount.

---

**2. What is the average total historical deposit counts and amounts for all customers?**


```
WITH grouped_deposit AS(
  SELECT 
  customer_id,
  COUNT(*) as count, 
  SUM(txn_amount) AS total_amount
  FROM customer_transactions
  WHERE txn_type = 'deposit'
  GROUP BY customer_id)

SELECT 
ROUND(AVG(count)) as avg_count, 
ROUND(AVG(total_amount)) AS avg_total_amount
FROM grouped_deposit;
```

Answer:

| avg_count | avg_total_amount |
| --------- | ---------------- |
| 5         | 2718             |


On average each customer made 5 deposits with total value $2718.

---

**3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?**

This question is a bit ambiguous so to specify - I'm looking for count by months of customers that made either 1 purchase or 1 withdrawal and additionally made more than 1 deposit. I'm starting with a table grouped by customer_id and month number to determine how many of each transaction type each customer made per month.


```
WITH count_months AS(
  SELECT 
  customer_id, 
  EXTRACT(MONTH FROM txn_date) as month, 
  SUM(case when txn_type='deposit' then 1 else 0 end) AS deposit_count,
  SUM(case when txn_type='withdrawal' then 1 else 0 end) AS withdrawal_count,
  SUM(case when txn_type='purchase' then 1 else 0 end) AS purchase_count
  FROM customer_transactions
  GROUP BY customer_id, month
  ORDER BY customer_id, month)

SELECT 
month, 
COUNT(*) 
FROM count_months 
WHERE deposit_count > 1 AND withdrawal_count+purchase_count=1
GROUP BY month;
```

Answer:

| month | count |
| ----- | ----- |
| 1     | 53    |
| 2     | 36    |
| 3     | 38    |
| 4     | 22    |

---

**4. What is the closing balance for each customer at the end of the month?**

To sum all amounts up to a given month I'm using SUM(...) OVER(PARTITION BY ...
ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
(https://learnsql.com/blog/sql-window-functions-rows-clause/)


```
WITH count_months AS(
  SELECT 
  customer_id, 
  EXTRACT(MONTH FROM txn_date) as month, 
  SUM(CASE
      WHEN txn_type='deposit' THEN txn_amount
      ELSE -txn_amount
      END) AS net_amount
  FROM customer_transactions
  GROUP BY customer_id, month
  ORDER BY customer_id, month)

SELECT 
customer_id, 
month, 
net_amount,
SUM(net_amount) OVER(PARTITION BY customer_id
ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance
FROM count_months;

```

Answer:

| customer_id | month | net_amount | closing_balance |
| ----------- | ----- | ---------- | --------------- |
| 1           | 1     | 312        | 312             |
| 1           | 3     | -952       | -640            |
| 2           | 1     | 549        | 549             |
| 2           | 3     | 61         | 610             |
| 3           | 1     | 144        | 144             |
| 3           | 2     | -965       | -821            |
| 3           | 3     | -401       | -1222           |
| 3           | 4     | 493        | -729            |
| 4           | 1     | 848        | 848             |
| 4           | 3     | -193       | 655             |
| 5           | 1     | 954        | 954             |
| 5           | 3     | -2877      | -1923           |
| 5           | 4     | -490       | -2413           |


--
