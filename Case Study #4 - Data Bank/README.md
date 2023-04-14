# Case Study #4 - Data Bank

![alt_ext](https://8weeksqlchallenge.com/images/case-study-designs/4.png)

### Introduction

There is a new innovation in the financial industry called Neo-Banks: new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments

### Available Data

**Table 1: Regions** contains the region_id and their respective region_name values.

**Table 2: Customer Nodes** - customers are randomly distributed across the nodes according to their region - this also specifies exactly which node contains both their cash and data. This random distribution changes frequently to reduce the risk of hackers getting into Data Bank’s system and stealing customer’s money and data!

**Table 3: Customer Transactions** stores all customer deposits, withdrawals and purchases made using their Data Bank debit card.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/231859889-6ff9cc8f-d8e0-4db7-a741-55aafe9b2929.png)

### Questions

<details><summary>A. Customer Nodes Exploration</summary>

  1. How many unique nodes are there on the Data Bank system?
  2. What is the number of nodes per region?
  3. How many customers are allocated to each region?
  4. How many days on average are customers reallocated to a different node?
  5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
  
</details>

<details><summary>B. Customer Transactions</summary>

  1. What is the unique count and total amount for each transaction type?
  2. What is the average total historical deposit counts and amounts for all customers?
  3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
  4. What is the closing balance for each customer at the end of the month?
  5. What is the percentage of customers who increase their closing balance by more than 5%?
  
</details>

