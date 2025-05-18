-- QUESTION 2


WITH monthly_transaction AS (
    SELECT
        us.id,
        DATE_FORMAT(ssa.transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM users_customuser AS us
    LEFT JOIN savings_savingsaccount AS ssa
    ON us.id = ssa.owner_id
    GROUP BY us.id, DATE_FORMAT(ssa.transaction_date, '%Y-%m')
),
avg_txn_per_customer AS (
    SELECT id,
        AVG(monthly_txn_count) AS avg_transactions_per_month
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
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_customer
) AS categorized_customer
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
