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
    SELECT customer_id, SUM(amount) AS total_spent FROM sales GROUP BY customer_id;
    ```
    ![Total Amount Spent](screenshots/total_amount_spent.png)

2. **Number of Days Each Customer Visited the Restaurant**
    ```sql
    SELECT customer_id, COUNT(DISTINCT purchase_date) AS visit_days FROM sales GROUP BY customer_id;
    ```
    ![Visit Days](screenshots/visit_days.png)

3. **First Item Purchased by Each Customer**
    ```sql
    SELECT customer_id, MIN(purchase_date) AS first_purchase_date, FIRST_VALUE(menu_item) OVER (PARTITION BY customer_id ORDER BY purchase_date) AS first_purchased_item FROM sales GROUP BY customer_id;
    ```
    ![First Purchased Item](screenshots/first_purchased_item.png)

4. **Most Purchased Item and Its Frequency**
    ```sql
    SELECT menu_item, COUNT(menu_item) AS purchase_count FROM sales GROUP BY menu_item ORDER BY purchase_count DESC LIMIT 1;
    ```
    ![Most Purchased Item](screenshots/most_purchased_item.png)

5. **Most Popular Item for Each Customer**
    ```sql
    SELECT customer_id, menu_item, COUNT(menu_item) AS purchase_count FROM sales GROUP BY customer_id, menu_item ORDER BY purchase_count DESC LIMIT 1;
    ```
    ![Most Popular Item](screenshots/most_popular_item.png)

6. **First Item Purchased After Joining by Each Member**
    ```sql
    SELECT m.customer_id, m.join_date, s.menu_item FROM members m LEFT JOIN sales s ON m.customer_id = s.customer_id AND s.purchase_date > m.join_date ORDER BY m.customer_id, s.purchase_date LIMIT 1;
    ```
    ![First Item After Joining](screenshots/first_item_after_joining.png)

7. **Item Purchased Just Before Joining for Each Member**
    ```sql
    SELECT m.customer_id, m.join_date, s.menu_item FROM members m LEFT JOIN sales s ON m.customer_id = s.customer_id AND s.purchase_date < m.join_date ORDER BY m.customer_id, s.purchase_date DESC LIMIT 1;
    ```
    ![Item Before Joining](screenshots/item_before_joining.png)

8. **Total Items and Amount Spent Before Joining for Each Member**
    ```sql
    SELECT m.customer_id, COUNT(s.menu_item) AS total_items, SUM(s.amount) AS total_amount FROM members m LEFT JOIN sales s ON m.customer_id = s.customer_id AND s.purchase_date < m.join_date GROUP BY m.customer_id;
    ```
    ![Total Items Before Joining](screenshots/total_items_before_joining.png)

9. **Points Calculation Based on Spending**
    ```sql
    SELECT customer_id, SUM(amount) * 10 + CASE WHEN menu_item = 'sushi' THEN SUM(amount) ELSE 0 END * 10 AS total_points FROM sales GROUP BY customer_id, menu_item;
    ```
    ![Points Calculation](screenshots/points_calculation.png)

10. **Points Earned by Customers A and B in January**
    ```sql
    SELECT customer_id, SUM(CASE WHEN purchase_date >= '2023-01-01' AND purchase_date <= '2023-01-07' THEN amount * 10 * 2 ELSE amount * 10 END) AS total_points FROM sales WHERE customer_id IN ('A', 'B') GROUP BY customer_id;
    ```
    ![Points in January](screenshots/points_in_january.png)

## Conclusion

This documentation provides a comprehensive overview of the SQL project for Danny's Diner, including the datasets, case study questions, SQL queries, and corresponding results. The screenshots enhance the clarity of the project's execution and make it easy for the team to review and understand the findings.
