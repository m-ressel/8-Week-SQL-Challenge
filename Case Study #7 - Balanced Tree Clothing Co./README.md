# Case Study #7 - Balanced Tree Clothing Co.

![alt_ext](https://8weeksqlchallenge.com/images/case-study-designs/7.png)

### Introduction

Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.

### Available Data

For this case study there is a total of 4 datasets for this case study - however you will only need to utilise 2 main tables to solve all of the regular questions, and the additional 2 tables are used only for the bonus challenge question!
 
```product_details``` includes all information about the entire range that Balanced Clothing sells in their store like product_id, price, product_name, category_id and segment_id

```sales``` contains product level information for all the transactions made for Balanced Tree including quantity, price, percentage discount, member status, a transaction ID and also the transaction timestamp.

Tables ```product_hierarchy``` & ```product_prices``` are used only for the bonus question where we will use them to recreate ```product_details``` table.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/232291280-00c8e834-4845-4899-909b-2cbeb2a9505b.png)

### Questions

<details><summary>A. High Level Sales Analysis </summary>
  
  1. What was the total quantity sold for all products?
  2. What is the total generated revenue for all products before discounts?
  3. What was the total discount amount for all products?
  
</details>

<details><summary>B. Transaction Analysis </summary>

  1. How many unique transactions were there?
  2. What is the average unique products purchased in each transaction?
  3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
  4. What is the average discount value per transaction?
  5. What is the percentage split of all transactions for members vs non-members?
  6. What is the average revenue for member transactions and non-member transactions? 
  
</details>

<details><summary>C. Product Analysis </summary>

  1. What are the top 3 products by total revenue before discount?
  2. What is the total quantity, revenue and discount for each segment?
  3. What is the top selling product for each segment?
  4. What is the total quantity, revenue and discount for each category?
  5. What is the top selling product for each category?
  6. What is the percentage split of revenue by product for each segment?
  7. What is the percentage split of revenue by segment for each category?
  8. What is the percentage split of total revenue by category?
  9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
  10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
  
</details>
