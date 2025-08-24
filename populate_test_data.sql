-- Reset tables for test data
TRUNCATE TABLE "Installment" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "InstallmentPlan" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "LoanPayment" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Loan" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Counterparty" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Budget" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Transaction" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Account" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "Category" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "User" RESTART IDENTITY CASCADE;

-- Ensure the test user exists
INSERT INTO "User" (id, email, name, password, "createdAt", "updatedAt")
VALUES ('clx000000000000000000000', 'test@finanzas.com', 'Test User', 'test_password_hash', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert Categories
INSERT INTO "Category" (id, name, "userId") VALUES
    ('cat_food_id', 'Food', 'clx000000000000000000000'),
    ('cat_transport_id', 'Transport', 'clx000000000000000000000'),
    ('cat_salary_id', 'Salary', 'clx000000000000000000000'),
    ('cat_freelance_id', 'Freelance', 'clx000000000000000000000'),
    ('cat_internal_transfer_id', 'Internal Transfer', 'clx000000000000000000000'),
    ('cat_utilities_id', 'Utilities', 'clx000000000000000000000'),
    ('cat_entertainment_id', 'Entertainment', 'clx000000000000000000000'),
    ('cat_health_id', 'Health', 'clx000000000000000000000'),
    ('cat_shopping_id', 'Shopping', 'clx000000000000000000000'),
    ('cat_education_id', 'Education', 'clx000000000000000000000'),
    ('cat_rent_id', 'Rent', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Accounts
INSERT INTO "Account" (id, name, type, currency, balance, "createdAt", "userId") VALUES
    ('acc_main_bank_id', 'Main Bank Account', 'BANK', 'PEN', 10000.00, NOW(), 'clx000000000000000000000'),
    ('acc_cash_wallet_id', 'Cash Wallet', 'CASH', 'PEN', 500.00, NOW(), 'clx000000000000000000000'),
    ('acc_savings_id', 'Savings Account', 'BANK', 'PEN', 25000.00, NOW(), 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Update account balances to initial values
UPDATE "Account" SET balance = 10000.00 WHERE id = 'acc_main_bank_id';
UPDATE "Account" SET balance = 500.00 WHERE id = 'acc_cash_wallet_id';
UPDATE "Account" SET balance = 25000.00 WHERE id = 'acc_savings_id';

-- #############################################
-- #           TEST DATA FOR JUNE 2025         #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_jun_salary', 'June Salary', 3500.00, '2025-06-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'clx000000000000000000000'),
('trans_jun_rent', 'Rent Payment June', -1200.00, '2025-06-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'clx000000000000000000000'),
('trans_2025_6_1', 'Cinema', -49.57, '2025-06-21T19:01:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_entertainment_id', 'clx000000000000000000000'),
('trans_2025_6_2', 'Pharmacy', -136.8, '2025-06-08T11:57:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_6_3', 'Restaurant', -10.33, '2025-06-21T12:50:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_food_id', 'clx000000000000000000000'),
('trans_2025_6_4', 'Vitamins', -101.53, '2025-06-11T10:40:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_6_5', 'Delivery', -145.62, '2025-06-03T12:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'clx000000000000000000000'),
('trans_2025_6_6', 'Gas', -12.37, '2025-06-12T10:01:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_6_7', 'Online course', -100.13, '2025-06-19T12:32:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'clx000000000000000000000'),
('trans_2025_6_8', 'Cinema', -123.24, '2025-06-26T10:29:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_entertainment_id', 'clx000000000000000000000'),
('trans_2025_6_9', 'Vitamins', -144.91, '2025-06-12T18:31:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_6_10', 'Phone Bill', -13.7, '2025-06-26T10:41:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_6_11', 'Online shopping', -107.01, '2025-06-27T10:43:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_6_12', 'Phone Bill', -148.83, '2025-06-03T19:51:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_6_13', 'Gas', -144.35, '2025-06-11T10:58:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_6_14', 'Internet Bill', -13.81, '2025-06-18T18:33:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_6_15', 'Vitamins', -10.8, '2025-06-18T10:23:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_6_16', 'Phone Bill', -133.27, '2025-06-11T17:01:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_6_17', 'Gas', -148.46, '2025-06-08T19:47:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_6_18', 'Phone Bill', -104.88, '2025-06-13T18:01:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_jun_2025', 2025, 6, 700.00, 'cat_food_id', 'clx000000000000000000000'),
    ('budget_transport_jun_2025', 2025, 6, 150.00, 'cat_transport_id', 'clx000000000000000000000'),
    ('budget_utilities_jun_2025', 2025, 6, 200.00, 'cat_utilities_id', 'clx000000000000000000000'),
    ('budget_entertainment_jun_2025', 2025, 6, 250.00, 'cat_entertainment_id', 'clx000000000000000000000'),
    ('budget_shopping_jun_2025', 2025, 6, 300.00, 'cat_shopping_id', 'clx000000000000000000000');

-- #############################################
-- #           TEST DATA FOR JULY 2025         #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_jul_salary', 'July Salary', 3500.00, '2025-07-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'clx000000000000000000000'),
('trans_jul_rent', 'Rent Payment July', -1200.00, '2025-07-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'clx000000000000000000000'),
('trans_2025_7_1', 'Gas', -127.89, '2025-07-26T13:43:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_7_2', 'Online shopping', -12.31, '2025-07-03T10:13:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_7_3', 'Phone Bill', -111.2, '2025-07-18T12:47:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_7_4', 'Groceries', -148.4, '2025-07-18T19:50:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'clx000000000000000000000'),
('trans_2025_7_5', 'Online shopping', -135.83, '2025-07-24T18:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_7_6', 'Vitamins', -14.23, '2025-07-12T10:11:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_7_7', 'Online course', -145.31, '2025-07-11T10:50:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'clx000000000000000000000'),
('trans_2025_7_8', 'Phone Bill', -11.29, '2025-07-01T10:51:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_7_9', 'Gas', -134.9, '2025-07-19T10:50:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_7_10', 'Online shopping', -113.91, '2025-07-15T10:02:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_7_11', 'Gas', -12.99, '2025-07-19T19:41:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_7_12', 'Phone Bill', -133.41, '2025-07-27T10:22:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_7_13', 'Online shopping', -113.8, '2025-07-13T10:13:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_7_14', 'Vitamins', -128.93, '2025-07-25T10:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_7_15', 'Phone Bill', -145.54, '2025-07-04T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_7_16', 'Online shopping', -138.61, '2025-07-19T10:12:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_7_17', 'Gas', -125.5, '2025-07-19T10:41:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_7_18', 'Phone Bill', -136.91, '2025-07-19T10:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_jul_2025', 2025, 7, 700.00, 'cat_food_id', 'clx000000000000000000000'),
    ('budget_transport_jul_2025', 2025, 7, 150.00, 'cat_transport_id', 'clx000000000000000000000'),
    ('budget_utilities_jul_2025', 2025, 7, 200.00, 'cat_utilities_id', 'clx000000000000000000000'),
    ('budget_entertainment_jul_2025', 2025, 7, 250.00, 'cat_entertainment_id', 'clx000000000000000000000'),
    ('budget_shopping_jul_2025', 2025, 7, 300.00, 'cat_shopping_id', 'clx000000000000000000000');

-- #############################################
-- #          TEST DATA FOR AUGUST 2025        #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_aug_salary', 'August Salary', 3500.00, '2025-08-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'clx000000000000000000000'),
('trans_aug_rent', 'Rent Payment August', -1200.00, '2025-08-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'clx000000000000000000000'),
('trans_2025_8_1', 'Gas', -145.83, '2025-08-18T10:41:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_8_2', 'Online shopping', -133.2, '2025-08-19T10:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_8_3', 'Phone Bill', -122.31, '2025-08-11T10:43:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_8_4', 'Groceries', -11.8, '2025-08-12T10:44:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'clx000000000000000000000'),
('trans_2025_8_5', 'Online shopping', -142.9, '2025-08-13T10:45:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_8_6', 'Vitamins', -138.1, '2025-08-14T10:46:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_8_7', 'Online course', -129.4, '2025-08-15T10:47:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'clx000000000000000000000'),
('trans_2025_8_8', 'Phone Bill', -115.6, '2025-08-16T10:48:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_8_9', 'Gas', -13.1, '2025-08-17T10:49:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_8_10', 'Online shopping', -141.2, '2025-08-18T10:50:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_8_11', 'Gas', -122.5, '2025-08-19T10:51:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_8_12', 'Phone Bill', -118.9, '2025-08-20T10:52:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_8_13', 'Online shopping', -139.8, '2025-08-21T10:53:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_8_14', 'Vitamins', -125.4, '2025-08-22T10:54:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_8_15', 'Phone Bill', -112.7, '2025-08-23T10:55:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_8_16', 'Online shopping', -147.3, '2025-08-24T10:56:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_8_17', 'Gas', -18.2, '2025-08-25T10:57:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_8_18', 'Phone Bill', -131.5, '2025-08-26T10:58:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_aug_2025', 2025, 8, 700.00, 'cat_food_id', 'clx000000000000000000000'),
    ('budget_transport_aug_2025', 2025, 8, 150.00, 'cat_transport_id', 'clx000000000000000000000'),
    ('budget_utilities_aug_2025', 2025, 8, 200.00, 'cat_utilities_id', 'clx000000000000000000000'),
    ('budget_entertainment_aug_2025', 2025, 8, 250.00, 'cat_entertainment_id', 'clx000000000000000000000'),
    ('budget_shopping_aug_2025', 2025, 8, 300.00, 'cat_shopping_id', 'clx000000000000000000000');

-- #############################################
-- #        TEST DATA FOR SEPTEMBER 2025       #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_sep_salary', 'September Salary', 3500.00, '2025-09-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'clx000000000000000000000'),
('trans_sep_rent', 'Rent Payment September', -1200.00, '2025-09-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'clx000000000000000000000'),
('trans_2025_9_1', 'Gas', -129.6, '2025-09-18T10:41:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_9_2', 'Online shopping', -119.8, '2025-09-19T10:42:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_9_3', 'Phone Bill', -148.1, '2025-09-11T10:43:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_9_4', 'Groceries', -135.7, '2025-09-12T10:44:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'clx000000000000000000000'),
('trans_2025_9_5', 'Online shopping', -122.4, '2025-09-13T10:45:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_9_6', 'Vitamins', -111.9, '2025-09-14T10:46:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_9_7', 'Online course', -149.2, '2025-09-15T10:47:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'clx000000000000000000000'),
('trans_2025_9_8', 'Phone Bill', -130.3, '2025-09-16T10:48:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_9_9', 'Gas', -144.6, '2025-09-17T10:49:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_9_10', 'Online shopping', -126.7, '2025-09-18T10:50:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_9_11', 'Gas', -137.8, '2025-09-19T10:51:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_9_12', 'Phone Bill', -114.5, '2025-09-20T10:52:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_9_13', 'Online shopping', -128.2, '2025-09-21T10:53:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_9_14', 'Vitamins', -140.1, '2025-09-22T10:54:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'clx000000000000000000000'),
('trans_2025_9_15', 'Phone Bill', -132.9, '2025-09-23T10:55:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000'),
('trans_2025_9_16', 'Online shopping', -117.6, '2025-09-24T10:56:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
('trans_2025_9_17', 'Gas', -149.9, '2025-09-25T10:57:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_transport_id', 'clx000000000000000000000'),
('trans_2025_9_18', 'Phone Bill', -124.3, '2025-09-26T10:58:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'clx000000000000000000000');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_sep_2025', 2025, 9, 700.00, 'cat_food_id', 'clx000000000000000000000'),
    ('budget_transport_sep_2025', 2025, 9, 150.00, 'cat_transport_id', 'clx000000000000000000000'),
    ('budget_utilities_sep_2025', 2025, 9, 200.00, 'cat_utilities_id', 'clx000000000000000000000'),
    ('budget_entertainment_sep_2025', 2025, 9, 250.00, 'cat_entertainment_id', 'clx000000000000000000000'),
    ('budget_shopping_sep_2025', 2025, 9, 300.00, 'cat_shopping_id', 'clx000000000000000000000');

-- #############################################
-- #        INSTALLMENTS, LOANS & MISC         #
-- #############################################

-- Insert Counterparties
INSERT INTO "Counterparty" (id, name, phone, email, note, "userId") VALUES
    ('cp_john_doe', 'John Doe', '123-456-7890', 'john.doe@example.com', 'Friend', 'clx000000000000000000000'),
    ('cp_jane_smith', 'Jane Smith', '098-765-4321', 'jane.smith@example.com', 'Co-worker', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Loans
INSERT INTO "Loan" (id, "counterpartyId", principal, "outstandingPrincipal", "issueDate", status, "scheduleType", "termMonths", "userId") VALUES
    ('loan_john_1', 'cp_john_doe', 500.00, 300.00, '2025-07-15T00:00:00Z', 'ACTIVE', 'INTEREST_FREE', 5, 'clx000000000000000000000'),
    ('loan_jane_1', 'cp_jane_smith', 1000.00, 1000.00, '2025-09-01T00:00:00Z', 'ACTIVE', 'INTEREST_FREE', 10, 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Loan Payments
INSERT INTO "LoanPayment" (id, "loanId", date, amount, allocation, note) VALUES
    ('loan_pay_john_1', 'loan_john_1', '2025-08-15T00:00:00Z', 100.00, 'PRINCIPAL', 'First payment'),
    ('loan_pay_john_2', 'loan_john_1', '2025-09-15T00:00:00Z', 100.00, 'PRINCIPAL', 'Second payment')
ON CONFLICT (id) DO NOTHING;

-- Insert Installment Plans
INSERT INTO "InstallmentPlan" (id, description, "totalAmount", installments, "paidPrincipal", "userId") VALUES
    ('plan_phone_id', 'New Smartphone', 1200.00, 12, 100.00, 'clx000000000000000000000'),
    ('plan_laptop_id', 'New Laptop', 3000.00, 6, 500.00, 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Installments for the phone plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_phone_1', 'plan_phone_id', 100.00, '2025-09-01T00:00:00Z', 100.00, 'PAID'),
    ('inst_phone_2', 'plan_phone_id', 100.00, '2025-10-01T00:00:00Z', 0.00, 'PENDING'),
    ('inst_phone_3', 'plan_phone_id', 100.00, '2025-11-01T00:00:00Z', 0.00, 'PENDING');

-- Insert Installments for the laptop plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_laptop_1', 'plan_laptop_id', 500.00, '2025-09-05T00:00:00Z', 500.00, 'PAID'),
    ('inst_laptop_2', 'plan_laptop_id', 500.00, '2025-10-05T00:00:00Z', 0.00, 'PENDING'),
    ('inst_laptop_3', 'plan_laptop_id', 500.00, '2025-11-05T00:00:00Z', 0.00, 'PENDING');

-- Transaction for paying installments
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES 
    ('trans_inst_phone_1', 'Pay phone installment 1', -100.00, '2025-09-01T10:00:00Z', 'INSTALLMENT', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000'),
    ('trans_inst_laptop_1', 'Pay laptop installment 1', -500.00, '2025-09-05T11:00:00Z', 'INSTALLMENT', 'acc_main_bank_id', 'cat_shopping_id', 'clx000000000000000000000');

-- Update the installments as paid
UPDATE "Installment" SET "paidAmount" = 100.00, status = 'PAID', "paidAt" = '2025-09-01T10:00:00Z' WHERE id = 'inst_phone_1';
UPDATE "InstallmentPlan" SET "paidPrincipal" = 100.00 WHERE id = 'plan_phone_id';
UPDATE "Installment" SET "paidAmount" = 500.00, status = 'PAID', "paidAt" = '2025-09-05T11:00:00Z' WHERE id = 'inst_laptop_1';
UPDATE "InstallmentPlan" SET "paidPrincipal" = 500.00 WHERE id = 'plan_laptop_id';