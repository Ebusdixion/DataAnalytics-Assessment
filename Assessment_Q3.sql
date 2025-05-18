/*-- QUESTION3 Account Inactivity Alert
-- Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
-- Tables:
-- ●	plans_plan
-- ●	savings_savingsaccount
*/




WITH latest_transaction AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0  -- Only consider confirmed transactions
    GROUP BY plan_id
),

eligible_plans AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_a_fund = 1 THEN 'Investments'
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            ELSE 'Other'
        END AS plan_type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM plans_plan AS p
    LEFT JOIN latest_transaction AS lt 
    ON p.id = lt.plan_id
    WHERE 
        p.is_deleted = 0
        AND p.is_archived = 0
        AND (
            p.is_a_fund = 1 OR p.is_regular_savings = 1
        )
)

SELECT *
FROM eligible_plans
WHERE 
    last_transaction_date IS NULL          -- No transactions ever
    OR inactivity_days > 365               -- Last transaction older than 1 year
ORDER BY inactivity_days DESC;
