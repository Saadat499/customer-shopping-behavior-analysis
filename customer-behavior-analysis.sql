select * from customer limit 20

--1. Total revenue by male and female customers
select gender, SUM(purchase_amount) as revenue
from customer
group by gender

--2. Which customers used a discount but still spent more than average purchase amount?
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

--3. Which are the top 5 products with the highest average review rating?
select item_purchased, ROUND(AVG(review_rating :: numeric), 2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--4. Compare the average purchase amounts between standard and express shipping.
select shipping_type, ROUND(AVG(purchase_amount), 2)
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type

--5. Do subscribed customers spend more? Compare average spend and total revenue
-- between subscribers and non-subscribers.
select subscription_status, COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount), 2) as average_spend,
ROUND(SUM(purchase_amount), 2) as total_revenue
from customer
group by subscription_status
order by total_revenue, average_spend desc;

--6. Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased, COUNT(*) as total_purchases,
COUNT(*) FILTER (WHERE discount_applied = 'Yes') as discounted_purchases,
ROUND(100.0 * COUNT(*) FILTER (WHERE discount_applied = 'Yes') / COUNT(*), 2) as discount_rate
from customer
group by item_purchased
order by discount_percentage desc
limit 5;

--7. Segment customers into New, Returning, and Loyal based on their total number of previous
-- purchases, and show the count of each segment.
with customer_type as (
select customer_id, previous_purchases,
CASE 
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
from customer
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment

--8. What are the top 3 most purchased products within each category?
with item_counts as (
select category, item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3

--9. Are customers who repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status, COUNT(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--10. What is the revenue contribution of each group?
select age_group, SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc

