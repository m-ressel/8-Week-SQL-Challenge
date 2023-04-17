# A. Data Exploration and Cleansing
  
**1. Update the fresh_segments.interest_metrics table by modifying the ``` month_year ``` column to be a date data type with the start of the month**

```
ALTER TABLE interest_metrics
ALTER COLUMN 
month_year TYPE DATE 
USING TO_DATE(month_year, 'MM-YYYY');

SELECT * FROM interest_metrics
LIMIT 5;
```

Answer:

| _month | _year | month_year               | interest_id | composition | index_value | ranking | percentile_ranking |
| ------ | ----- | ------------------------ | ----------- | ----------- | ----------- | ------- | ------------------ |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 32486       | 11.89       | 6.19        | 1       | 99.86              |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 6106        | 9.93        | 5.31        | 2       | 99.73              |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 18923       | 10.85       | 5.29        | 3       | 99.59              |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 6344        | 10.32       | 5.1         | 4       | 99.45              |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 100         | 10.77       | 5.04        | 5       | 99.31              |


---
  
**2. What is count of records in the ```interest_metrics``` for each ```month_year``` value sorted in chronological order (earliest to latest) with the null values appearing first?**

To get null values in the first row I'm using function NULL FIRST in GROUP BY clause.

```
SELECT
month_year,
COUNT(*)
FROM interest_metrics
GROUP BY month_year
ORDER BY month_year ASC NULLS FIRST;
```

Answer:

| month_year               | count |
| ------------------------ | ----- |
|                          | 1194  |
| 2018-07-01T00:00:00.000Z | 729   |
| 2018-08-01T00:00:00.000Z | 767   |
| 2018-09-01T00:00:00.000Z | 780   |
| 2018-10-01T00:00:00.000Z | 857   |
| 2018-11-01T00:00:00.000Z | 928   |
| 2018-12-01T00:00:00.000Z | 995   |
| 2019-01-01T00:00:00.000Z | 973   |
| 2019-02-01T00:00:00.000Z | 1121  |
| 2019-03-01T00:00:00.000Z | 1136  |
| 2019-04-01T00:00:00.000Z | 1099  |
| 2019-05-01T00:00:00.000Z | 857   |
| 2019-06-01T00:00:00.000Z | 824   |
| 2019-07-01T00:00:00.000Z | 864   |
| 2019-08-01T00:00:00.000Z | 1149  |

---
  
**3. What do you think we should do with these null values in the fresh_segments.interest_metrics**

In my opinion, if month_year and interest_id columns are nulls, then we can just drop or exclude these rows. We cannot join them to other table nor understand what the other values, like composition, index, ranking in that rows are about. 

---
  
**4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?**


```
SELECT
COUNT(DISTINCT interest_id)
FROM interest_metrics
WHERE interest_id::int NOT IN (
SELECT id FROM interest_map);
```

Answer:

| count_id |
| -------- |
| 0        |

There are no i```nterest_id``` in ```interest_metrics``` table that do not exist in ```interest_map``` table. Let's check the other way around:

```
SELECT
COUNT(id)
FROM interest_map
WHERE id NOT IN (
SELECT DISTINCT interest_id::int FROM interest_metrics WHERE interest_id IS NOT NULL);
```

| count_id |
| -------- |
| 7        |

7 ```id``` are present in table ```interest_map``` and are not in ```interest_metrics```.


---
  
**5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table**

I'm counting unique ```id``` values in table ```interest_map```.

```
SELECT
COUNT(DISTINCT id) AS id_count
FROM interest_map;
```

Answer:

| id_count |
| -------- |
| 1209     |

There are 1209 distinct id records in ```interest_map``` table.

---
  
**6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.**

Since we know from the question 4, the number of the unique ```id``` records in the ```interest_metrics``` table and in the interest_map table is not the same: there are 7 ```id``` are present in table ```interest_map``` and are not in ```interest_metrics```.

Below I used LEFT JOIN to keep all records from ```interest_map``` and join those in ```interest_metrics```.

```
SELECT
interest_id,
interest_name,
interest_summary,
created_at,
last_modified,
_month,
_year,
month_year,
composition,
index_value,
ranking,
percentile_ranking
FROM interest_metrics AS im
LEFT JOIN interest_map AS i ON i.id=im.interest_id::int
WHERE interest_id = '21246';
```

Output:


| interest_id | interest_name                    | interest_summary                                      | created_at               | last_modified            | _month | _year | month_year               | composition | index_value | ranking | percentile_ranking |
| ----------- | -------------------------------- | ----------------------------------------------------- | ------------------------ | ------------------------ | ------ | ----- | ------------------------ | ----------- | ----------- | ------- | ------------------ |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |        |       |                          | 1.61        | 0.68        | 1191    | 0.25               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 4      | 2019  | 2019-04-01T00:00:00.000Z | 1.58        | 0.63        | 1092    | 0.64               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 3      | 2019  | 2019-03-01T00:00:00.000Z | 1.75        | 0.67        | 1123    | 1.14               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 2      | 2019  | 2019-02-01T00:00:00.000Z | 1.84        | 0.68        | 1109    | 1.07               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 1      | 2019  | 2019-01-01T00:00:00.000Z | 2.05        | 0.76        | 954     | 1.95               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 12     | 2018  | 2018-12-01T00:00:00.000Z | 1.97        | 0.7         | 983     | 1.21               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 11     | 2018  | 2018-11-01T00:00:00.000Z | 2.25        | 0.78        | 908     | 2.16               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 10     | 2018  | 2018-10-01T00:00:00.000Z | 1.74        | 0.58        | 855     | 0.23               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 9      | 2018  | 2018-09-01T00:00:00.000Z | 2.06        | 0.61        | 774     | 0.77               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 8      | 2018  | 2018-08-01T00:00:00.000Z | 2.13        | 0.59        | 765     | 0.26               |
| 21246       | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z | 7      | 2018  | 2018-07-01T00:00:00.000Z | 2.26        | 0.65        | 722     | 0.96               |


---
  
**7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?**

```
WITH joint_tables AS (
  SELECT
  interest_id,
  interest_name,
  interest_summary,
  created_at,
  last_modified,
  _month,
  _year,
  month_year,
  composition,
  index_value,
  ranking,
  percentile_ranking
  FROM interest_metrics AS im
  LEFT JOIN interest_map AS i ON i.id=im.interest_id::int
  WHERE month_year<created_at)
  
  
SELECT COUNT(*) FROM joint_tables;
```

Answer:

| count |
| ----- |
| 188   |

There are 188 records where month_year value is before created_at value. 
I think these values are valid since their mont is the same and the value in the month_year column has the first day of the month but we do not know the real day of the month as we created this column by combining month and year only.

