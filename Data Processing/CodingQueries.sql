-- =========================================
-- SECTION 1: DATA UNDERSTANDING
-- =========================================

-- Preview data
SELECT * 
FROM `brightlearn`.`default`.`bright_coffee_shop`
LIMIT 100;

-- Date range
SELECT 
    MIN(transaction_date) AS start_date,
    MAX(transaction_date) AS end_date
FROM `brightlearn`.`default`.`bright_coffee_shop`;

-- Total store locations
SELECT 
    COUNT(DISTINCT store_location) AS total_locations
FROM `brightlearn`.`default`.`bright_coffee_shop`;

-- List store locations
SELECT DISTINCT store_location
FROM `brightlearn`.`default`.`bright_coffee_shop`;

-- Product hierarchy
SELECT DISTINCT 
    product_category,
    product_type,
    product_detail
FROM `brightlearn`.`default`.`bright_coffee_shop`;


-- =========================================
-- SECTION 2: CORE METRICS
-- =========================================

-- Total revenue
SELECT 
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS total_revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`;

-- Total quantity sold
SELECT 
    SUM(transaction_qty) AS total_quantity
FROM `brightlearn`.`default`.`bright_coffee_shop`;


-- =========================================
-- SECTION 3: TIME ANALYSIS
-- =========================================

-- Revenue per month
SELECT 
    MONTH(transaction_date) AS month,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY MONTH(transaction_date)
ORDER BY month;

-- Revenue by day of week
SELECT 
    DAYOFWEEK(transaction_date) AS day_of_week,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY DAYOFWEEK(transaction_date)
ORDER BY day_of_week;

-- Revenue by hour
SELECT 
    HOUR(transaction_time) AS hour,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY HOUR(transaction_time)
ORDER BY hour;


-- =========================================
-- SECTION 4: TIME BUCKETS (CASE)
-- =========================================

-- Revenue by time bucket
SELECT 
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_bucket,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END;

-- Weekday vs Weekend
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END;

-- Start / Mid / End of Month
SELECT 
    CASE 
        WHEN DAY(transaction_date) BETWEEN 1 AND 10 THEN 'Start'
        WHEN DAY(transaction_date) BETWEEN 11 AND 20 THEN 'Mid'
        ELSE 'End'
    END AS month_period,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    CASE 
        WHEN DAY(transaction_date) BETWEEN 1 AND 10 THEN 'Start'
        WHEN DAY(transaction_date) BETWEEN 11 AND 20 THEN 'Mid'
        ELSE 'End'
    END;


-- =========================================
-- SECTION 5: LOCATION ANALYSIS
-- =========================================

-- Revenue per store
SELECT 
    store_location,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY store_location
ORDER BY revenue DESC;

-- Quantity per store
SELECT 
    store_location,
    SUM(transaction_qty) AS total_qty
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY store_location
ORDER BY total_qty DESC;

-- Store performance by time bucket
SELECT 
    store_location,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        ELSE 'Other'
    END AS time_bucket,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    store_location,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        ELSE 'Other'
    END;


-- =========================================
-- SECTION 6: PRODUCT ANALYSIS
-- =========================================

-- Revenue per product
SELECT 
    product_detail,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY product_detail
ORDER BY revenue DESC;

-- Quantity per product
SELECT 
    product_detail,
    SUM(transaction_qty) AS total_qty
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY product_detail
ORDER BY total_qty DESC;

-- Category performance
SELECT 
    product_category,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY product_category;


-- =========================================
-- SECTION 7: PRICE ANALYSIS
-- =========================================

-- Price category analysis
SELECT 
    CASE 
        WHEN REPLACE(unit_price, ',', '.') < 20 THEN 'Cheap'
        WHEN REPLACE(unit_price, ',', '.') BETWEEN 20 AND 50 THEN 'Affordable'
        ELSE 'Expensive'
    END AS price_category,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    CASE 
        WHEN REPLACE(unit_price, ',', '.') < 20 THEN 'Cheap'
        WHEN REPLACE(unit_price, ',', '.') BETWEEN 20 AND 50 THEN 'Affordable'
        ELSE 'Expensive'
    END;


-- 
-- SECTION 8: TRANSACTION ANALYSIS
-- =========================================

-- Transaction totals
SELECT 
    transaction_id,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS transaction_total
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY transaction_id;

-- Average transaction value
SELECT 
    AVG(transaction_total) AS avg_transaction_value
FROM (
    SELECT 
        transaction_id,
        SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS transaction_total
    FROM `brightlearn`.`default`.`bright_coffee_shop`
    GROUP BY transaction_id
) t;


-- =========================================
-- SECTION 9: CROSS ANALYSIS
-- =========================================

-- Product vs Time
SELECT 
    product_detail,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        ELSE 'Other'
    END AS time_bucket,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY 
    product_detail,
    CASE 
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN 'Midday'
        ELSE 'Other'
    END;

-- Product vs Location
SELECT 
    store_location,
    product_detail,
    SUM(transaction_qty * REPLACE(unit_price, ',', '.')) AS revenue
FROM `brightlearn`.`default`.`bright_coffee_shop`
GROUP BY store_location, product_detail;
