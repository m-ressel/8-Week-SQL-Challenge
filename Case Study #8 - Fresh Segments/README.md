# Case Study #8 - Fresh Segments

![alt_ext](https://8weeksqlchallenge.com/images/case-study-designs/8.png)

### Introduction

Danny created Fresh Segments, a digital marketing agency that helps other businesses analyse trends in online ad click behaviour for their unique customer base.

Clients share their customer lists with the Fresh Segments team who then aggregate interest metrics and generate a single dataset worth of metrics for further analysis.

In particular - the composition and rankings for different interests are provided for each client showing the proportion of their customer list who interacted with online assets related to each interest for each month.

Danny has asked for your assistance to analyse aggregated metrics for an example client and provide some high level insights about the customer list and their interests.

### Available Data

For this case study there is a total of 2 datasets which you will need to use to solve the questions.

```interest_metrics``` contains information about aggregated interest metrics for a specific major client of Fresh Segments which makes up a large proportion of their customer base.

Each record in this table represents the performance of a specific ```interest_id``` based on the client’s customer base interest measured through clicks and interactions with specific targeted advertising content.

For example - let’s interpret the first row of the ```interest_metrics``` table together:

|month | _year | month_year	| interest_id |	composition	| index_value |	ranking |	percentile_ranking |
|------|-------|------------|-------------|-------------|-------------|---------|--------------------|
| 7	   | 2018  | 07-2018 	  | 32486	      | 11.89       | 6.19	      |1	      | 99.86              |


In July 2018, the ```composition``` metric is 11.89, meaning that 11.89% of the client’s customer list interacted with the interest ```interest_id``` = 32486 - we can link ```interest_id``` to a separate mapping table to find the segment name called “Vacation Rental Accommodation Researchers”

The ```index_value``` is 6.19, means that the ```composition``` value is 6.19x the average composition value for all Fresh Segments clients’ customer for this particular interest in the month of July 2018.

The ```ranking``` and ```percentage_ranking``` relates to the order of ```index_value``` records in each month year.

```interest_map``` links the ```interest_id``` with their relevant interest information. You will need to join this table onto the previous ```interest_details``` table to obtain the ```interest_name``` as well as any details about the summary information.

### Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/128125991/232539342-84c25744-a1d9-4709-8e96-9dc409f56f67.png)

### Questions

<details><summary>A. Data Exploration and Cleansing </summary>
  
  1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month
  2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
  3. What do you think we should do with these null values in the fresh_segments.interest_metrics
  4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?
  5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table
  6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.
  7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?
  
</details>

<details><summary>B. Interest Analysis </summary>

  1. Which interests have been present in all month_year dates in our dataset?
  2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?
  3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?
  4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.
  5. After removing these interests - how many unique interests are there for each month?
  
</details>

<details><summary>C. Segment Analysis </summary>

  1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year
  2. Which 5 interests had the lowest average ranking value?
  3. Which 5 interests had the largest standard deviation in their percentile_ranking value?
  4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?
  5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?
  
</details>
