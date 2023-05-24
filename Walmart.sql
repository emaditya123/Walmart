# Data cleaning
SELECT * FROM walmart;

# -----------------------------------------Feature Engineering----------------------------------------
# Add the time_of_day_column
SELECT
     TIME,
     (CASE
          WHEN TIME  BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN TIME BETWEEN "12:011:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening" END) AS time_of_day
    FROM walmart;

ALTER TABLE walmart ADD COLUMN time_of_day VARCHAR(20);

# To fill the values in time_of_day column

UPDATE walmart
SET time_of_day = (
      CASE 
            WHEN TIME  BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN TIME BETWEEN "12:011:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening" END);
    
# ----- day_name
SELECT DATE,
       DAYNAME(DATE) FROM walmart;
       
ALTER TABLE walmart ADD COLUMN day_name VARCHAR(10);

UPDATE walmart
SET day_name = DAYNAME(DATE);

#---- month_name
SELECT DATE,
       MONTHNAME(DATE)
FROM walmart;

ALTER TABLE walmart  ADD COLUMN month_name VARCHAR(10);

UPDATE walmart
SET month_name = MONTHNAME(DATE);


#-------------------------------------------Generic-------------------------------------------------------------

#---- How many unique cities does the data have?

SELECT DISTINCT city from walmart;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM walmart;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM walmart;

-- What is the most common payment method
SELECT 
      Payment,
      COUNT(Payment) as cnt
FROM walmart
GROUP BY Payment
ORDER BY cnt DESC;

-- What is the most selling product line
SELECT 
      product_line,
      COUNT(product_line) as cnt
FROM walmart
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT
      month_name AS month,
      SUM(Total) total_revenue
FROM walmart
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
     month_name AS month,
     SUM(cogs) AS cogs
FROM walmart
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT 
     product_line,
     SUM(Total) AS total_revenue
FROM walmart
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT 
     Branch,
     city,
     SUM(Total) AS total_revenue
FROM walmart
GROUP BY city, Branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
     product_line,
     AVG(tax_pct) AS avg_tax
FROM walmart
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT AVG(Quantity) AS avg_qnty FROM walmart;

SELECT 
     product_line,
     CASE 
          WHEN AVG(Quantity) > 6 THEN "Good" ELSE "BAD"
     END AS remark
FROM walmart
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT
      Branch,
      SUM(Quantity) as qty
FROM walmart
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) from walmart);

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM walmart
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------


-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM walmart;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM walmart;


-- What is the most common customer type?
SELECT
	Customer type,
	count(*) as count
FROM walmart
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM walamart
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM walmart
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM walmart
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmart
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM walmart
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM walmart
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------