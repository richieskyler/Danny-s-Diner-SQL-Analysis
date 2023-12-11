# Danny's Diner SQL Project Documentation

## Introduction

Danny seriously loves Japanese food, so at the beginning of 2021, he decided to embark upon a risky venture and opened up a cute little restaurant that sells his three favorite foods: sushi, curry, and ramen. Danny’s Diner is in need of your assistance to help the restaurant stay afloat. The restaurant has captured some very basic data from their few months of operation but has no idea how to use their data to help them run the business.

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent, and also which menu items are their favorite. Having this deeper connection with his customers will help him deliver a better and more personalized experience for his loyal customers. He plans on using these insights to help him decide whether he should expand the existing customer loyalty program. Additionally, he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues. Still, he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions! Danny has shared with you three key datasets for this case study: sales, menu, and members.

## Case Study Questions

Each of the following case study questions can be answered using a single SQL statement:

1. **Total Amount Spent by Each Customer**
    ```sql
    SELECT customer_id, SUM(amount) AS total_spent FROM sales GROUP BY customer_id;select s.customer_id , sum(m.price) Total_amount_spent
	from sales s
	join menu m on m.product_id = s.product_id
    group by s.customer_id;
    ```
    ![Total Amount Spent](screenshots/total_amount_spent.png)

2. **Number of Days Each Customer Visited the Restaurant**
    ```sql
   select customer_id, count(distinct order_date) as no_of_days_vistited
	from sales
    group by customer_id
    order by no_of_days_vistited desc;
    ```
    ![Visit Days](screenshots/visit_days.png)

3. **First Item Purchased by Each Customer**
    ```sql
   with first_purchase (customer_id, first_purchase_date)
		as
			(select customer_id, min(order_date) as first_purchase_date 
				from sales 
				group by customer_id)
	select first_purchase.customer_id, first_purchase.first_purchase_date, m.product_name 
		from first_purchase
		join sales s on s.customer_id= first_purchase.customer_id AND s.order_date = first_purchase.first_purchase_date
		join menu m on m.product_id = s.product_id;
    ```
    ![First Purchased Item](screenshots/first_purchased_item.png)

4. **Most Purchased Item and Its Frequency**
    ```sql
   select product_name, count(m.product_name) as purchased_freq
	from sales s
    join menu m on m.product_id = s.product_id
    group by product_name
    order by purchased_freq desc
    limit 1;

    ```
    ![Most Purchased Item](screenshots/most_purchased_item.png)

5. **Most Popular Item for Each Customer**
    ```sql
    with product_freq 
	as
	(select s.customer_id, m.product_name, count(m.product_name) as freq
		from sales s
		join menu m on m.product_id = s.product_id
		group by customer_id, product_name)
select pf.customer_id, pf.product_name, max(pf.freq)
	from product_freq pf
join
	(select customer_id, max(freq) as sales_no
		from product_freq
		group by customer_id) max_freq on pf.customer_id = max_freq.customer_id AND pf.freq = max_freq.sales_no
        group by pf.customer_id, pf.product_name;
    ```
    ![Most Popular Item](screenshots/most_popular_item.png)

6. **First Item Purchased After Joining by Each Member**
    ```sql
    with cte
	as
	(select s.customer_id,m.product_name, min(s.order_date) as member_date
		from sales s
		join members mb on mb.customer_id = s.customer_id
		join menu 	 m  on m.product_id   = s.product_id
		where s.order_date >= mb.join_date
		group by s.customer_id, m.product_name)
select cte.customer_id, cte.product_name, cte.member_date
	from cte
join
	(select customer_id, min(member_date) as min_join_date
		from cte
		group by customer_id) members on cte.customer_id = members.customer_id and cte.member_date = members.min_join_date
        group by cte.customer_id, cte.product_name
        order by customer_id;s.purchase_date LIMIT 1;
    ```
    ![First Item After Joining](screenshots/first_item_after_joining.png)

7. **Item Purchased Just Before Joining for Each Member**
    ```sql
    with cte
	as
	(select s.customer_id,m.product_name,mb.join_date, s.order_date, rank() over(partition by s.customer_id order by s.order_date DESC) as cust_rank
		from sales s
		join members mb on mb.customer_id = s.customer_id
		join menu 	 m  on m.product_id   = s.product_id
		where s.order_date < mb.join_date
		)
select customer_id, product_name, order_date, join_date
	from cte
    where cust_rank = 1;
    ```
    ![Item Before Joining](screenshots/item_before_joining.png)

8. **Total Items and Amount Spent Before Joining for Each Member**
    ```sql
    SELECT m.customer_id, COUNT(s.menu_item) AS total_items, SUM(s.amount) AS total_amount FROM members m LEFT JOIN sales s ON m.customer_id = s.customer_id AND s.purchase_date < m.join_date GROUP BY m.customer_id;select s.customer_id, count(s.product_id) as total_item, sum(m.price) as total_amount
		from sales s
		join members mb on mb.customer_id = s.customer_id
		join menu 	 m  on m.product_id   = s.product_id
		where s.order_date < mb.join_date
		group by s.customer_id
        order by customer_id;
    ```
    ![Total Items Before Joining](screenshots/total_items_before_joining.png)

9. **Points Calculation Based on Spending**
    ```sql
   select customer_id, 
		sum(
			case when product_name = 'sushi' then price*20
				 else price*10
			end) as points
from sales
		left join menu 
		using (product_id)
        group by customer_id;
    ```
    ![Points Calculation](screenshots/points_calculation.png)

10. **Points Earned by Customers A and B in January**
    ```sql
select s.customer_id, 
		sum(
			case 
				 when s.order_date between mb.join_date and date_add(mb.join_date, interval 7 day) then price*20
				 else price*10
		    end)  as points
from sales s
		left join menu m using (product_id)
        left join members mb using (customer_id)
        where s.order_date between '2021-01-01' and '2021-01-31' and s.customer_id in ('A' , 'B')
        group by s.customer_id;

SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN mem.join_date AND DATE_ADD(mem.join_date, INTERVAL 7 DAY) THEN price * 20
            WHEN MONTH(s.order_date) = 1 AND YEAR(s.order_date) = 2021 THEN price * 10
            ELSE 0
        END
    ) AS points
FROM
    sales s
    LEFT JOIN menu m ON s.product_id = m.product_id
    LEFT JOIN members mem ON s.customer_id = mem.customer_id
WHERE
    s.customer_id IN ('A', 'B') AND
    (s.order_date BETWEEN '2021-01-01' AND '2021-01-31') -- Filter for January 2021
GROUP BY
    s.customer_id;
    ```
    ![Points in January](screenshots/points_in_january.png)

## Conclusion

This documentation provides a comprehensive overview of the SQL project for Danny's Diner, including the datasets, case study questions, SQL queries, and corresponding results. The screenshots enhance the clarity of the project's execution and make it easy for the team to review and understand the findings.
