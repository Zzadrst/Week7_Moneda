CREATE DATABASE BankingSystem;
USE BankingSystem;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    Address TEXT
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AccountType ENUM('Savings', 'Checking', 'Business'),
    Balance DECIMAL(10,2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer'),
    Amount DECIMAL(10,2),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    LoanAmount DECIMAL(12,2),
    InterestRate DECIMAL(5,2),
    LoanTerm INT COMMENT 'Loan duration in months',
    Status ENUM('Active', 'Paid', 'Defaulted'),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    AmountPaid DECIMAL(10,2),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID) ON DELETE CASCADE
);

INSERT INTO Customers (FullName, Email, PhoneNumber, Address)
SELECT 
    CONCAT('Customer_', FLOOR(RAND() * 100000)),
    CONCAT('user', FLOOR(RAND() * 100000), '@bank.com'),
    CONCAT('+639', FLOOR(RAND() * 1000000000)),
    CONCAT('Street_', FLOOR(RAND() * 10000), ', City_', FLOOR(RAND() * 100))
FROM 
   information_schema.tables
LIMIT 10000;

SELECT * FROM customers;

INSERT INTO Accounts (CustomerID, AccountType, Balance)
SELECT
    CustomerID,
    IF(RAND() > 0.5, 'Savings', 'Checking'),
    ROUND(RAND() * 100000, 2)
FROM Customers;

SELECT * FROM accounts;

INSERT INTO Transactions (AccountID, TransactionType, Amount)
SELECT
    AccountID,
    IF(RAND() > 0.5, 'Deposit', 'Withdrawal'),
    ROUND(RAND() * 5000, 2)
FROM Accounts;

SELECT * FROM transactions;

INSERT INTO Loans (CustomerID, LoanAmount, InterestRate, LoanTerm, Status)
SELECT
    CustomerID,
    ROUND(RAND() * 100000, 2),
    ROUND(RAND() * 10, 2),
    FLOOR(RAND() * 60) + 12,
    IF(RAND() > 0.5, 'Active', 'Paid')
FROM Customers;

SELECT * FROM loans;

INSERT INTO Payments (LoanID, AmountPaid)
SELECT
    LoanID,
    ROUND(RAND() * 5000, 2)
FROM Loans;

SELECT * FROM payments;

SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Accounts;
SELECT COUNT(*) FROM Transactions;
SELECT COUNT(*) FROM Loans;
SELECT COUNT(*) FROM Payments;
