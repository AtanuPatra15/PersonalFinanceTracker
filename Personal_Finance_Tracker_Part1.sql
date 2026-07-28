CREATE DATABASE PersonalFinanceTracker;
USE PersonalFinanceTracker;

-- Table 1: Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Password VARCHAR(100) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL,
    Type ENUM('Income','Expense') NOT NULL
);

-- Table 3: Accounts
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    AccountName VARCHAR(50),
    AccountType ENUM('Savings','Current','Cash','Credit Card','UPI'),
    Balance DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table 4: Transactions
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    AccountID INT,
    CategoryID INT,
    Amount DECIMAL(12,2) NOT NULL,
    TransactionType ENUM('Income','Expense'),
    TransactionDate DATE,
    Description VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table 5: Budgets
CREATE TABLE Budgets (
    BudgetID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    CategoryID INT,
    BudgetAmount DECIMAL(12,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table 6: SavingsGoals
CREATE TABLE SavingsGoals (
    GoalID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    GoalName VARCHAR(100),
    TargetAmount DECIMAL(12,2),
    SavedAmount DECIMAL(12,2) DEFAULT 0,
    TargetDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table 7: RecurringTransactions
CREATE TABLE RecurringTransactions (
    RecurringID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    CategoryID INT,
    AccountID INT,
    Amount DECIMAL(12,2),
    Frequency ENUM('Daily','Weekly','Monthly','Yearly'),
    NextDueDate DATE,
    Description VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Table 8: Notifications
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Message VARCHAR(255),
    NotificationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Unread','Read') DEFAULT 'Unread',
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Users (FullName, Email, Phone, Password) VALUES
('Rahul Sharma', 'rahul@gmail.com', '9123456780', 'Rahul@123'),
('Priya Singh', 'priya@gmail.com', '9988776655', 'Priya@123'),
('Amit Das', 'amit@gmail.com', '9090909090', 'Amit@123'),
('Sneha Roy', 'sneha@gmail.com', '9871234567', 'Sneha@123'),
('Arjun Gupta', 'arjun@gmail.com', '9012345678', 'Arjun@123'),
('Neha Verma', 'neha@gmail.com', '9345678901', 'Neha@123'),
('Rohan Sen', 'rohan@gmail.com', '9234567890', 'Rohan@123'),
('Ananya Paul', 'ananya@gmail.com', '9456789012', 'Ananya@123'),
('Vikram Kumar', 'vikram@gmail.com', '9567890123', 'Vikram@123'),
('Karan Mehta', 'karan@gmail.com', '9789012345', 'Karan@123');

INSERT INTO Categories (CategoryName, Type) VALUES
('Salary', 'Income'),
('Freelancing', 'Income'),
('Investment', 'Income'),
('Food', 'Expense'),
('Transportation', 'Expense'),
('Shopping', 'Expense'),
('Rent', 'Expense'),
('Utilities', 'Expense'),
('Healthcare', 'Expense'),
('Entertainment', 'Expense');

INSERT INTO Accounts (UserID, AccountName, AccountType, Balance) VALUES
(1, 'SBI Savings', 'Savings', 65000.00),
(2, 'HDFC Savings', 'Savings', 48000.00),
(3, 'ICICI Current', 'Current', 92000.00),
(4, 'Axis Savings', 'Savings', 38500.00),
(5, 'Cash Wallet', 'Cash', 7500.00),
(6, 'PhonePe Wallet', 'UPI', 4200.00),
(7, 'Google Pay', 'UPI', 5600.00),
(8, 'Paytm Wallet', 'UPI', 3100.00),
(9, 'PNB Savings', 'Savings', 87000.00),
(10, 'BOB Savings', 'Savings', 53000.00);

INSERT INTO Transactions
(UserID, AccountID, CategoryID, Amount, TransactionType, TransactionDate, Description)
VALUES
(1, 1, 1, 55000.00, 'Income', '2026-07-01', 'Monthly Salary'),
(2, 2, 2, 12000.00, 'Income', '2026-07-03', 'Freelance Web Project'),
(3, 3, 3, 8000.00, 'Income', '2026-07-05', 'Stock Investment Return'),
(4, 4, 4, 1500.00, 'Expense', '2026-07-06', 'Restaurant Dinner'),
(5, 5, 5, 700.00, 'Expense', '2026-07-07', 'Cab Fare'),
(6, 6, 6, 3500.00, 'Expense', '2026-07-08', 'Online Shopping'),
(7, 7, 7, 12000.00, 'Expense', '2026-07-09', 'House Rent'),
(8, 8, 8, 2200.00, 'Expense', '2026-07-10', 'Electricity Bill'),
(9, 9, 9, 1800.00, 'Expense', '2026-07-11', 'Medical Checkup'),
(10, 10, 10, 2500.00, 'Expense', '2026-07-12', 'Movie and Dinner');

INSERT INTO Budgets (UserID, CategoryID, BudgetAmount, StartDate, EndDate) VALUES
(1, 4, 8000.00, '2026-07-01', '2026-07-31'),
(2, 6, 10000.00, '2026-07-01', '2026-07-31'),
(3, 5, 3000.00, '2026-07-01', '2026-07-31'),
(4, 7, 15000.00, '2026-07-01', '2026-07-31'),
(5, 8, 2500.00, '2026-07-01', '2026-07-31'),
(6, 9, 4000.00, '2026-07-01', '2026-07-31'),
(7, 10, 3500.00, '2026-07-01', '2026-07-31'),
(8, 4, 7000.00, '2026-07-01', '2026-07-31'),
(9, 6, 9000.00, '2026-07-01', '2026-07-31'),
(10, 5, 4500.00, '2026-07-01', '2026-07-31');

INSERT INTO SavingsGoals
(UserID, GoalName, TargetAmount, SavedAmount, TargetDate)
VALUES
(1, 'Buy a Laptop', 80000.00, 30000.00, '2026-12-31'),
(2, 'Family Vacation', 60000.00, 20000.00, '2026-11-30'),
(3, 'Purchase a Bike', 120000.00, 50000.00, '2027-03-31'),
(4, 'Emergency Fund', 150000.00, 75000.00, '2027-06-30'),
(5, 'New Smartphone', 40000.00, 15000.00, '2026-10-31'),
(6, 'Home Down Payment', 500000.00, 180000.00, '2028-01-31'),
(7, 'Higher Education', 250000.00, 90000.00, '2027-12-31'),
(8, 'Buy a Car', 800000.00, 250000.00, '2028-12-31'),
(9, 'Wedding Fund', 400000.00, 120000.00, '2028-06-30'),
(10, 'Start a Business', 300000.00, 100000.00, '2027-09-30');

INSERT INTO RecurringTransactions
(UserID, CategoryID, AccountID, Amount, Frequency, NextDueDate, Description)
VALUES
(1, 7, 1, 12000.00, 'Monthly', '2026-08-01', 'Monthly House Rent'),
(2, 8, 2, 1800.00, 'Monthly', '2026-08-05', 'Electricity Bill'),
(3, 5, 3, 1500.00, 'Monthly', '2026-08-03', 'Transportation Expense'),
(4, 10, 4, 2500.00, 'Monthly', '2026-08-07', 'Entertainment Subscription'),
(5, 9, 5, 1200.00, 'Monthly', '2026-08-10', 'Medical Insurance'),
(6, 4, 6, 3500.00, 'Weekly', '2026-07-31', 'Grocery Shopping'),
(7, 7, 7, 10000.00, 'Monthly', '2026-08-02', 'House Rent'),
(8, 8, 8, 2000.00, 'Monthly', '2026-08-04', 'Utility Bill'),
(9, 5, 9, 1800.00, 'Monthly', '2026-08-06', 'Fuel Expense'),
(10, 4, 10, 4000.00, 'Weekly', '2026-07-30', 'Weekly Groceries');

INSERT INTO Notifications
(UserID, Message, Status)
VALUES
(1, 'Your monthly budget limit is almost reached.', 'Unread'),
(2, 'Salary payment has been received.', 'Read'),
(3, 'Your investment return has been added.', 'Read'),
(4, 'Rent payment is due soon.', 'Unread'),
(5, 'Healthcare expense reminder.', 'Unread'),
(6, 'Your savings goal progress has been updated.', 'Read'),
(7, 'Entertainment budget exceeded.', 'Unread'),
(8, 'Electricity bill payment reminder.', 'Unread'),
(9, 'Monthly expense report is available.', 'Read'),
(10, 'Welcome to Personal Finance Tracker.', 'Read');

SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM Accounts;
SELECT * FROM Transactions;
TRUNCATE TABLE Transactions;
SELECT * FROM Budgets;
SELECT * FROM SavingsGoals;
SELECT * FROM RecurringTransactions;
SELECT * FROM Notifications;
