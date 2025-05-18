/*-- QUESTION 4. Customer Lifetime Value (CLV) Estimation
		-- Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
-- Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
		-- ●	Account tenure (months since signup)
		-- ●	Total transactions
		-- ●	Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
		-- ●	Order by estimated CLV from highest to lowest
-- Tables:
		-- ●	users_customuser
		-- ●	savings_savingsaccount
*/



SELECT us.id,
       CONCAT(us.first_name, ' ', us.last_name) AS name,
       TIMESTAMPDIFF(MONTH, us.created_on, NOW()) AS tenure_months,    -- Getting the tenure month of each account since creation
       COUNT(ssa.id) AS total_transactions,                            -- Calculating the total transactions done
       ROUND(
        (COUNT(ssa.id) / NULLIF(TIMESTAMPDIFF(MONTH, us.created_on, CURDATE()), 0)) 
        * 12 
        * AVG(ssa.confirmed_amount * 0.001), 2
        ) AS estimated_clv                                             -- Estimated Customer Lifetime Value
FROM users_customuser AS us
JOIN savings_savingsaccount AS ssa
ON ssa.owner_id = us.id
WHERE ssa.confirmed_amount > 0
GROUP BY us.id, us.first_name, us.last_name
HAVING tenure_months > 0 AND total_transactions > 0
ORDER BY estimated_clv DESC;
