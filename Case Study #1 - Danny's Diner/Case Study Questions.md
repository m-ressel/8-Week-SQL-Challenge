### Case Study Questions
---

**1. What is the total amount each customer spent at the restaurant?**

```
    SELECT 
    s.customer_id, 
    SUM(m.price) AS total_amount_spent
    FROM sales AS s
    JOIN menu AS m ON s.product_id = m.product_id
    GROUP BY s.customer_id
    ORDER BY s.customer_id;
```


| customer_id | total_amount_spent |
| ----------- | ------------------ |
| A           | 76                 |
| B           | 74                 |
| C           | 36                 |

---
**2. How many days has each customer visited the restaurant?**

```
    SELECT 
    customer_id, 
    COUNT(DISTINCT order_date) AS "days_count"
    FROM sales
    GROUP BY customer_id
    ORDER BY customer_id;
```

| customer_id | days_count |
| ----------- | ---------- |
| A           | 4          |
| B           | 6          |
| C           | 2          |

---
**3. What was the first item from the menu purchased by each customer?**

```
    WITH ranked_sales AS (
      SELECT *,
      DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rank
      FROM sales)
      
    SELECT 
    rs.customer_id,
    m.product_name AS first_ordered_product
    FROM ranked_sales AS rs
    JOIN menu AS m ON rs.product_id = m.product_id
    WHERE rs.rank = 1
    GROUP BY rs.customer_id, first_ordered_product
    ORDER BY rs.customer_id;
```

| customer_id | first_ordered_product |
| ----------- | --------------------- |
| A           | curry                 |
| A           | sushi                 |
| B           | curry                 |
| C           | ramen                 |

---
**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```
    SELECT 
    m.product_name, 
    COUNT(s.product_id) AS purchased_count
    FROM sales AS s
    JOIN menu AS m ON s.product_id = m.product_id
    GROUP BY m.product_name
    ORDER BY COUNT(s.order_date) DESC
    LIMIT 1;
```

| product_name | purchased_count |
| ------------ | --------------- |
| ramen        | 8               |

---
**5. Which item was the most popular for each customer?**

```
    WITH ranked_sales AS(
      SELECT
      s.customer_id, 
      m.product_name,
      COUNT(*) as bought_count,
      RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC) as order_rank
      FROM sales AS s
      JOIN menu AS m ON s.product_id = m.product_id
      GROUP BY s.customer_id, m.product_name)
      
    SELECT 
    customer_id,
    product_name,
    bought_count
    FROM ranked_sales
    WHERE order_rank=1
    ORDER BY customer_id;
```

| customer_id | product_name | bought_count |
| ----------- | ------------ | ------------ |
| A           | ramen        | 3            |
| B           | ramen        | 2            |
| B           | curry        | 2            |
| B           | sushi        | 2            |
| C           | ramen        | 3            |

Since Client B ordered the same amount of 3 items all of them are the most popular for B.

---
**6. Which item was purchased first by the customer after they became a member?**

I rank orders made after join_date basing them on the customer_id and ordering them by order_date. Then I choose the earliest one so the ones that have rank equal to 1.

```
    WITH ranked_members_order_after AS(
      SELECT
      members.join_date, 
      members.customer_id, 
      s.order_date, 
      menu.product_name, 
      DENSE_RANK() OVER (PARTITION BY members.customer_id ORDER BY s.order_date) AS order_rank
      FROM sales AS s
      JOIN menu ON s.product_id = menu.product_id
      JOIN members ON s.customer_id = members.customer_id
      WHERE order_date >= join_date)
      
    SELECT
    customer_id,
    product_name
    FROM ranked_members_order_after
    WHERE order_rank =1;
```

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| B           | sushi        |

---
**7. Which item was purchased just before the customer became a member?**

I do similar function as in the last question but I choose rows with order_date before join_date, ordering them by descending order_date and then I choose the ones that have rank equal to 1.
```
    WITH ranked_members_order_before AS(
      SELECT
      members.join_date, 
      members.customer_id, 
      s.order_date, 
      menu.product_name, 
      DENSE_RANK() OVER (PARTITION BY members.customer_id ORDER BY s.order_date DESC) AS ranked_order
      FROM sales AS s
      JOIN menu ON s.product_id = menu.product_id
      JOIN members ON s.customer_id = members.customer_id
      WHERE order_date < join_date)
      
    SELECT
    customer_id,
    product_name
    FROM ranked_members_order_before
    WHERE ranked_order = 1
    ORDER BY customer_id;
```

| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi        |
| A           | curry        |
| B           | sushi        |

Customer A ordered 2 products on their last day before becoming a member so the table chooses both of them.

---
**8. What is the total items and amount spent for each member before they became a member?**

```
    SELECT
    members.customer_id,
    COUNT(*) AS items_count, 
    SUM(menu.price) AS amount_spent
    FROM sales AS s
    JOIN menu ON s.product_id = menu.product_id
    JOIN members ON s.customer_id = members.customer_id
    WHERE s.order_date < members.join_date
    GROUP BY members.customer_id
    ORDER BY members.customer_id;
```

| customer_id | items_count | amount_spent |
| ----------- | ----------- | ------------ |
| A           | 2           | 25           |
| B           | 3           | 40           |

---
**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

```
    WITH menu_points AS (
      SELECT *, 
      CASE 
      WHEN product_name = 'sushi' THEN price * 20
      ELSE price * 10
      END AS points
      FROM menu)
      
    SELECT 
    s.customer_id, 
    SUM(mp.points) AS points
    FROM sales AS s
    JOIN menu_points AS mp ON s.product_id = mp.product_id
    GROUP BY customer_id
    ORDER BY customer_id;
```

| customer_id | points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |


Customer C has the least amount of points which is connected to the fact that they spent half as much money as the other customers.

---
**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

```
    WITH menu_points AS (
      SELECT *, 
      CASE 
      WHEN product_name = 'sushi' THEN price * 20
      ELSE price * 10
      END AS points,
      price * 20 AS bonus_points
      FROM menu),
      
    new_menu AS(
      SELECT 
      s.customer_id, 
      mp.points, 
      mp.price, 
      s.order_date,
      CASE
      WHEN s.order_date BETWEEN m.join_date AND m.join_date + INT '6' THEN mp.bonus_points
      ELSE mp.points
      END AS final_points
    FROM sales AS s
    JOIN menu_points AS mp ON s.product_id = mp.product_id
    INNER JOIN members AS m ON s.customer_id = m.customer_id
    WHERE s.order_date <= '2021-01-31')
    
    SELECT
    customer_id,
    SUM(final_points) AS sum_of_points
    FROM new_menu
    GROUP BY customer_id
    ORDER BY customer_id;
```

| customer_id | sum_of_points |
| ----------- | ------------- |
| A           | 1370          |
| B           | 820           |

---
**Bonus Question - Join All The Things**

```
    SELECT sales.customer_id, sales.order_date, menu.product_name, menu.price, CASE
      WHEN sales.order_date >= members.join_date THEN 'Y'
      WHEN members.join_date = NULL THEN 'N'
      ELSE 'N'
    END AS member FROM sales 
    LEFT JOIN members ON sales.customer_id = members.customer_id
    JOIN menu ON sales.product_id = menu.product_id;
```
| customer_id | order_date               | product_name | price | member |
| ----------- | ------------------------ | ------------ | ----- | ------ |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |
| C           | 2021-01-07T00:00:00.000Z | ramen        | 12    | N      |

---
**Bonus Question - Rank All The Things**

```
    WITH bonus_task AS (
      SELECT 
      s.customer_id, 
      s.order_date, 
      menu.product_name, 
      menu.price, 
      CASE
      WHEN s.order_date >= members.join_date THEN 'Y'
      WHEN members.join_date = NULL THEN 'N'
      ELSE 'N'
      END AS member 
      FROM sales AS s
      LEFT JOIN members ON s.customer_id = members.customer_id
      JOIN menu ON s.product_id = menu.product_id)
    
    SELECT *,
    CASE
    WHEN member = 'Y' THEN DENSE_RANK() OVER(PARTITION BY customer_id, member ORDER BY order_date)
    ELSE null 
    END AS ranking
    FROM bonus_task
    ORDER BY customer_id, order_date;
```

| customer_id | order_date               | product_name | price | member | ranking |
| ----------- | ------------------------ | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |         |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      | 1       |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |         |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |         |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |         |
| C           | 2021-01-07T00:00:00.000Z | ramen        | 12    | N      |         |
   
---
