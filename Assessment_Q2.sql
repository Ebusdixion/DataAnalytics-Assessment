/*-- QUESTION 2
-- Transaction Frequency Analysis
-- Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
-- Task: Calculate the average number of transactions per customer per month and categorize them:
-- ●	"High Frequency" (≥10 transactions/month)
-- ●	"Medium Frequency" (3-9 transactions/month)
-- ●	"Low Frequency" (≤2 transactions/month)
-- Tables:
-- ●	users_customuser
-- ●	savings_savingsaccount
*/




WITH monthly_transaction AS (
    SELECT
        us.id,                                                       -- Using CTE to get the count of each transaction done per month
        DATE_FORMAT(ssa.transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM users_customuser AS us
    LEFT JOIN savings_savingsaccount AS ssa
        ON us.id = ssa.owner_id
    WHERE ssa.confirmed_amount > 0
    GROUP BY us.id, DATE_FORMAT(ssa.transaction_date, '%Y-%m')
),
avg_txn_per_customer AS (
    SELECT id,
        AVG(monthly_txn_count) AS avg_transactions_per_month           -- Using CTE to get the average done per month
    FROM monthly_transaction
    GROUP BY id
)
SELECT
frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month),2) AS avg_transactions_per_month
FROM (
    SELECT
        id,
        avg_transactions_per_month,                                     -- Using subquery to get the frequency of the transaction based on the average transaction per month
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_customer
) AS categorized_customer
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
