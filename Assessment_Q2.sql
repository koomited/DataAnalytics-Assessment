-- Final aggregated result: groups customers by transaction frequency category
SELECT 
    frequency_category,  -- Label indicating frequency group (High, Medium, Low)
    COUNT(*) AS customer_count,  -- Number of customers in each category
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month  -- Average transaction rate per month per category
FROM (

    -- Subquery: computes transaction statistics per customer
    SELECT 
        U.id AS customer_id,  -- Unique user ID from users_customuser table
        
        COUNT(S.id) AS total_transactions,  -- Total number of transactions by the user

        -- Compute average number of transactions per month
        -- Tenure is the number of months between first and last transaction (inclusive)
        -- GREATEST(…, 1) prevents division by zero when tenure is less than 1 month
        COUNT(S.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(S.transaction_date), MAX(S.transaction_date)), 1) 
        AS transactions_per_month,

        -- Categorize users based on their monthly transaction frequency
        CASE 
            WHEN COUNT(S.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(S.transaction_date), MAX(S.transaction_date)), 1) >= 10 
                THEN 'High Frequency'
            WHEN COUNT(S.id) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(S.transaction_date), MAX(S.transaction_date)), 1) BETWEEN 3 AND 9 
                THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category

        -- Note:
        -- We're using MAX(transaction_date) instead of NOW() so that the frequency calculation
        -- only considers the active historical range as provided by the data base.
        -- If the business rule prefers measuring frequency relative to the current date,
        -- then we replace MAX(S.transaction_date) with NOW() in both expressions.

    FROM 
        users_customuser U  -- Table containing user information
    JOIN 
        savings_savingsaccount S ON S.owner_id = U.id  -- Join with user's transaction data

    GROUP BY 
        U.id  -- One row per user

) AS customer_stats  -- End of subquery

-- Group the computed stats into frequency categories
GROUP BY 
    frequency_category

-- Sort by highest average transaction rate
ORDER BY 
    avg_transactions_per_month DESC;
