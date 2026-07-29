USE PersonalFinanceTracker;

-- 1. View - User Balance
CREATE VIEW UserBalance AS
SELECT
u.UserID,
u.FullName,
SUM(a.Balance) AS TotalBalance
FROM Users u
JOIN Accounts a
ON u.UserID=a.UserID
GROUP BY u.UserID,u.FullName;
SELECT * FROM UserBalance;

-- 2. View - Monthly Expense
CREATE VIEW MonthlyExpense AS
SELECT
UserID,
MONTH(TransactionDate) AS MonthNo,
YEAR(TransactionDate) AS YearNo,
SUM(Amount) AS TotalExpense
FROM Transactions
WHERE TransactionType='Expense'
GROUP BY UserID,
MONTH(TransactionDate),
YEAR(TransactionDate);
SELECT * FROM MonthlyExpense;

-- 3. Stored Procedure - Show User Transactions
DELIMITER $$

CREATE PROCEDURE GetUserTransactions(
IN uid INT
)
BEGIN

SELECT *
FROM Transactions
WHERE UserID=uid;

END$$

DELIMITER ; 
CALL GetUserTransactions(1);

-- 4. Stored Procedure - Expense by Category
DELIMITER $$

CREATE PROCEDURE ExpenseCategory(
IN uid INT
)
BEGIN

SELECT
c.CategoryName,
SUM(t.Amount) AS TotalExpense
FROM Transactions t
JOIN Categories c
ON t.CategoryID=c.CategoryID
WHERE t.UserID=uid
AND t.TransactionType='Expense'
GROUP BY c.CategoryName;

END$$

DELIMITER ;
CALL ExpenseCategory(1);

-- 5. Function - Total Income
DELIMITER $$

CREATE FUNCTION TotalIncome(uid INT)
RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

DECLARE income DECIMAL(10,2);

SELECT SUM(Amount)
INTO income
FROM Transactions
WHERE UserID=uid
AND TransactionType='Income';

RETURN IFNULL(income,0);

END$$

DELIMITER ;
SELECT TotalIncome(1);

-- 6. Function - Total Expense
DELIMITER $$

CREATE FUNCTION TotalExpense(uid INT)
RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

DECLARE exp DECIMAL(10,2);

SELECT SUM(Amount)
INTO exp
FROM Transactions
WHERE UserID=uid
AND TransactionType='Expense';

RETURN IFNULL(exp,0);

END$$

DELIMITER ;
SELECT TotalExpense(1);

-- 7. Function - Net Savings
DELIMITER $$

CREATE FUNCTION NetSavings(uid INT)
RETURNS DECIMAL(10,2)

DETERMINISTIC

BEGIN

RETURN TotalIncome(uid)-TotalExpense(uid);

END$$

DELIMITER ;
SELECT NetSavings(1);

-- 8. Trigger - Prevent Negative Amount
DELIMITER $$

CREATE TRIGGER CheckAmount

BEFORE INSERT
ON Transactions

FOR EACH ROW

BEGIN

IF NEW.Amount<=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Amount must be positive';
END IF;

END$$

DELIMITER ;
INSERT INTO Transactions
VALUES
(100,1,1,1,-500,'Expense','2026-07-28','Test');

-- 9. Trigger - Update Account Balance After Transaction
DELIMITER $$

CREATE TRIGGER UpdateBalance

AFTER INSERT
ON Transactions

FOR EACH ROW

BEGIN

IF NEW.TransactionType='Income' THEN

UPDATE Accounts
SET Balance=Balance+NEW.Amount
WHERE AccountID=NEW.AccountID;

ELSE

UPDATE Accounts
SET Balance=Balance-NEW.Amount
WHERE AccountID=NEW.AccountID;

END IF;

END$$

DELIMITER ;
INSERT INTO Transactions
VALUES
(101,1,1,1,500,'Income','2026-07-28','Salary');
SELECT * FROM Accounts;

-- 10. Trigger - Prevent Expense Beyond Balance
DELIMITER $$

CREATE TRIGGER PreventOverExpense

BEFORE INSERT
ON Transactions

FOR EACH ROW

BEGIN

DECLARE bal DECIMAL(10,2);

SELECT Balance
INTO bal
FROM Accounts
WHERE AccountID=NEW.AccountID;

IF NEW.TransactionType='Expense'
AND NEW.Amount>bal THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Insufficient Balance';

END IF;

END$$

DELIMITER ;


-- 11. Query - Top 5 Expenses
SELECT *
FROM Transactions
WHERE TransactionType='Expense'
ORDER BY Amount DESC
LIMIT 5;

-- 12. Query - Monthly Income
SELECT
MONTH(TransactionDate) AS MonthNo,
SUM(Amount) AS Income
FROM Transactions
WHERE TransactionType='Income'
GROUP BY MONTH(TransactionDate);

-- 13. Query - Highest Spending User
SELECT
u.FullName,
SUM(t.Amount) AS Expense
FROM Users u
JOIN Transactions t
ON u.UserID=t.UserID
WHERE t.TransactionType='Expense'
GROUP BY u.FullName
ORDER BY Expense DESC
LIMIT 1;

-- 14. Query - Average Expense
SELECT AVG(Amount)
FROM Transactions
WHERE TransactionType='Expense';

-- 15. Query - Category Wise Expense
SELECT
c.CategoryName,
SUM(t.Amount) AS Expense
FROM Categories c
JOIN Transactions t
ON c.CategoryID=t.CategoryID
WHERE t.TransactionType='Expense'
GROUP BY c.CategoryName;
