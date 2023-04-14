# Case Study #2 - Pizza Runner

![alt_ext](https://8weeksqlchallenge.com/images/case-study-designs/2.png)

### Introduction

Did you know that over **115 million kilograms** of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


### Available Data

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

**Table 1: runners** shows the registration_date for each new runner.

Customer pizza orders are captured in **table 2: customer_orders** with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza. Customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

After each orders are received through the system, they are assigned to a runner and captured in **table 3: runner_orders**, however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

**Table 4: pizza_names** maps pizza's id number to its name.

**Table 5: pizza_recipes** - each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

**Table 6: pizza_toppings** contains all of the topping_name values with their corresponding topping_id value.

Danny has prepared an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/230937161-eecb482c-3d98-45dc-b817-40488e05e755.png)

### Questions

<details><summary>A. Pizza Metrics</summary>

  1. How many pizzas were ordered?
  2. How many unique customer orders were made?
  3. How many successful orders were delivered by each runner?
  4. How many of each type of pizza was delivered?
  5. How many Vegetarian and Meatlovers were ordered by each customer?
  6. What was the maximum number of pizzas delivered in a single order?
  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
  8. How many pizzas were delivered that had both exclusions and extras?
  9. What was the total volume of pizzas ordered for each hour of the day?
  10. What was the volume of orders for each day of the week?
  
</details>

<details><summary>B. Runner and Customer Experience</summary>

  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
  4. What was the average distance travelled for each customer?
  5. What was the difference between the longest and shortest delivery times for all orders?
  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
  7. What is the successful delivery percentage for each runner?
  
</details>


<details><summary>C. Ingredient Optimisation</summary>

  1. What are the standard ingredients for each pizza?
  2. What was the most commonly added extra?
  3. What was the most common exclusion?
  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
  <ul><li>Meat Lovers</li>
    <li>Meat Lovers - Exclude Beef</li>
    <li>Meat Lovers - Extra Bacon</li>
    <li>Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers</li></ul>
  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients. For example: For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
  
</details>

<details><summary>D. Pricing and Ratings</summary>

  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
  2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra.
  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
  4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
<ul><li>customer_id</li>
<li>order_id</li>
<li>runner_id</li>
<li>rating</li>
<li>order_time</li>
<li>pickup_time</li>
<li>Time between order and pickup</li>
<li>Delivery duration</li>
<li>Average speed</li>
<li>Total number of pizzas</li></ul>
  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
  
</details>



