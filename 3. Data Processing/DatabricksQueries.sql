-- 0. DATA UNDERSTANDING & CLEANING 
----------------------------------- 
-- Preview dataset 
SELECT * 
FROM brightlearn.default.bright_coffee_shop 
LIMIT 100; 

-- Date range of dataset 
SELECT 
  MIN(transaction_date) AS start_date, 
  MAX(transaction_date) AS end_date 
  FROM brightlearn.default.bright_coffee_shop; 
  
-- Unique store locations 
SELECT 
  DISTINCT store_location 
FROM brightlearn.default.bright_coffee_shop; 
  
-- Product hierarchy 
SELECT 
  DISTINCT product_category, 
            product_type, 
            product_detail 
  FROM brightlearn.default.bright_coffee_shop; 
  
-- Remove timestamp 
SELECT 
   DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time 
FROM brightlearn.default.bright_coffee_shop; 
  
-- Clean Time 
SELECT 
  CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS clean_price 
FROM brightlearn.default.bright_coffee_shop; 
  
-- 1. CORE METRICS 
------------------- 
-- Total revenue (cleaned price used) 
SELECT 
    SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS total_revenue 
FROM brightlearn.default.bright_coffee_shop; 
    
-- Total number of transactions 
SELECT 
    COUNT(DISTINCT transaction_id) AS total_transactions 
FROM brightlearn.default.bright_coffee_shop; 
  
-- Total quantity sold 
SELECT SUM(CAST(transaction_qty AS DOUBLE)) AS total_quantity 
FROM brightlearn.default.bright_coffee_shop; 
  
-- 2. IDENTIFIERS (TRANSACTIONS) 
-------------------------------- 
-- Transactions per day 
SELECT transaction_date, 
  COUNT(DISTINCT transaction_id) AS transactions_per_day 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY transaction_date 
ORDER BY transaction_date; 
  
-- Items per transaction 
SELECT transaction_id,
  SUM(CAST(transaction_qty AS DOUBLE)) AS items_per_transaction 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY transaction_id; 
  
-- 3. TIME-BASED ANALYSIS 
-------------------------- 
-- Revenue by month 
SELECT MONTHNAME(transaction_date) AS month, 
    SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY MONTHNAME(transaction_date) 
ORDER BY revenue DESC; 
  
-- Peak sales hours 
SELECT HOUR(transaction_time) AS hour, 
  SUM(CAST(transaction_qty AS DOUBLE)) AS quantity 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY HOUR(transaction_time) 
ORDER BY quantity DESC; 
  
-- Weekday vs Weekend performance 
SELECT 
  CASE 
    WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend' 
  ELSE 'Weekday' 
  END AS day_type, 
  SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY day_type; 
  
-- Time bucket performance 
SELECT 
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning' 
    WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday' 
    WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Late Afternoon' 
  ELSE 'Evening' END AS time_bucket, 
SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY time_bucket; 
  
-- Month period performance 
SELECT 
  CASE 
    WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early Month' 
    WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid Month' 
    ELSE 'Month End' 
  END AS month_period, 
SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY month_period; 
  
-- 4. STORE ANALYSIS 
-------------------- 
-- Revenue by store 
SELECT store_location, 
  SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY store_location 
ORDER BY revenue DESC; 
  
-- Transactions per store 
SELECT store_location, 
  COUNT(DISTINCT transaction_id) AS transactions 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY store_location; 
  
-- 5. PRODUCT ANALYSIS 
----------------------- 
-- Most purchased products 
SELECT product_detail, 
  SUM(CAST(transaction_qty AS DOUBLE)) AS quantity 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY product_detail 
ORDER BY quantity DESC; 
  
-- Top revenue products 
SELECT product_detail, 
  SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY product_detail 
ORDER BY revenue DESC; 
  
-- Category performance 
SELECT product_category, 
  SUM(CAST(transaction_qty AS DOUBLE)) AS quantity 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY product_category; 
  
-- 6. PRICE ANALYSIS 
----------------------- 
-- Price category performance 
SELECT 
  CASE 
    WHEN CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) < 10 THEN 'Cheap' 
    WHEN CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) BETWEEN 10 AND 30 THEN 'Affordable' 
    ELSE 'Expensive' 
  END AS price_category, 
SUM( CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) ) AS revenue 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY price_category; 
  
-- 7. CROSS ANALYSIS 
----------------------- 
-- Product VS Time 
SELECT product_detail, 
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning' 
    WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday' WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Late Afternoon' 
    ELSE 'Evening' 
  END AS time_bucket, 
SUM(CAST(transaction_qty AS DOUBLE)) AS quantity 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY product_detail, time_bucket; 
  
-- Store VS Product 
SELECT store_location, 
      product_detail, 
      SUM(CAST(transaction_qty AS DOUBLE)) AS quantity 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY store_location, product_detail; 
  
-- Store VS Time 
SELECT store_location, 
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning' 
    WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday' 
    WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Late Afternoon' 
    ELSE 'Evening' 
  END AS time_bucket, 
COUNT(DISTINCT transaction_id) AS transactions 
FROM brightlearn.default.bright_coffee_shop 
GROUP BY store_location, time_bucket; 
  
-- 8. FINAL BIG QUERY WITH ALL NEW COLUMNS 
------------------------------------------ 
SELECT transaction_id, transaction_date, 
  
-- Clean time (removes timestamp formatting) 
  DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time, 
  transaction_qty, 
  store_id, 
  store_location, 
  product_id, 
  unit_price, 
  product_category, 
  product_type, 
  product_detail, 
  
-- Day name (Monday, Tuesday...) 
  DAYNAME(transaction_date) AS day_name, 

-- Month name (January, February...) 
  MONTHNAME(transaction_date) AS month_name, 
  
-- Day of month (1–31) 
  DAYOFMONTH(transaction_date) AS day_number, 
  
-- Weekend vs Weekday 
  CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type, 
  
-- Time bucket (customer behaviour) 
  CASE 
    WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning' 
    WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday' 
    WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Late Afternoon' 
    ELSE 'Evening' 
  END AS time_bucket, 
  
-- Month period segmentation 
  CASE 
    WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early Month'   
    WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid Month' 
    ELSE 'Month End' 
  END AS month_period, 
  
-- Clean numeric price 
  CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS clean_price, 
  
-- Revenue per row 
  CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS revenue, 
  
-- Spend segmentation 
  CASE 
    WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) <= 50 THEN 'Cheap spend' 
    WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) BETWEEN 51 AND 200 THEN 'Low spend' 
    WHEN (CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) BETWEEN 201 AND 300 THEN 'Medium spend' 
    ELSE 'Expensive spend' 
  END AS spend_bucket FROM brightlearn.default.bright_coffee_shop;
