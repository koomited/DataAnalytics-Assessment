-- CTE: Compute transaction stats per customer
WITH customer_stats AS (
    SELECT 
        U.id AS customer_id,  -- Unique customer ID

        -- Calculate average transactions per month
        -- Tenure is the number of months from date_joined to now (minimum 1 to avoid division by zero)
        COUNT(S.id) / GREATEST(TIMESTAMPDIFF(MONTH, U.date_joined, NOW()), 1) AS transactions_per_month

    FROM 
        users_customuser U  -- Customer information table

    JOIN 
        savings_savingsaccount S ON S.owner_id = U.id  -- Join with transaction table

    GROUP BY 
        U.id  -- One row per customer
)

-- Final output: Group customers by frequency category
SELECT 
    frequency_category,  -- Frequency segment: High, Medium, or Low
    COUNT(customer_id) AS customer_count,  -- Number of customers in this category
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month  -- Average transactions per month for this group

FROM (
    -- Subquery: Assign each customer to a frequency category
    SELECT
        customer_id,
        transactions_per_month,

        -- Categorize based on average transactions per month
        CASE
            WHEN transactions_per_month >= 10 THEN 'High Frequency'
            WHEN transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category

    FROM 
        customer_stats  -- Use CTE results
) AS categorized

-- Group by frequency category to get summary stats
GROUP BY 
    frequency_category

-- Sort categories by transaction activity
ORDER BY 
    avg_transactions_per_month DESC;
