# A. Customer Journey

**Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.**

Sample customers included in the sample have customer_id equal to 1, 2, 11, 13, 15, 16, 18 or 19.

```
    SELECT
    customer_id,
    s.plan_id,
    plan_name,
    start_date
    FROM subscriptions AS s
    LEFT JOIN plans as p ON p.plan_id=s.plan_id
    WHERE customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
    ORDER BY customer_id, start_date;
```

| customer_id | plan_id | plan_name     | start_date               |
| ----------- | ------- | ------------- | ------------------------ |
| 1           | 0       | trial         | 2020-08-01T00:00:00.000Z |
| 1           | 1       | basic monthly | 2020-08-08T00:00:00.000Z |
| 2           | 0       | trial         | 2020-09-20T00:00:00.000Z |
| 2           | 3       | pro annual    | 2020-09-27T00:00:00.000Z |
| 11          | 0       | trial         | 2020-11-19T00:00:00.000Z |
| 11          | 4       | churn         | 2020-11-26T00:00:00.000Z |
| 13          | 0       | trial         | 2020-12-15T00:00:00.000Z |
| 13          | 1       | basic monthly | 2020-12-22T00:00:00.000Z |
| 13          | 2       | pro monthly   | 2021-03-29T00:00:00.000Z |
| 15          | 0       | trial         | 2020-03-17T00:00:00.000Z |
| 15          | 2       | pro monthly   | 2020-03-24T00:00:00.000Z |
| 15          | 4       | churn         | 2020-04-29T00:00:00.000Z |
| 16          | 0       | trial         | 2020-05-31T00:00:00.000Z |
| 16          | 1       | basic monthly | 2020-06-07T00:00:00.000Z |
| 16          | 3       | pro annual    | 2020-10-21T00:00:00.000Z |
| 18          | 0       | trial         | 2020-07-06T00:00:00.000Z |
| 18          | 2       | pro monthly   | 2020-07-13T00:00:00.000Z |
| 19          | 0       | trial         | 2020-06-22T00:00:00.000Z |
| 19          | 2       | pro monthly   | 2020-06-29T00:00:00.000Z |
| 19          | 3       | pro annual    | 2020-08-29T00:00:00.000Z |

---

Customer 1 after the trial basic monthly subscription. Customer 2 decided to go for  pro annual plan after their trial. Customer with id 11 decided to churn after their trial period. Customer 13 decided on basic monthly after the trial and after another 3 months they settled on pro monthly plan. 

Customer 15 bought pro monthly plan after the trial and cancelled their subscription after a month. Customer 16 started with basic monthly plan after a week trial and after another 4 months settled on pro annual plan. Customer 18 and 19 chose pro monthly plan after the trial but customer 19 bought pro annual subscription after 2 months.

Out of all sample customers as the last plan 1 settled on basic monthly, 2 cancelled their plan, 2 bought the pro monthly plan and 3 decided on pro annual.
