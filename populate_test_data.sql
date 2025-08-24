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

-- Ensure the test user exists (if not already created manually)
INSERT INTO "User" (id, email, name, password, "createdAt", "updatedAt")
VALUES ('clx000000000000000000000', 'test@finanzas.com', 'Test User', 'test_password_hash', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert Categories (if not already existing)
INSERT INTO "Category" (id, name, "userId")
VALUES
    ('cat_food_id', 'Food', 'clx000000000000000000000'),
    ('cat_transport_id', 'Transport', 'clx000000000000000000000'),
    ('cat_salary_id', 'Salary', 'clx000000000000000000000'),
    ('cat_internal_transfer_id', 'Internal Transfer', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Accounts (if not already existing)
INSERT INTO "Account" (id, name, type, currency, balance, "createdAt", "userId")
VALUES
    ('acc_main_bank_id', 'Main Bank Account', 'BANK', 'PEN', 1000.00, NOW(), 'clx000000000000000000000'),
    ('acc_cash_wallet_id', 'Cash Wallet', 'CASH', 'PEN', 200.00, NOW(), 'clx000000000000000000000'),
    ('acc_savings_id', 'Savings Account', 'BANK', 'PEN', 5000.00, NOW(), 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Update account balances to initial values (in case they were changed by previous tests)
UPDATE "Account" SET balance = 1000.00 WHERE id = 'acc_main_bank_id' AND "userId" = 'clx000000000000000000000';
UPDATE "Account" SET balance = 200.00 WHERE id = 'acc_cash_wallet_id' AND "userId" = 'clx000000000000000000000';
UPDATE "Account" SET balance = 5000.00 WHERE id = 'acc_savings_id' AND "userId" = 'clx000000000000000000000';


-- Insert Transactions (ensure no duplicates by checking linkedTransactionId for transfers)
-- Regular Expense
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId")
VALUES ('trans_exp_1', 'Groceries', -50.00, '2025-08-20T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Regular Income
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId")
VALUES ('trans_inc_1', 'Monthly Salary', 1500.00, '2025-08-22T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Transfer (Debit from Main Bank, Credit to Cash Wallet)
-- Generate a linked ID for the transfer
DO $$ 
DECLARE
    linked_id VARCHAR(255) := 'transfer_link_1';
BEGIN
    INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId", "linkedTransactionId")
    VALUES ('trans_transfer_debit_1', 'Transfer to Cash Wallet', -100.00, '2025-08-21T15:00:00Z', 'TRANSFER', 'acc_main_bank_id', 'cat_internal_transfer_id', 'clx000000000000000000000', linked_id)
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId", "linkedTransactionId")
    VALUES ('trans_transfer_credit_1', 'Transfer from Main Bank Account', 100.00, '2025-08-21T15:00:00Z', 'TRANSFER', 'acc_cash_wallet_id', 'cat_internal_transfer_id', 'clx000000000000000000000', linked_id)
    ON CONFLICT ("linkedTransactionId") DO NOTHING; 
END $$;

-- Insert Budgets
INSERT INTO "Budget" (id, year, month, amount, rollover, "categoryId", "userId")
VALUES
    ('budget_food_aug_2025', 2025, 8, 300.00, FALSE, 'cat_food_id', 'clx000000000000000000000'),
    ('budget_transport_aug_2025', 2025, 8, 150.00, TRUE, 'cat_transport_id', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Installment Plans
INSERT INTO "InstallmentPlan" (id, description, "totalAmount", installments, "paidPrincipal", "userId")
VALUES
    ('plan_phone_id', 'New Smartphone', 1200.00, 12, 0.00, 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert a few Installments for the phone plan (assuming 100.00 per month)
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status)
VALUES
    ('inst_phone_1', 'plan_phone_id', 100.00, '2025-09-01T00:00:00Z', 0.00, 'PENDING'),
    ('inst_phone_2', 'plan_phone_id', 100.00, '2025-10-01T00:00:00Z', 0.00, 'PENDING'),
    ('inst_phone_3', 'plan_phone_id', 100.00, '2025-11-01T00:00:00Z', 0.00, 'PENDING')
ON CONFLICT (id) DO NOTHING;

-- Insert Counterparties
INSERT INTO "Counterparty" (id, name, phone, email, note, "userId")
VALUES
    ('cp_john_doe', 'John Doe', '123-456-7890', 'john.doe@example.com', 'Friend', 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Loans
INSERT INTO "Loan" (id, "counterpartyId", principal, "outstandingPrincipal", "issueDate", status, "interestRate", "scheduleType", "termMonths", "userId")
VALUES
    ('loan_john_1', 'cp_john_doe', 500.00, 500.00, '2025-07-15T00:00:00Z', 'ACTIVE', NULL, 'INTEREST_FREE', 5, 'clx000000000000000000000')
ON CONFLICT (id) DO NOTHING;

-- Insert Loan Payments
INSERT INTO "LoanPayment" (id, "loanId", date, amount, allocation, note)
VALUES
    ('loan_pay_john_1', 'loan_john_1', '2025-08-15T00:00:00Z', 100.00, 'PRINCIPAL', 'First payment')
ON CONFLICT (id) DO NOTHING;