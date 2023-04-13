# A. Customer Journey

**1. How many unique nodes are there on the Data Bank system?**

```
SELECT 
COUNT(DISTINCT node_id) AS unique_nodes_count 
FROM customer_nodes;

```

Answer:

| unique_nodes_count |
| ------------------ |
| 5                  |


There are 5 unique nodes.

---

**2. What is the number of nodes per region?**

```
SELECT 
r.region_name, 
COUNT(c.node_id) AS nodes_count
FROM customer_nodes AS c
JOIN regions AS r ON r.region_id=c.region_id
GROUP BY r.region_name;

```

Answer:

| region_name | nodes_count |
| ----------- | ----------- |
| America     | 735         |
| Australia   | 770         |
| Africa      | 714         |
| Asia        | 665         |
| Europe      | 616         |

---

**3. How many customers are allocated to each region?**


```

SELECT 
r.region_name, 
COUNT(DISTINCT c.customer_id) AS customer_count
FROM customer_nodes AS c
JOIN regions AS r ON r.region_id=c.region_id
GROUP BY r.region_name;
```

Answer:


| region_name | customer_count |
| ----------- | -------------- |
| Africa      | 102            |
| America     | 105            |
| Asia        | 95             |
| Australia   | 110            |
| Europe      | 88             |

---

**4. How many days on average are customers reallocated to a different node?**

```
SELECT 
ROUND(AVG(end_date - start_date)) AS avg_day_count
FROM customer_nodes
WHERE end_date <> '9999-12-31';

```
Answer:

| avg_day_count |
| ------------- |
| 15            |


On average customers are reallocated to different nodes every 15 days.

---

**5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?**

I'm using build in PostgreSQL function percentile_cont to calculate all percentiles including median (50th percentile).

```
WITH customer_nodes_data_diff AS(
  SELECT *,
  end_date - start_date AS diff
  FROM customer_nodes
  WHERE end_date <> '9999-12-31' 
  )

SELECT 
r.region_name,
percentile_cont(0.5) WITHIN GROUP (ORDER BY cn.diff) AS median,
percentile_cont(0.8) WITHIN GROUP (ORDER BY cn.diff) AS "80th_percentile",
percentile_cont(0.95) WITHIN GROUP (ORDER BY cn.diff) AS "95th_percentile"
FROM customer_nodes_data_diff AS cn
JOIN regions AS r ON cn.region_id=r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;

```

Answer:


| region_name | median | 80th_percentile | 95th_percentile |
| ----------- | ------ | --------------- | --------------- |
| Africa      | 15     | 24              | 28              |
| America     | 15     | 23              | 28              |
| Asia        | 15     | 23              | 28              |
| Australia   | 15     | 23              | 28              |
| Europe      | 15     | 24              | 28              |

For all regions I got the same median and 95th percentile values, which are 15 and 28 days, respectively. For Africa and Europe 80th percentile equals 24 days, 1 day more than for other regions.

---
