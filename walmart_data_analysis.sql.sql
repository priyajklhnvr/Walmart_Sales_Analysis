SELECT * FROM walmart ;
SELECT COUNT(*) FROM walmart;

UPDATE walmart
SET unit_price = REPLACE(unit_price, '$', '');

ALTER table walmart ADD Total DECIMAL(10,2);

UPDATE walmart
SET Total = unit_price * quantity;


/* 1. Analyze Payment Method and sales*/ 
SELECT 
     DISTINCT payment_method, 
	 COUNT(*) AS Transaction ,
     sum(quantity) as quantity_sold
 FROM walmart
 group by payment_method
 order by Transaction DESC;
 
 
  select distinct category from walmart;

/* 2. Highest-Rated Category in each branch*/
 SELECT *
 FROM
   ( SELECT branch,
        category, 
        AVG(rating) as avg_rating,
 RANK() OVER(partition by branch order by AVG(rating) DESC) as Ranking
 FROM walmart
 group by branch , category
 ) as subquery
 WHERE Ranking = 1;

 
 
 /* 3. Top selling Branch*/
 SELECT branch, Total as total_sales
 from walmart
 order by total_sales DESC
 limit 1;
 
 /* 4. Identify city generates the highest profit.*/
 SELECT city, 
        SUM(Total * profit_margin / 100) as total_profit
 FROM walmart
 GROUP BY city
 ORDER BY total_profit DESC
 LIMIT 5;
 
 /* 5. Total Profit and Revenue for each Category*/
 SELECT category,
         sum(Total) as total_revenue,
         sum(Total * profit_margin) as Total_Profit
 FROM walmart
 GROUP BY category
 ORDER BY Total_Profit DESC;
 
 /* 6. Busiest day of the week for each branch based on Transaction*/
 
 SELECT *
 FROM
 (    SELECT branch,
        date_format(STR_TO_DATE(date,'%d-%m-%y'), '%W') AS Day_Name,
        COUNT(*) as no_Transaction,
        RANK() OVER(partition by branch order by COUNT(*) DESC) as Ranking
 FROM walmart
 GROUP BY branch,Day_Name
 ) as subquery
 WHERE Ranking = 1;
 
 
 /* 7. branch with the highest sales in 2022*/
 
 SELECT Branch, 
        MAX(STR_TO_DATE(date, '%Y-%m-%d')) AS latest_date,
       SUM(Total) AS total_sales 
FROM walmart
WHERE YEAR(STR_TO_DATE(date, '%Y-%m-%d')) = 2022
GROUP BY Branch
ORDER BY total_sales DESC
LIMIT 3;


/* 8. Categorize sales into Morning, Afternoon, and Evening shifts*/

SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

/* 9. Determine the average, minimum, and maximum rating of categories for each city*/
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;


/* 10. Categories have the highest and lowest sales volumes? */
(SELECT category,
       SUM(Total) AS Highest_and_Lowest_Sales
FROM walmart
GROUP BY category
ORDER BY   Highest_and_Lowest_Sales DESC
LIMIT 1 )
UNION ALL
(SELECT category,
       SUM(Total) AS Highest_and_Lowest_Sales
FROM walmart
GROUP BY category
ORDER BY   Highest_and_Lowest_Sales ASC
LIMIT 1 ) ;


/* 11. Analyze Customer Dissatisfaction by Time Period*/

SELECT 
    CASE 
        WHEN HOUR(TIME(time)) BETWEEN 0 AND 6 THEN 'Midnight to Early Morning'
        WHEN HOUR(TIME(time)) BETWEEN 7 AND 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 13 AND 17 THEN 'Afternoon'
        WHEN HOUR(TIME(time)) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_period,
    AVG(rating) AS avg_rating,                 
    COUNT(*) AS total_transactions             
FROM 
    walmart
GROUP BY 
    time_period
ORDER BY 
    avg_rating ASC;                         



















