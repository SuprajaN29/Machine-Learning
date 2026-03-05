use retail_project;
create table online_retail (
	InvoiceNo varchar(20),
    StockCode varchar(20),
    Description text,
    Quantity int,
    InvoiceDate datetime,
    UnitPrice decimal,
    CustomerID int,
    Country varchar(100)
);
load data infile "C:\Users\91938\Desktop\Top Mentor\Assignments & projects\Python & SQL\online_retail.csv" into table online_retial fields terminated by ',' enclosed by'"' lines terminated by'\n' ignore 1 rows;

#initial data check 

select * from online_retail;

select count(*) from online_retail;

#check null customers

select count(*) from online_retail where CustomerID is null;

#check negative quantity

select count(*) from online_retail where Quantity <=0;

#check negative price

select count(*) from online_retail where UnitPrice <=0;

#data cleaning

create table retail_clean as select * from online_retail where CustomerID is not null and Quantity > 0 and UnitPrice > 0;

select count(*) from retail_clean;

########################    BUSINESS ANALYSIS   ###########################

#total revenue

select round(
sum(Quantity*UnitPrice),2
) as total_revenue from retail_clean;

#top 10 customers by revenue

select CustomerID, round(
sum(Quantity*UnitPrice),2
) as revenue from retail_clean group by CustomerID order by revenue desc limit 10;

#Country-wise revenue

select Country, round(
sum(Quantity*UnitPrice),2
) as revenue from retail_clean group by Country order by revenue desc; 

#repeat customers

select CustomerID, count(distinct InvoiceNo) as total_orders from retail_clean group by CustomerID having total_orders>1;

#daily revenue trend;

select date_format(InvoiceDate, "%Y-%m-%d") as day, round(
sum(Quantity*UnitPrice),2
) as revenue from retail_clean group by day order by day;

#monthly revenue trend

select date_format(InvoiceDate, "%Y-%m") as month, round(
sum(Quantity*UnitPrice),2
) as revenue from retail_clean group by month order by month;

#Customer Recency (Churn logic) 

select CustomerID, max(InvoiceDate) as last_purchase from retail_clean group by CustomerID;

#customers inactive for last 1 day

select CustomerID from retail_clean 
where CustomerID not in (
select distinct CustomerID from retail_clean 
where InvoiceDate >date_sub((select max(InvoiceDate) from retail_clean),interval 1 hour)
);

######################################     RFM analysis (Recency - How recently customer purchased, Frequency - How often they purchased, Monetary - How much they spend)

#RFM metrics

select CustomerID, 
datediff((select max(InvoiceDate) from retail_clean), max(InvoiceDate)) as recency,
count(distinct InvoiceNo) as frequency,
round(sum(Quantity*UnitPrice),2) as monetary 
from retail_clean 
group by CustomerID;

#customers who haven't purchased recently

select CustomerID, 
datediff((select max(InvoiceDate) from retail_clean), max(InvoiceDate)) as days_inactive, 
max(InvoiceDate) as last_purchase 
from retail_clean 
group by CustomerID 
having days_inactive>0 
order by days_inactive desc;

#top 5 customers using rank

select * from (
select CustomerID, round(sum(Quantity*UnitPrice),2) as revenue,
rank() over (order by sum(Quantity*UnitPrice) desc) as revenue_rank 
from retail_clean
group by CustomerID
) as ranked where revenue_rank<=5;

#2nd highest revenue customer

select * from (
select CustomerID, sum(Quantity*UnitPrice) as revenue, 
dense_rank() over (order by sum(Quantity*UnitPrice) desc) as rnk 
from retail_clean 
group by CustomerID
) as ranked where rnk=2;

#top customer in each country

select * from (
select Country, CustomerID, round(sum(Quantity*UnitPrice),2) as revenue,
rank() over (partition by Country order by sum(Quantity*UnitPrice) desc) as revenue_rank 
from retail_clean
group by COuntry, CustomerID
) as ranked where revenue_rank=1;


#running daily revenue

select day,revenue,sum(revenue) over (order by day) as running_total from
(select date_format(InvoiceDate, '%Y-%m-%d') as day, sum(Quantity*UnitPrice) as revenue from retail_clean group by day) daily;

#customers who purchased more than avg customer revenue

select CustomerID, round(sum(Quantity*UnitPrice),2) as customer_revenue 
from retail_clean 
group by CustomerID
having customer_revenue > (select avg(revenue) from 
(select round(sum(Quantity*UnitPrice),2) as revenue from retail_clean group by CustomerID) 
as avg_revenue);

#day with highest growth

select * from (select day,revenue,revenue-lag(revenue) over (order by day) as growth from
(select date_format(InvoiceDate, '%Y-%m-%d') as day, sum(Quantity*UnitPrice) as revenue from retail_clean group by day) daily ) growth_table 
order by growth desc
limit 1;


#customers who placed more orders than the average number of orders per customer

select CustomerID, count(distinct InvoiceNo) as orders 
from retail_clean 
group by CustomerID
having orders > (select avg(total_orders) from 
(select count(distinct InvoiceNo) as total_orders from retail_clean group by CustomerID) 
as avg_orders);

