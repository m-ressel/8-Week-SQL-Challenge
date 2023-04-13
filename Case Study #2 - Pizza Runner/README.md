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

Customer pizza orders are captured in the **customer_orders** table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza. Customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

After each orders are received through the system, they are assigned to a runner and captured in **runner_orders** table, however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

**Table 4: pizza_names** maps pizza's id number to its name.

**Table 5: pizza_recipes** - each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

**Table 6: pizza_toppings** contains all of the topping_name values with their corresponding topping_id value.

Danny has prepared an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/230937161-eecb482c-3d98-45dc-b817-40488e05e755.png)
