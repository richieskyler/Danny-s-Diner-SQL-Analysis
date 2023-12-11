-- 											DANNY'S DINER

-- 											INTRODUCTION
-- Danny's diner is a little resturant that sells 3 of his favorite japanese food Sushi, Curry and Ramen.

-- 										  PROBLEM STATEMENT
-- Danny wants to answers some questions about his customers, visting patterns, how much they have spent so far, and which items are their favorite.
-- This insights will help him decide whether he should expand the exixting loyaty program.

-- 											NOTE
-- Danny has provided you with a sample of his overall customer data due to privacy issues, but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!
/*
-- Inserting the sample data into the required table

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);



INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  */
  
-- 											  ANALYSIS
-- 1. WHAT IS THE TOTAL AMOUNT EACH CUSTOMERS SPENT AT THE RESTURANT?
select s.customer_id , sum(m.price) Total_amount_spent
	from sales s
	join menu m on m.product_id = s.product_id
    group by s.customer_id;
    
-- 2. HOW MANY DAYS HAS EACH CUSTOMERS VISTED THE RESTURANT?
select customer_id, count(distinct order_date) as no_of_days_vistited
	from sales
    group by customer_id
    order by no_of_days_vistited desc;
    
    
-- 3. WHAT WAS THE FIRST ITEM FROM THE MENU PHURCAHSED BY EACH CUSTOMER?
    with first_purchase (customer_id, first_purchase_date)
		as
			(select customer_id, min(order_date) as first_purchase_date 
				from sales 
				group by customer_id)
	select first_purchase.customer_id, first_purchase.first_purchase_date, m.product_name 
		from first_purchase
		join sales s on s.customer_id= first_purchase.customer_id AND s.order_date = first_purchase.first_purchase_date
		join menu m on m.product_id = s.product_id;
                    
-- 4. WHAT IS THE MOST PURCHASED ITEM ON THE MENU AND HOW MANY TIMES WHAT IT PURCHASED BY ALL CUSTOMERS?

select product_name, count(m.product_name) as purchased_freq
	from sales s
    join menu m on m.product_id = s.product_id
    group by product_name
    order by purchased_freq desc
    limit 1;
    
-- 5 WHICH ITEM IS THE MOST POPUPLAR FOR EACH CUSTOMER?

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
	
-- 6. WHICH ITEM WAS PURCHASED BY THE CUSTOMER AFTER THEY BECAME A MEMBER?
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
        order by customer_id;

/*with cte
	as
	(select s.customer_id,m.product_name, s.order_date, rank() over(partition by s.customer_id order by s.order_date) as cust_rank
		from sales s
		join members mb on mb.customer_id = s.customer_id
		join menu 	 m  on m.product_id   = s.product_id
		where s.order_date >= mb.join_date
		)
select customer_id, product_name, order_date 
	from cte
    where cust_rank = 1
*/

-- 7. WHICH ITEM WAS PURCHASED JUST BEFORE THEY BECAME MEMBERS?
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
    
-- 8. WHAT IS THE TOTAL ITEM AND AMOUNT SPENT FOR EACH CUSTOMER BEFORE THEY BECAME A MEMBER?

	select s.customer_id, count(s.product_id) as total_item, sum(m.price) as total_amount
		from sales s
		join members mb on mb.customer_id = s.customer_id
		join menu 	 m  on m.product_id   = s.product_id
		where s.order_date < mb.join_date
		group by s.customer_id
        order by customer_id;

-- 9. IF $1 EQAUTES TO 10 POINTS AND SUSHI HAS 2X POINTS MULTIPLIER, HOW MANY POINTS WOULD EACH CUSTOMER HAVE?

select customer_id, 
		sum(
			case when product_name = 'sushi' then price*20
				 else price*10
			end) as points
from sales
		left join menu 
		using (product_id)
        group by customer_id;
    
-- 10. IN THE FIRST WEEK AFTER A CUSTOMER JOINS THE PROGRAM (INCLUDING THEIR JOIN DATE) THEY EARN 2X POINTS ON ALL ITEMS, NOT JUST SUSHI, HOW MANY POINTS DO CUSTOMER A AND B HAVE AT THE END OF JANUARY?

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




