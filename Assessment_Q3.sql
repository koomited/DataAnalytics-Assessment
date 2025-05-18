SELECT 
    P.id AS plan_id,
    P.owner_id,

    -- Determine account type based on plan flags:
    -- - If 'is_regular_savings' is true, label it as 'Savings'
    -- - If 'is_a_fund' is true, label it as 'Investment'
    -- - Otherwise, mark as NULL for filtering later
    CASE 
        WHEN P.is_regular_savings = 1 THEN 'Savings'
        WHEN P.is_a_fund = 1 THEN 'Investment'
        ELSE NULL
    END AS type,

    -- Get the most recent confirmed inflow transaction date for each plan
    MAX(S.transaction_date) AS last_transaction_date,

    -- Calculate days since the last inflow transaction
    -- If no transaction exists, result will be NULL
    DATEDIFF(CURDATE(), MAX(S.transaction_date)) AS inactivity_days

FROM 
    plans_plan P

-- Join to savings_savingsaccount to get transaction data
-- Only confirmed (positive) inflow transactions are considered
LEFT JOIN 
    savings_savingsaccount S 
    ON S.plan_id = P.id 
    AND S.confirmed_amount > 0

WHERE
    -- Filter only active plans:
    -- - Not archived
    -- - Not deleted
    -- - Not removed from a group
    P.is_archived = 0 
    AND P.is_deleted = 0
    AND P.is_deleted_from_group = 0

GROUP BY 
    P.id, P.owner_id, type

HAVING 
    -- Include only valid account types: either 'Savings' or 'Investment'
    type IS NOT NULL

    -- Include plans with:
    -- - No inflow transactions ever (last_transaction_date IS NULL), OR
    -- - Last inflow transaction occurred more than 365 days ago
    AND (last_transaction_date IS NULL OR inactivity_days > 365)

-- Sort by most inactive accounts first
ORDER BY 
    inactivity_days DESC;
