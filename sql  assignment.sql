USE my_datasets;
SHOW tables;
select * from tips;
#Retrieve all records where the day is Sunday and the customer is a smoker.

select * from tips where day = "Sun" and smoker="Yes";

# Display the records where the tip is greater than 5 and the total bill is less than 25.

select * from tips where tip > 5 and total_bill<25;

# Get all records where the customer is female and visited during Dinner time.

select * from tips where sex = "Female" and time="Dinner";

# Show all entries where the size of the group is greater than or equal to 4 and day = 'Sat'.

select * from tips where size >= 4 and day="Sat";

# Retrieve the top 10 highest total bills using the ORDER BY and LIMIT clauses.

select * from tips order by total_bill desc limit 10;

# Display the 5 lowest tips given on Fridays using ORDER BY and LIMIT.

select * from tips where day="Fri" order by tip asc limit 5;

# Fetch all rows where the tip is between 3 and 6 and the customer is not a smoker.

select * from tips where smoker="No" and tip between 3 and 6;

# List the first 10 rows, then use OFFSET to display the next 10 rows (rows 11–20).

select * from tips limit 10 ;
select * from tips limit 10 offset 10;

# Retrieve all records where the total bill exceeds 40, order them by tip in descending order, and show only the top 5 results.

select * from tips where total_bill>40 order by tip desc limit 5;

# Get all records where the time is Lunch and the tip is greater than 20% of the total bill (use a calculated condition in the WHERE clause).

select * from tips where time="Lunch" and tip>.2*total_bill;

# Find the total number of records in the tips table.

select count(*) from tips;

# Calculate the total sum of tips given by all customers.

select sum(tip) as total_tip from tips;

# Find the average total bill amount.

select avg(total_bill) from tips;

# Determine the maximum tip and minimum tip from the dataset.

select max(tip) from tips;
select min(tip) from tips;

# Calculate the average tip given by male and female customers separately.

select avg(tip) from tips where sex="Male";
select avg(tip) from tips where sex="Female";

# Find the total number of smokers and non-smokers.

select count(smoker) from tips where smoker="Yes";
select count(smoker) from tips where smoker="No";

# Compute the average total bill per day (group by day).

select avg(total_bill) from tips group by day;

# Find the total tip amount per day and sort the result in descending order of total tips.

select sum(tip) as total_tip from tips group by day order by total_tip desc; 

# Determine the average tip percentage (tip / total\_bill \* 100) for each day.

select `day`, (tip/sum(total_bill))*100 as avg_percentage from tips group by `day`;

# Calculate the average party size for each day and time combination.

select `day`, `time`, avg(size) from tips group by `day`, `time`;
