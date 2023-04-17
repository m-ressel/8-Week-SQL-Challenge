# B. Data Analysis Questions

**1. How many customers has Foodie-Fi ever had?**

```
SELECT COUNT(DISTINCT customer_id) AS customers_count 
FROM subscriptions;
```

| customers_count |
| --------------- |
| 1000            |

Foodie-Fi had 1000 unique customers.

---
**2. What is the monthly distribution of ```trial``` plan ```start_date``` values for our dataset - use the start of the month as the group by value**

```
    SELECT 
    EXTRACT(MONTH FROM start_date) AS month, 
    COUNT(customer_id) AS trial_count 
    FROM subscriptions
    WHERE plan_id = 0
    GROUP BY month
    ORDER BY month;
```

| month | trial_count |
| ----- | ----------- |
| 1     | 88          |
| 2     | 68          |
| 3     | 94          |
| 4     | 81          |
| 5     | 88          |
| 6     | 79          |
| 7     | 89          |
| 8     | 88          |
| 9     | 87          |
| 10    | 79          |
| 11    | 75          |
| 12    | 84          |

---

**3. What plan ```start_date``` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each ```plan_name```**

```
    SELECT 
    plan_id, 
    COUNT(customer_id) FROM subscriptions
    WHERE EXTRACT(YEAR FROM start_date) > 2020
    GROUP BY plan_id
    ORDER BY plan_id;
```

| plan_id | count |
| ------- | ----- |
| 1       | 8     |
| 2       | 60    |
| 3       | 63    |
| 4       | 71    |

The most common plan_id after 2020 is 4.

---

**4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**

```
    SELECT 
    COUNT(*) AS count,
    ROUND(100 * COUNT(*)::NUMERIC / (SELECT COUNT(DISTINCT customer_id) 
    FROM subscriptions),1) AS percentage
    FROM subscriptions
    WHERE plan_id = 4;
```

| count | percentage |
| ----- | ---------- |
| 307   | 30.7       |

30.7% of all customer decided to churn.

---

**5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**

To check what each customer did after initial trial, I use built-in function RANK() OVER. This way I get order of each customer's plan. To extract those who churned after trial, I count how many customers have plan_id = 4 with rank_order = 2.

```
    WITH ranked_subscriptions AS (
      SELECT 
      *,
      RANK() OVER (PARTITION BY customer_id ORDER BY start_date) AS rank_order
      FROM subscriptions
      ORDER BY customer_id, rank_order
    )
    
    SELECT 
    COUNT(*) AS count,
    ROUND(100 * COUNT(*)::NUMERIC / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage
    FROM ranked_subscriptions
    WHERE plan_id=4 AND rank_order=2;
```

| count | percentage |
| ----- | ---------- |
| 92    | 9.2        |

9.2% of customers decided to churn right after the free trial.

---

**6. What is the number and percentage of customer plans after their initial free trial?**

```
    WITH ranked_subscriptions AS (
      SELECT 
      *,
      RANK() OVER (PARTITION BY customer_id ORDER BY start_date) AS rank_order
      FROM subscriptions
      ORDER BY customer_id, rank_order
    )
    
    SELECT 
    plan_id, 
    COUNT(plan_id) AS count, 
    ROUND(100 * COUNT(*)::NUMERIC / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage
    FROM ranked_subscriptions
    WHERE rank_order=2
    GROUP BY plan_id
    ORDER BY plan_id;

```

| plan_id | count | percentage |
| ------- | ----- | ---------- |
| 1       | 546   | 54.6       |
| 2       | 325   | 32.5       |
| 3       | 37    | 3.7        |
| 4       | 92    | 9.2        |


Majority of customers switched to plan_id 1 after the initial trial.

---

**7. What is the customer count and percentage breakdown of all 5 ```plan_name``` values at ```2020-12-31```?**

```
    WITH subscriptions_next_plan AS (
      SELECT 
      *,
      LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
      FROM subscriptions
      WHERE start_date <= '2020-12-31'
      ORDER BY customer_id,start_date  
    )
    
    
    SELECT 
    plan_id, 
    COUNT(DISTINCT customer_id) AS customers, ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC/ (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage
    FROM subscriptions_next_plan
    WHERE (next_date IS NOT NULL AND (start_date < '2020-12-31' AND next_date > '2020-12-31'))
        OR (next_date IS NULL AND start_date < '2020-12-31')
    GROUP BY plan_id;
```

| plan_id | customers | percentage |
| ------- | --------- | ---------- |
| 0       | 19        | 1.9        |
| 1       | 224       | 22.4       |
| 2       | 326       | 32.6       |
| 3       | 195       | 19.5       |
| 4       | 235       | 23.5       |

---

**8. How many customers have upgraded to an annual plan in 2020?**

```
    SELECT 
    COUNT(customer_id) as annual_count 
    FROM subscriptions
    WHERE plan_id = 3 AND EXTRACT(YEAR FROM start_date)=2020;
```

| annual_count |
| ------------ |
| 195          |

195 customers upgraded to annual plan in 2020.

---

**9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**

```
    WITH annual AS(
      SELECT
      customer_id,
      start_date
      FROM subscriptions
      WHERE plan_id = 3),
      
      trial AS(
        SELECT
        customer_id,
        start_date
        FROM subscriptions
        WHERE plan_id = 0)
        
        
    SELECT 
    ROUND(AVG(a.start_date - t.start_date))
    FROM annual AS a
    LEFT JOIN trial AS t ON t.customer_id = a.customer_id;
```

| round |
| ----- |
| 105   |

On average it takes 105 days for a customer to switch to an annual plan.

---

**10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**

To split average value into shorter periods, I used method described here - https://dba.stackexchange.com/a/269076

```
    WITH annual AS(
      SELECT
      customer_id,
      start_date
      FROM subscriptions
      WHERE plan_id = 3),
      
      trial AS(
        SELECT
        customer_id,
        start_date
        FROM subscriptions
        WHERE plan_id = 0)
        
        
    SELECT  
    30 * FLOOR((a.start_date - t.start_date)/30) as range_start,
    30 * (FLOOR((a.start_date - t.start_date)/30) + 1) as range_end,
    COUNT(a.customer_id) AS count
    FROM annual AS a
    LEFT JOIN trial AS t ON t.customer_id = a.customer_id
    GROUP BY range_start, range_end
    order by range_start;
```

| range_start | range_end | count |
| ----------- | --------- | ----- |
| 0           | 30        | 48    |
| 30          | 60        | 25    |
| 60          | 90        | 33    |
| 90          | 120       | 35    |
| 120         | 150       | 43    |
| 150         | 180       | 35    |
| 180         | 210       | 27    |
| 210         | 240       | 4     |
| 240         | 270       | 5     |
| 270         | 300       | 1     |
| 300         | 330       | 1     |
| 330         | 360       | 1     |

---

**11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**

```
   WITH pro_monthly AS(
      SELECT
      customer_id,
      start_date
      FROM subscriptions
      WHERE plan_id = 2),
      
      basic_monthly AS(
        SELECT
        customer_id,
        start_date
        FROM subscriptions
        WHERE plan_id = 1 AND EXTRACT(YEAR FROM start_date) = 2020)
        
    
    SELECT 
    COUNT(*) AS count
    FROM pro_monthly AS p
    INNER JOIN basic_monthly AS b ON p.customer_id = b.customer_id
    WHERE p.start_date < b.start_date;

```
 
| count |
| ----- |
| 0     |


Not a single customer downgraded from a pro monthly to a basic monthly plan in 2020.
