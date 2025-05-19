SELECT 
    P.id AS plan_id,
    P.owner_id,

    -- Determine account type
    CASE 
        WHEN P.is_regular_savings = 1 THEN 'Savings'
        WHEN P.is_a_fund = 1 THEN 'Investment'
        ELSE NULL
    END AS type,

    -- Last transaction date
    MAX(S.transaction_date) AS last_transaction_date,

    -- Days since last transaction or since plan start_date if no transaction
    DATEDIFF(CURDATE(), 
        COALESCE(MAX(S.transaction_date), P.start_date)
    ) AS inactivity_days

FROM 
    plans_plan P

-- LEFT JOIN to include plans with zero transactions
LEFT JOIN 
    savings_savingsaccount S 
    ON S.plan_id = P.id 


GROUP BY 
    P.id

HAVING 
    type IS NOT NULL
    AND inactivity_days > 365;

