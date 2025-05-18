-- Select customer details and aggregated plan and deposit info
SELECT 
    U.id AS owner_id,  -- Unique ID of the customer
    CONCAT(U.first_name, " ", U.last_name) AS name,  -- Full name of the customer

    -- Count distinct savings plans (is_regular_savings = 1) per customer
    COUNT(DISTINCT CASE WHEN P.is_regular_savings = 1 THEN P.id END) AS savings_count,

    -- Count distinct investment plans (is_a_fund = 1) per customer
    COUNT(DISTINCT CASE WHEN P.is_a_fund = 1 THEN P.id END) AS investment_count,

    -- Sum of all confirmed deposit amounts linked to customer's plans (amounts are in kobo)
    SUM(S.confirmed_amount) AS total_deposits

FROM 
    users_customuser U  -- Base table of customers

    -- Inner join to include only customers who have at least one plan
    INNER JOIN plans_plan P ON P.owner_id = U.id

    -- Left join to include deposit transactions for each plan, if any exist
    LEFT JOIN savings_savingsaccount S ON S.plan_id = P.id

-- Group by customer to aggregate counts and sums per user
GROUP BY 
    U.id

-- Filter to keep only customers with:
-- At least one savings plan AND at least one investment plan
HAVING 
    COUNT(DISTINCT CASE WHEN P.is_regular_savings = 1 THEN P.id END) > 0
    AND COUNT(DISTINCT CASE WHEN P.is_a_fund = 1 THEN P.id END) > 0

-- Sort the final list by total deposits in descending order (highest value customers first)
ORDER BY 
    total_deposits DESC;
