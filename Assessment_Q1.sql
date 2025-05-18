-- QUESTIONS 1
/*-- 1. High-Value Customers with Multiple Products
Scenario: 
The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Tables:
●	users_customuser
●	savings_savingsaccount
●	plans_plan
*/

SELECT 
    us.id AS owner_id,    --Owner_id
  
    CONCAT(us.first_name, ' ', us.last_name) AS name,     --- Concatenate the first name and Last name since the name column in NULL
  
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) AS savings_count,    --  Count the unique customers saving plans
    
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) AS investment_count,          --  Count the unique customers investment plans
    ROUND(SUM(ssa.confirmed_amount), 2) AS total_deposits    ---- Getting the sum of inflow and rounding to two decimal place
    
FROM users_customuser AS us
JOIN savings_savingsaccount AS ssa   ------ Joining the savings account table to user customer table using the unique ids
    ON us.id = ssa.owner_id
JOIN plans_plan AS pp
    ON ssa.plan_id = pp.id  -- Joining the plans table to the outcome after joining the user customer table with savings account table
WHERE ssa.confirmed_amount >= 0
GROUP BY us.id, us.first_name, us.last_name  -- Grouping using the id and name
HAVING
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) >= 1 AND
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) >= 1
ORDER BY total_deposits DESC;
