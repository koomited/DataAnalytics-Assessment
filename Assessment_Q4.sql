SELECT 
    U.id AS customer_id,
    CONCAT(U.first_name, ' ', U.last_name) AS name,

    -- Calculate account tenure in months since the user joined
    TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()) AS tenure_months,

    -- Count the number of confirmed transactions per customer
    COUNT(S.id) AS total_transactions,

    -- Estimate CLV (Customer Lifetime Value) using a simplified model:
    -- CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    -- where avg_profit_per_transaction = 0.1% (i.e., 0.001) of average transaction value
    ROUND(
        (
            -- Use NULLIF to avoid division by zero if tenure_months is 0
            COUNT(S.id) / TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE())
            * 12 
            * (0.001 * AVG(COALESCE(S.confirmed_amount, 0)))
        ),
        2
    ) AS estimated_clv

FROM 
    users_customuser U

    -- Join savings transactions for each customer
    LEFT JOIN savings_savingsaccount S 
        ON S.owner_id = U.id 
        AND S.confirmed_amount > 0  -- Only include confirmed (valid) transactions

GROUP BY 
    U.id

HAVING 
    tenure_months > 0  -- Exclude users who signed up this month (tenure = 0)
    
ORDER BY 
    estimated_clv DESC;  -- Sort from highest to lowest CLV
