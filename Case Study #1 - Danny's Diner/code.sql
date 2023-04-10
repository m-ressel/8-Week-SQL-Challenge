CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
s.customer_id, 
SUM(m.price) AS total_amount_spent
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT 
customer_id, 
COUNT(DISTINCT order_date ) AS "days_count"
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?

-- numbering orders in the order in which they were placed
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

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
m.product_name, 
COUNT(s.product_id) AS purchased_count
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.order_date) DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

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

-- 6. Which item was purchased first by the customer after they became a member?

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

-- 7. Which item was purchased just before the customer became a member?

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

-- 8. What is the total items and amount spent for each member before they became a member?

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

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

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

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

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

-- Rank All The Things

SELECT 
s.customer_id, 
to_char(s.order_date, 'YYYY-MM-DD') AS order_date, 
menu.product_name, 
menu.price, 
CASE
WHEN s.order_date >= members.join_date THEN 'Y'
WHEN members.join_date = NULL THEN 'N'
ELSE 'N'
END AS member 
FROM sales AS s
LEFT JOIN members ON s.customer_id = members.customer_id
JOIN menu ON s.product_id = menu.product_id;

-- Join All The Things

WITH bonus_task AS (
  SELECT 
  s.customer_id, 
  to_char(s.order_date, 'YYYY-MM-DD') AS order_date, 
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
