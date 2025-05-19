-- Select customer details along with counts of funded savings/investment plans and total deposits
SELECT 
    U.id AS owner_id,  -- Unique ID of the customer
    CONCAT(U.first_name, " ", U.last_name) AS name,  -- Full name of the customer

    -- Count of distinct funded savings plans (is_regular_savings = 1)
    COUNT(DISTINCT CASE 
        WHEN P.is_regular_savings = 1 THEN P.id 
    END) AS savings_count,

    -- Count of distinct funded investment plans (is_a_fund = 1)
    COUNT(DISTINCT CASE 
        WHEN P.is_a_fund = 1 THEN P.id 
    END) AS investment_count,

    -- Sum of all confirmed deposit amounts linked to customer's funded plans (amounts are in kobo)
    ROUND(SUM(S.confirmed_amount),2) AS total_deposits

FROM 
    users_customuser U  -- Base user table

    -- Inner join to include only customers who have at least one plan
    INNER JOIN plans_plan P 
        ON P.owner_id = U.id

    -- Inner join only transactions where confirmed deposits exist
    INNER JOIN savings_savingsaccount S 
        ON S.plan_id = P.id 
        AND S.confirmed_amount > 0  -- Only funded plans are counted

-- Group by user to compute aggregates per customer
GROUP BY 
    U.id

-- Order by total confirmed deposits (highest value customers first)
ORDER BY 
    total_deposits DESC;
