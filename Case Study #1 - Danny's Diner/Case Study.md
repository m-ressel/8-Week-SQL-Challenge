### Case Study Questions

1. What is the total amount each customer spent at the restaurant?

```
    SELECT 
    dannys_diner.sales.customer_id, 
    SUM(menu.price) AS total_amount_spent
    FROM dannys_diner.sales
    JOIN dannys_diner.menu ON dannys_diner.sales.product_id = dannys_diner.menu.product_id
    GROUP BY dannys_diner.sales.customer_id
    ORDER BY dannys_diner.sales.customer_id;
```

| customer_id | total_amount_spent |
| ----------- | ------------------ |
| B           | 74                 |
| C           | 36                 |
| A           | 76                 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/2rM8RAnq7h5LLDTzZiRWcd/138)

How many days has each customer visited the restaurant?
What was the first item from the menu purchased by each customer?
What is the most purchased item on the menu and how many times was it purchased by all customers?
Which item was the most popular for each customer?
Which item was purchased first by the customer after they became a member?
Which item was purchased just before the customer became a member?
What is the total items and amount spent for each member before they became a member?
If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
