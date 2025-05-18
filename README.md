# Data Analytics-Assessment
## Repository Summary
This repository contains a SQL Proficiency Assessment curated by CowryWise. This project is part of a technical evaluation designed to measure my SQL skills and problem-solving ability as a data analyst. The assessment focuses on retrieving, analyzing, and manipulating data across multiple related tables to derive meaningful business insights.

### Question 1 – High-Value Customers with Multiple Products

**Objective:** Identify customers who have both savings and investment plans sorted by the total deposits.

**Approach:**

- Joined `users_customuser` with `plans_plan` and `savings_savingsaccount`.

- Used conditional aggregation to count savings and investment plans separately.

- Filtered for customers with at least one of each plan type.

- Summed total confirmed amounts for `total_deposits`.

- We sort results by `total_deposits` in descending order to prioritize high-value clients.

**Challenges:**

- Some entries in `users_customuser` had a `NULL` value for the name field. To ensure a complete and readable final output, I merged `first_name` and `last_name` into the name field for such users.

- Needed to ensure accuracy in identifying the correct types of plans. The flags `is_regular_savings` and `is_a_fund` were essential.

- Ensuring that only confirmed deposits (`confirmed_amount > 0`) were included in the `total_deposits` to avoid inflated values.


### Question 2 - Transaction Frequency Analysis

**Objective:** Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

**Approach:**

- Monthly Transaction Counts:
Created a CTE `monthly_transaction` that groups transactions per user by year and month using `DATE_FORMAT()`, and counts the number of transactions for each month.

- Average Transactions Per Customer:
Built another CTE `avg_txn_per_customer` to calculate each customer's average monthly transactions using `AVG()` over the monthly counts.

- Categorization:
Classified customers into frequency categories:
"High Frequency": ≥ 10 transactions/month
"Medium Frequency": 3–9 transactions/month
"Low Frequency": ≤ 2 transactions/month

- Final Aggregation:
Grouped by the frequency category to count how many customers fall into each, along with their average transaction rates.

**Challenges:**

- Monthly aggregation required converting transaction timestamps into uniform year-month format ('%Y-%m') to get correct grouping and averages.

### Question 3 - Account Inactivity Alert

**Objective:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

**Approach:**

- First, find the latest confirmed transaction date per plan from the `savings_savingsaccount` table, considering only positive inflows (`confirmed_amount > 0`).

- Join this data with the `plans_plan` table to retrieve plan details and classify each plan as either 'Savings' or 'Investments' based on the `is_regular_savings` and `is_a_fund` flags.  

- Calculate the inactivity period by computing the number of days since the last transaction date.  

- Filter plans to include only those where the inactivity period exceeds 365 days.  

- Sort the results by inactivity days in descending order to prioritize the most inactive accounts.

**Challenges:**

- There wasn't a separate transaction log with timestamps, so I used the `created_on` field to represent the last activity. I applied this approach the same way for both savings and investment data.


### Question 4: Customer Lifetime Value (CLV) Estimation

**Objective:** For each customer, assuming the `profit_per_transaction` is `0.1%` of the transaction value, calculate:

- Account tenure (months since signup)
- Total transactions
- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
- Order by estimated CLV from highest to lowest.**

**Approach:**

- Estimated CLV using the formula: CLV = `(total_transactions / tenure_in_months) * 12 * avg_profit_per_transaction`
- Calculated tenure as the number of months since account creation, counted total transactions, and derived average profit.
- Applied the CLV formula using the 0.1% profit margin specified
- Ensured no division by zero by handling zero-tenure cases with a `NULLIF` safeguard.
- The final output ranks customers by estimated CLV in descending order.

**Challenges:**

- Customers with very recent signup dates could result in zero-month tenure, which will mean dividing by 0. `NULLIF` was used to prevent this and ensure query stability.
Correctly applying the profit margin 0.1% = 0.001.
