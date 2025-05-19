SELECT 
    U.id AS owner_id,  -- Unique identifier of the customer
    CONCAT(U.first_name, " ", U.last_name) AS name,  -- Full name of the customer

    -- Count of distinct savings plans where the savings flag is set
    COUNT(DISTINCT CASE 
        WHEN P.is_regular_savings = 1 THEN P.id 
    END) AS savings_count,

    -- Count of distinct investment plans where the investment flag is set
    COUNT(DISTINCT CASE 
        WHEN P.is_a_fund = 1 THEN P.id 
    END) AS investment_count,

    -- Total confirmed deposits across all plans linked to the customer, rounded to 2 decimals
    ROUND(SUM(S.confirmed_amount), 2) AS total_deposits

FROM 
    users_customuser U  -- Users table

    -- Join plans owned by the user
    INNER JOIN plans_plan P 
        ON P.owner_id = U.id

    -- Join only confirmed deposit transactions on these plans
    INNER JOIN savings_savingsaccount S 
        ON S.plan_id = P.id 
        AND S.confirmed_amount > 0

WHERE
    -- Filter to only include plans explicitly marked as savings or investment
    P.is_regular_savings = 1 OR P.is_a_fund = 1

GROUP BY 
    U.id  -- Aggregate results by user

ORDER BY 
    total_deposits;  
