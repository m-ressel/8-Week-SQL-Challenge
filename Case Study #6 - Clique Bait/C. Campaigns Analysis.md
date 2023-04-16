# C. Campaigns Analysis

**Generate a table that has 1 single row for every unique visit_id record and has the following columns:**

* ```user_id```
* ```visit_id```
* ```visit_start_time```: the earliest ```event_time``` for each visit
* ```page_views```: count of page views for each visit
* ```cart_adds```: count of product cart add events for each visit
* ```purchase```: 1/0 flag if a purchase event exists for each visit
* ```campaign_name```: map the visit to a campaign if the ```visit_start_time``` falls between the ```start_date``` and ```end_date```
* ```impression```: count of ad impressions for each visit
* ```click```: count of ad clicks for each visit
* (Optional column) ```cart_products```: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the ```sequence_number```)

For the optional column I'm using function STRING_AGG with ORDER BY ```sequence_number```.

```
SELECT
visit_id,
user_id,
MIN(event_time) AS visit_start_time,
SUM(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS cart_adds,
MAX(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
campaign_name,
SUM(CASE WHEN event_type = 4 THEN 1 ELSE 0 END) AS impression, 
SUM(CASE WHEN event_type = 5 THEN 1 ELSE 0 END) AS click,
STRING_AGG(CASE 
           WHEN event_type = 2 THEN page_name 
           ELSE NULL END, 
    ', ' ORDER BY sequence_number) AS cart_product
FROM events AS e
INNER JOIN users as u ON u.cookie_id = e.cookie_id
LEFT JOIN campaign_identifier AS ci
ON e.event_time BETWEEN ci.start_date AND ci.end_date
LEFT JOIN page_hierarchy AS ph ON ph.page_id = e.page_id
GROUP BY visit_id, user_id, campaign_name
ORDER BY visit_id
```

First 7 rows:

| visit_id | user_id | visit_start_time         | page_views | cart_adds | purchase | campaign_name                     | impression | click | cart_product                                                 |
| -------- | ------- | ------------------------ | ---------- | --------- | -------- | --------------------------------- | ---------- | ----- | ------------------------------------------------------------ |
| 001597   | 155     | 2020-02-17T00:21:45.295Z | 10         | 6         | 1        | Half Off - Treat Your Shellf(ish) | 1          | 1     | Salmon, Russian Caviar, Black Truffle, Lobster, Crab, Oyster |
| 002809   | 243     | 2020-03-13T17:49:55.459Z | 4          | 0         | 0        | Half Off - Treat Your Shellf(ish) | 0          | 0     |                                                              |
| 0048b2   | 78      | 2020-02-10T02:59:51.335Z | 6          | 4         | 0        | Half Off - Treat Your Shellf(ish) | 0          | 0     | Kingfish, Russian Caviar, Abalone, Lobster                   |
| 004aaf   | 228     | 2020-03-18T13:23:07.973Z | 6          | 2         | 1        | Half Off - Treat Your Shellf(ish) | 0          | 0     | Tuna, Lobster                                                |
| 005fe7   | 237     | 2020-04-02T18:14:08.257Z | 9          | 4         | 1        |                                   | 0          | 0     | Kingfish, Black Truffle, Crab, Oyster                        |
| 006a61   | 420     | 2020-01-25T20:54:14.630Z | 9          | 5         | 1        | 25% Off - Living The Lux Life     | 1          | 1     | Tuna, Russian Caviar, Black Truffle, Abalone, Crab           |
| 006e8c   | 252     | 2020-02-21T03:14:44.965Z | 1          | 0         | 0        | Half Off - Treat Your Shellf(ish) | 0          | 0     |                                                              |

