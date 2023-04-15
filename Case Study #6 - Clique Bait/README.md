# Case Study #6 - Clique Bait

![alt_ext](https://8weeksqlchallenge.com/images/case-study-designs/6.png)

### Introduction

Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!

In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.


### Available Data

For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.

Table **users** contains inforation on customers who visit the Clique Bait website as they are tagged via their ```cookie_id```.

Customer visits are logged in **events** table at a ```cookie_id``` level and the ```event_type``` and ```page_id``` values can be used to join onto relevant satellite tables to obtain further information about each event. The ```sequence_number``` is used to order the events within each visit.

The ```event_identifier``` table shows the types of events which are captured by Clique Bait’s digital data systems.

```campain_identifier``` table shows information for the 3 campaigns that Clique Bait has ran on their website so far in 2020.

Table ```page_hierarchy``` lists all of the pages on the Clique Bait website which are tagged and have data passing through from user interaction events.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/232244357-4be5bea6-3454-4ed2-8b09-379c15addb2d.png)

### Questions

<details><summary>A. Digital Analysis </summary>

  1. How many users are there?
  2. How many cookies does each user have on average?
  3. What is the unique number of visits by all users per month?
  4. What is the number of events for each event type?
  5. What is the percentage of visits which have a purchase event?
  6. What is the percentage of visits which view the checkout page but do not have a purchase event?
  7. What are the top 3 pages by number of views?
  8. What is the number of views and cart adds for each product category?
  9. What are the top 3 products by purchases?
  
</details>

<details><summary>B. Product Funnel Analysis </summary>

  In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
 
Using a single SQL query - create a new output table which has the following details:

  <ul><li>How many times was each product viewed?</li>
  <li>How many times was each product added to cart?</li>
  <li>How many times was each product added to a cart but not purchased (abandoned)?</li>
  <li>How many times was each product purchased?</li></ul>

Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

Use your 2 new output tables - answer the following questions:

  1. Which product had the most views, cart adds and purchases?
  2. Which product was most likely to be abandoned?
  3. Which product had the highest view to purchase percentage?
  4. What is the average conversion rate from view to cart add?
  5. What is the average conversion rate from cart add to purchase?

</details>

<details><summary>C. Campaigns Analysis </summary>

Generate a table that has 1 single row for every unique visit_id record and has the following columns:

<ul><li>`user_id`</li>
  <li>`visit_it`</li>
  <li>`visit_start_time`: the earliest event_time for each visit</li>
  <li>`page_views`: count of page views for each visit</li>
  <li>`cart_adds`: count of product cart add events for each visit</li>
  <li>`purchase`: 1/0 flag if a purchase event exists for each visit</li>
  <li>`campaign_name`: map the visit to a campaign if the ```visit_start_time``` falls between the ```start_date``` and ```end_date```</li>
  <li>`impression`: count of ad impressions for each visit</li>
  <li>`click`: count of ad clicks for each visit</li>
  <li>(Optional column) `cart_products`: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the `sequence_number`)</li></ul>

  
</details>
