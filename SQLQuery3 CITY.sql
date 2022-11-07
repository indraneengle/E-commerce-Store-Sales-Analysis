--PROCESSING TIME FOR CITY
select distinct c.customer_state,c.customer_city,avg(cast(datediff(day,o.order_purchase_timestamp,o.order_delivered_carrier_date) as float)) as processing_period
,datename(MONTH,o.order_delivered_carrier_date) as month,datename(year,o.order_delivered_carrier_date) as year from orders as o
inner join customers as c on c.customer_id=o.customer_id where o.order_delivered_carrier_date is not null and c.customer_state in('SP','RJ','AP','RR') group by c.customer_state,datename(MONTH,o.order_delivered_carrier_date),datename(year,o.order_delivered_carrier_date),c.customer_city

--Average lead time delivery
select distinct c.customer_state,C.customer_city,datename(month,o.order_delivered_customer_date) as month,datename(year,o.order_delivered_customer_date) as year,avg(DATEDIFF(DAY,O.order_delivered_customer_date,O.order_estimated_delivery_date))over(partition by c.customer_state,C.customer_city,datename(month,o.order_delivered_customer_date),datename(year,o.order_delivered_customer_date)) AS Avg_lead_delivery  from orders as o
inner join customers as c on c.customer_id=o.customer_id
where c.customer_state in('SP','RJ','AP','RR') and datename(month,o.order_delivered_customer_date) is not null


--order early or late
select distinct c.customer_state,c.customer_city,datename(QUARTER,o.order_delivered_customer_date) as month,datename(year,o.order_delivered_customer_date) as year,count(case when o.order_delivered_customer_date<=o.order_estimated_delivery_date then o.order_id end) early_order,
count(case when o.order_delivered_customer_date>o.order_estimated_delivery_date then o.order_id end) as late_orders,
count(o.order_id) as total_orders
from orders as o
inner join customers  as c on c.customer_id=o.customer_id where o.order_status='Delivered' and c.customer_state in ('SP','RJ','AP','RR') group by c.customer_state,datename(QUARTER,o.order_delivered_customer_date),datename(year,o.order_delivered_customer_date),c.customer_city

--CATEGORY SALES and city wise
select c.customer_state,pn.column2,c.customer_city,datename(QUARTER,o.order_delivered_customer_date) as month,datename(year,o.order_delivered_customer_date) as year,COUNT(p.product_id) count_product,sum(oi.price) Total_sum from order_items as oi 
inner join orders as o on o.order_id=oi.order_id
inner join customers as c on c.customer_id=o.customer_id
inner join products as p on p.product_id=oi.product_id
inner join productcategoryname as pn on p.product_category_name=pn.column1
where c.customer_state in ('SP','RJ','AP','RR') and datename(month,o.order_delivered_customer_date) is not null
group by c.customer_state,c.customer_city,pn.column2,datename(QUARTER,o.order_delivered_customer_date) ,datename(year,o.order_delivered_customer_date) order by c.customer_state

--Review score
select c.customer_state,c.customer_city,datename(MONTH,od.order_delivered_customer_date) as month,datename(year,od.order_delivered_customer_date) as year,avg(o.review_score) as avg_score,count(o.review_score) as count_reviews from order_items as oi
inner join orderreviews as o on o.order_id=oi.order_id
inner join orders as od on od.order_id=oi.order_id
inner join customers as c on c.customer_id=od.customer_id where datename(MONTH,od.order_delivered_customer_date) is not null and c.customer_state in ('SP','RJ','AP','RR') group by c.customer_state,c.customer_city,datename(MONTH,od.order_delivered_customer_date),datename(year,od.order_delivered_customer_date)