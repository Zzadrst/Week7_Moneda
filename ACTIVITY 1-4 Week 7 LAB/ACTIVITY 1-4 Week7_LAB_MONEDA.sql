START TRANSACTION;
UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountID = 2;
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Transfer', 1000), (2, 'Transfer', 1000);
COMMIT;

SELECT * FROM transactions;

START TRANSACTION;
UPDATE Loans SET Status = 'Paid' WHERE LoanID = 5;
INSERT INTO Payments (LoanID, AmountPaid) VALUES (5, 5000);
COMMIT;

SELECT * FROM payments;

CREATE USER 'bank_clerk'@'localhost' IDENTIFIED BY 'securepassword';
GRANT SELECT, UPDATE ON BankingSystem.Accounts TO 'bank_clerk'@'localhost';

CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'readonlypass';
GRANT SELECT ON BankingSystem.* TO 'auditor'@'localhost';

SHOW GRANTS FOR 'bank_clerk'@'localhost';
SHOW GRANTS FOR 'auditor'@'localhost';

ALTER TABLE Accounts ADD AccountHolder VARCHAR(255) NOT NULL;

SELECT * FROM Accounts WHERE AccountHolder = '' OR 1=1;

PREPARE stmt FROM 'SELECT * FROM Accounts WHERE AccountHolder = ?';
SET @holder = 'Alice Johnson';
EXECUTE stmt USING @holder;
DEALLOCATE PREPARE stmt;

INSERT INTO Accounts (CustomerID, AccountType, Balance, CreatedAt, AccountHolder)
VALUES (1, 'Savings', 5000.00, NOW(), 'Alice Johnson');

UPDATE Accounts 
SET AccountHolder = 'Alice Johnson' 
WHERE AccountID = 1;  -- Change 1 to an existing AccountID

SELECT * FROM Accounts WHERE AccountHolder = 'Alice Johnson';

START TRANSACTION;
UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID BETWEEN 1 AND 2000;
UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID BETWEEN 2001 AND 4000;
SAVEPOINT bulk_transaction;

SELECT * FROM Accounts WHERE AccountID BETWEEN 1 AND 5;

COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 3;
UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 4;
COMMIT;

SELECT @@TRANSACTION_ISOLATION;
