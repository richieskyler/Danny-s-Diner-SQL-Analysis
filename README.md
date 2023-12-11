<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danny's Diner SQL Project Documentation</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 20px;
        }

        h1, h2, h3 {
            color: #333;
        }

        code {
            background-color: #f2f2f2;
            padding: 2px 4px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
        }

        img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-top: 10px;
        }
    </style>
</head>

<body>

    <h1>Danny's Diner SQL Project Documentation</h1>

    <h2>Introduction</h2>

    <p>Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry, and ramen. Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.</p>

    <p>Problem Statement: Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.</p>

    <p>Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions! Danny has shared with you 3 key datasets for this case study: sales, menu, and members.</p>

    <h2>Case Study Questions</h2>

    <!-- Question 1 -->
    <h3>1. Total Amount Spent by Each Customer</h3>
    <p>Query: <code>SELECT customer_id, SUM(amount) AS total_spent FROM sales GROUP BY customer_id;</code></p>
    <img src="screenshots/total_amount_spent.png" alt="Total Amount Spent">

    <!-- Question 2 -->
    <h3>2. Number of Days Each Customer Visited the Restaurant</h3>
    <p>Query: <code>SELECT customer_id, COUNT(DISTINCT purchase_date) AS visit_days FROM sales GROUP BY customer_id;</code></p>
    <img src="screenshots/visit_days.png" alt="Visit Days">

    <!-- Repeat for each question -->

    <h2>Screenshots</h2>

    <!-- Screenshots are already included after each corresponding query -->

    <h2>Conclusion</h2>

    <p>This documentation provides a comprehensive overview of the SQL project for Danny's Diner, including the datasets, case study questions, SQL queries, and corresponding results. The screenshots enhance the clarity of the project's execution and make it easy for the team to review and understand the findings.</p>

</body>

</html>
