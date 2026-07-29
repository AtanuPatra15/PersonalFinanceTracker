USE PersonalFinanceTracker;

-- 1. View - Transaction Details
CREATE VIEW TransactionDetails AS
SELECT
    t.TransactionID,
    u.FullName,
    a.AccountName,
    c.CategoryName,
    t.Amount,
    t.TransactionType,
    t.TransactionDate,
    t.Description
FROM Transactions t
JOIN Users u
ON t.UserID = u.UserID
JOIN Accounts a
ON t.AccountID = a.AccountID
JOIN Categories c
ON t.CategoryID = c.CategoryID;

SELECT * FROM TransactionDetails;

-- 2. Query - Highest Income
SELECT *
FROM Transactions
WHERE TransactionType='Income'
ORDER BY Amount DESC
LIMIT 1;

-- 3. Query - Lowest Expense
SELECT *
FROM Transactions
WHERE TransactionType='Expense'
ORDER BY Amount ASC
LIMIT 1;

-- 4. Query - Average Income
SELECT
AVG(Amount) AS AverageIncome
FROM Transactions
WHERE TransactionType='Income';

-- 5. Query - Total Income by User
SELECT
u.FullName,
SUM(t.Amount) AS TotalIncome
FROM Users u
JOIN Transactions t
ON u.UserID=t.UserID
WHERE t.TransactionType='Income'
GROUP BY u.FullName;

-- 6. Query - Total Expense by User
SELECT
u.FullName,
SUM(t.Amount) AS TotalExpense
FROM Users u
JOIN Transactions t
ON u.UserID=t.UserID
WHERE t.TransactionType='Expense'
GROUP BY u.FullName;

-- 7. Query - Income by Account
SELECT
a.AccountName,
SUM(t.Amount) AS TotalIncome
FROM Accounts a
JOIN Transactions t
ON a.AccountID=t.AccountID
WHERE t.TransactionType='Income'
GROUP BY a.AccountName;

-- 8. Query - Expense by Account
SELECT
a.AccountName,
SUM(t.Amount) AS TotalExpense
FROM Accounts a
JOIN Transactions t
ON a.AccountID=t.AccountID
WHERE t.TransactionType='Expense'
GROUP BY a.AccountName;

-- 9. Query - Recent 10 Transactions
SELECT *
FROM Transactions
ORDER BY TransactionDate DESC
LIMIT 10;

-- 10. Query - Transactions Between Dates
SELECT *
FROM Transactions
WHERE TransactionDate
BETWEEN '2026-01-01' AND '2026-12-31';

-- 11. Query - User with Highest Income
SELECT
u.FullName,
SUM(t.Amount) AS TotalIncome
FROM Users u
JOIN Transactions t
ON u.UserID=t.UserID
WHERE t.TransactionType='Income'
GROUP BY u.FullName
ORDER BY TotalIncome DESC
LIMIT 1;

-- 12. Query - Total Transactions by Category
SELECT
c.CategoryName,
COUNT(t.TransactionID) AS TotalTransactions
FROM Categories c
JOIN Transactions t
ON c.CategoryID=t.CategoryID
GROUP BY c.CategoryName;

-- 13. Enable Event Scheduler
SET GLOBAL event_scheduler = ON;

-- 14. Event - Monthly Budget Reset
CREATE EVENT MonthlyBudgetReset
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
UPDATE Budgets
SET SpentAmount = 0;

-- 15. Event - Delete Old Transactions (Older than 5 Years)
CREATE EVENT DeleteOldTransactions
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP
DO
DELETE FROM Transactions
WHERE TransactionDate < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 16. Show Events
SHOW EVENTS;

-- 17. Create Index - UserID
CREATE INDEX idx_user
ON Transactions(UserID);

-- 18. Create Index - AccountID
CREATE INDEX idx_account
ON Transactions(AccountID);

-- 19. Create Index - CategoryID
CREATE INDEX idx_category
ON Transactions(CategoryID);

-- 20. Create Index - TransactionDate
CREATE INDEX idx_date
ON Transactions(TransactionDate);

-- 21. Show Indexes
SHOW INDEX FROM Transactions;

DELETE FROM Transactions
WHERE TransactionID = 101;

