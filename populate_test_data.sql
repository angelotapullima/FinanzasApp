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
TRUNCATE TABLE "Debt" RESTART IDENTITY CASCADE;
TRUNCATE TABLE "DebtPayment" RESTART IDENTITY CASCADE;

-- Ensure the test users exist
INSERT INTO "User" (id, email, name, password, role, "createdAt", "updatedAt", trial_ends_at, is_paid_user, subscription_expires_at)
VALUES 
    ('super_admin_id', 'superadmin@finanzas.com', 'Super Admin', '$2b$10$TBCxtmGcQASxD1E73o0uf.WY3NnD3HDBf07lxoV6lSgvOG6deXNAK', 'SUPER_ADMIN', NOW(), NOW(), NOW() + INTERVAL '7 days', TRUE, NOW() + INTERVAL '30 days'),
    ('admin_id', 'admin@finanzas.com', 'Admin User', '$2b$10$2HO936lrEfFrZSeuUU00selzpXguJdvylxB5lLS2oi5QiGFs.Gple', 'ADMIN', NOW(), NOW(), NOW() + INTERVAL '7 days', FALSE, NULL)
ON CONFLICT (id) DO NOTHING;

-- Insert Categories
INSERT INTO "Category" (id, name, "userId") VALUES
    ('cat_food_id', 'Food', 'super_admin_id'),
    ('cat_transport_id', 'Transport', 'super_admin_id'),
    ('cat_salary_id', 'Salary', 'super_admin_id'),
    ('cat_freelance_id', 'Freelance', 'super_admin_id'),
    ('cat_internal_transfer_id', 'Internal Transfer', 'super_admin_id'),
    ('cat_utilities_id', 'Utilities', 'super_admin_id'),
    ('cat_entertainment_id', 'Entertainment', 'super_admin_id'),
    ('cat_health_id', 'Health', 'super_admin_id'),
    ('cat_shopping_id', 'Shopping', 'super_admin_id'),
    ('cat_education_id', 'Education', 'super_admin_id'),
    ('cat_rent_id', 'Rent', 'super_admin_id'),
    ('cat_travel_id', 'Travel', 'super_admin_id'),
    ('cat_personal_care_id', 'Personal Care', 'super_admin_id'),
    ('cat_gifts_id', 'Gifts', 'super_admin_id'),
    ('cat_subscriptions_id', 'Subscriptions', 'super_admin_id'),
    ('cat_insurance_id', 'Insurance', 'super_admin_id'),
    ('cat_loan_payment_id', 'Loan Payment', 'super_admin_id')
ON CONFLICT (id) DO NOTHING;

-- Insert Accounts
INSERT INTO "Account" (id, name, type, currency, balance, "createdAt", "userId", credit_limit, current_statement_balance, available_credit, statement_due_date, payment_due_date) VALUES
    ('acc_main_bank_id', 'Main Bank Account', 'BANK', 'PEN', 15000.00, NOW(), 'super_admin_id', NULL, NULL, NULL, NULL, NULL),
    ('acc_cash_wallet_id', 'Cash Wallet', 'CASH', 'PEN', 750.00, NOW(), 'super_admin_id', NULL, NULL, NULL, NULL, NULL),
    ('acc_savings_id', 'Savings Account', 'BANK', 'PEN', 30000.00, NOW(), 'super_admin_id', NULL, NULL, NULL, NULL, NULL),
    ('acc_credit_card_visa', 'Visa Platinum', 'CREDIT_CARD', 'PEN', -1500.00, NOW(), 'super_admin_id', 5000.00, 1500.00, 3500.00, '2025-09-25T00:00:00Z', '2025-10-10T00:00:00Z'),
    ('acc_credit_card_master', 'MasterCard Gold', 'CREDIT_CARD', 'PEN', -2200.00, NOW(), 'super_admin_id', 8000.00, 2200.00, 5800.00, '2025-09-28T00:00:00Z', '2025-10-15T00:00:00Z'),
    ('acc_credit_card_amex', 'Amex Green', 'CREDIT_CARD', 'USD', -500.00, NOW(), 'super_admin_id', 2000.00, 500.00, 1500.00, '2025-10-01T00:00:00Z', '2025-10-20T00:00:00Z')
ON CONFLICT (id) DO NOTHING;

-- Update account balances to initial values
UPDATE "Account" SET balance = 15000.00 WHERE id = 'acc_main_bank_id';
UPDATE "Account" SET balance = 750.00 WHERE id = 'acc_cash_wallet_id';
UPDATE "Account" SET balance = 30000.00 WHERE id = 'acc_savings_id';
UPDATE "Account" SET balance = -1500.00, credit_limit = 5000.00, current_statement_balance = 1500.00, available_credit = 3500.00, statement_due_date = '2025-09-25T00:00:00Z', payment_due_date = '2025-10-10T00:00:00Z' WHERE id = 'acc_credit_card_visa';
UPDATE "Account" SET balance = -2200.00, credit_limit = 8000.00, current_statement_balance = 2200.00, available_credit = 5800.00, statement_due_date = '2025-09-28T00:00:00Z', payment_due_date = '2025-10-15T00:00:00Z' WHERE id = 'acc_credit_card_master';
UPDATE "Account" SET balance = -500.00, credit_limit = 2000.00, current_statement_balance = 500.00, available_credit = 1500.00, statement_due_date = '2025-10-01T00:00:00Z', payment_due_date = '2025-10-20T00:00:00Z' WHERE id = 'acc_credit_card_amex';

-- #############################################
-- #           TEST DATA FOR JUNE 2025         #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_jun_salary', 'June Salary', 4000.00, '2025-06-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'super_admin_id'),
('trans_jun_rent', 'Rent Payment June', -1200.00, '2025-06-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'super_admin_id'),
('trans_jun_groceries_1', 'Groceries', -150.00, '2025-06-07T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'super_admin_id'),
('trans_jun_transport_1', 'Bus Fare', -25.00, '2025-06-08T08:30:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'super_admin_id'),
('trans_jun_utilities_1', 'Electricity Bill', -80.00, '2025-06-10T14:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'super_admin_id'),
('trans_jun_entertainment_1', 'Movie Tickets', -40.00, '2025-06-12T19:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_entertainment_id', 'super_admin_id'),
('trans_jun_health_1', 'Dental Checkup', -120.00, '2025-06-15T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'super_admin_id'),
('trans_jun_shopping_1', 'New Shirt', -70.00, '2025-06-18T16:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_shopping_id', 'super_admin_id'),
('trans_jun_education_1', 'Online Course Fee', -200.00, '2025-06-20T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'super_admin_id'),
('trans_jun_travel_1', 'Weekend Trip', -300.00, '2025-06-22T09:00:00Z', 'REGULAR', 'acc_credit_card_master', 'cat_travel_id', 'super_admin_id'),
('trans_jun_personal_care_1', 'Haircut', -30.00, '2025-06-25T17:00:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_personal_care_id', 'super_admin_id'),
('trans_jun_gifts_1', 'Birthday Gift', -50.00, '2025-06-28T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_gifts_id', 'super_admin_id'),
('trans_jun_subscriptions_1', 'Netflix', -15.00, '2025-06-30T08:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_subscriptions_id', 'super_admin_id'),
('trans_jun_insurance_1', 'Car Insurance', -100.00, '2025-06-20T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_insurance_id', 'super_admin_id');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_jun_2025', 2025, 6, 600.00, 'cat_food_id', 'super_admin_id'),
    ('budget_transport_jun_2025', 2025, 6, 100.00, 'cat_transport_id', 'super_admin_id'),
    ('budget_utilities_jun_2025', 2025, 6, 200.00, 'cat_utilities_id', 'super_admin_id'),
    ('budget_entertainment_jun_2025', 2025, 6, 150.00, 'cat_entertainment_id', 'super_admin_id'),
    ('budget_shopping_jun_2025', 2025, 6, 300.00, 'cat_shopping_id', 'super_admin_id'),
    ('budget_health_jun_2025', 2025, 6, 100.00, 'cat_health_id', 'super_admin_id'),
    ('budget_education_jun_2025', 2025, 6, 250.00, 'cat_education_id', 'super_admin_id'),
    ('budget_travel_jun_2025', 2025, 6, 400.00, 'cat_travel_id', 'super_admin_id');

-- #############################################
-- #           TEST DATA FOR JULY 2025         #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_jul_salary', 'July Salary', 4000.00, '2025-07-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'super_admin_id'),
('trans_jul_rent', 'Rent Payment July', -1200.00, '2025-07-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'super_admin_id'),
('trans_jul_groceries_1', 'Groceries', -180.00, '2025-07-07T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'super_admin_id'),
('trans_jul_transport_1', 'Taxi', -35.00, '2025-07-08T08:30:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'super_admin_id'),
('trans_jul_utilities_1', 'Water Bill', -50.00, '2025-07-10T14:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'super_admin_id'),
('trans_jul_entertainment_1', 'Concert Tickets', -100.00, '2025-07-12T19:00:00Z', 'REGULAR', 'acc_credit_card_master', 'cat_entertainment_id', 'super_admin_id'),
('trans_jul_health_1', 'Medication', -60.00, '2025-07-15T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'super_admin_id'),
('trans_jul_shopping_1', 'New Jeans', -90.00, '2025-07-18T16:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_shopping_id', 'super_admin_id'),
('trans_jul_education_1', 'Book for Course', -45.00, '2025-07-20T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'super_admin_id'),
('trans_jul_travel_1', 'Flight to City B', -450.00, '2025-07-22T09:00:00Z', 'REGULAR', 'acc_credit_card_amex', 'cat_travel_id', 'super_admin_id'),
('trans_jul_personal_care_1', 'Spa Day', -70.00, '2025-07-25T17:00:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_personal_care_id', 'super_admin_id'),
('trans_jul_gifts_1', 'Anniversary Gift', -120.00, '2025-07-28T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_gifts_id', 'super_admin_id'),
('trans_jul_subscriptions_1', 'Spotify', -10.00, '2025-07-30T08:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_subscriptions_id', 'super_admin_id'),
('trans_jul_insurance_1', 'Health Insurance', -150.00, '2025-07-20T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_insurance_id', 'super_admin_id');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_jul_2025', 2025, 7, 600.00, 'cat_food_id', 'super_admin_id'),
    ('budget_transport_jul_2025', 2025, 7, 100.00, 'cat_transport_id', 'super_admin_id'),
    ('budget_utilities_jul_2025', 2025, 7, 200.00, 'cat_utilities_id', 'super_admin_id'),
    ('budget_entertainment_jul_2025', 2025, 7, 150.00, 'cat_entertainment_id', 'super_admin_id'),
    ('budget_shopping_jul_2025', 2025, 7, 300.00, 'cat_shopping_id', 'super_admin_id'),
    ('budget_health_jul_2025', 2025, 7, 100.00, 'cat_health_id', 'super_admin_id'),
    ('budget_education_jul_2025', 2025, 7, 250.00, 'cat_education_id', 'super_admin_id'),
    ('budget_travel_jul_2025', 2025, 7, 400.00, 'cat_travel_id', 'super_admin_id');

-- #############################################
-- #          TEST DATA FOR AUGUST 2025        #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_aug_salary', 'August Salary', 4000.00, '2025-08-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'super_admin_id'),
('trans_aug_rent', 'Rent Payment August', -1200.00, '2025-08-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'super_admin_id'),
('trans_aug_groceries_1', 'Groceries', -160.00, '2025-08-07T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'super_admin_id'),
('trans_aug_transport_1', 'Gas Refill', -60.00, '2025-08-08T08:30:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'super_admin_id'),
('trans_aug_utilities_1', 'Internet Bill', -70.00, '2025-08-10T14:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'super_admin_id'),
('trans_aug_entertainment_1', 'Dinner Out', -80.00, '2025-08-12T19:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_entertainment_id', 'super_admin_id'),
('trans_aug_health_1', 'Gym Membership', -40.00, '2025-08-15T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'super_admin_id'),
('trans_aug_shopping_1', 'Electronics', -250.00, '2025-08-18T16:00:00Z', 'REGULAR', 'acc_credit_card_master', 'cat_shopping_id', 'super_admin_id'),
('trans_aug_education_1', 'Software License', -150.00, '2025-08-20T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'super_admin_id'),
('trans_aug_travel_1', 'Hotel Stay', -200.00, '2025-08-22T09:00:00Z', 'REGULAR', 'acc_credit_card_amex', 'cat_travel_id', 'super_admin_id'),
('trans_aug_personal_care_1', 'Massage', -50.00, '2025-08-25T17:00:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_personal_care_id', 'super_admin_id'),
('trans_aug_gifts_1', 'Wedding Gift', -100.00, '2025-08-28T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_gifts_id', 'super_admin_id'),
('trans_aug_subscriptions_1', 'Amazon Prime', -12.00, '2025-08-30T08:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_subscriptions_id', 'super_admin_id'),
('trans_aug_insurance_1', 'Life Insurance', -200.00, '2025-08-20T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_insurance_id', 'super_admin_id');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_aug_2025', 2025, 8, 600.00, 'cat_food_id', 'super_admin_id'),
    ('budget_transport_aug_2025', 2025, 8, 100.00, 'cat_transport_id', 'super_admin_id'),
    ('budget_utilities_aug_2025', 2025, 8, 200.00, 'cat_utilities_id', 'super_admin_id'),
    ('budget_entertainment_aug_2025', 2025, 8, 150.00, 'cat_entertainment_id', 'super_admin_id'),
    ('budget_shopping_aug_2025', 2025, 8, 300.00, 'cat_shopping_id', 'super_admin_id'),
    ('budget_health_aug_2025', 2025, 8, 100.00, 'cat_health_id', 'super_admin_id'),
    ('budget_education_aug_2025', 2025, 8, 250.00, 'cat_education_id', 'super_admin_id'),
    ('budget_travel_aug_2025', 2025, 8, 400.00, 'cat_travel_id', 'super_admin_id');

-- #############################################
-- #        TEST DATA FOR SEPTEMBER 2025       #
-- #############################################
INSERT INTO "Transaction" (id, description, amount, date, type, "accountId", "categoryId", "userId") VALUES
('trans_sep_salary', 'September Salary', 4000.00, '2025-09-01T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_salary_id', 'super_admin_id'),
('trans_sep_rent', 'Rent Payment September', -1200.00, '2025-09-05T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_rent_id', 'super_admin_id'),
('trans_sep_groceries_1', 'Groceries', -170.00, '2025-09-07T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_food_id', 'super_admin_id'),
('trans_sep_transport_1', 'Fuel', -70.00, '2025-09-08T08:30:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_transport_id', 'super_admin_id'),
('trans_sep_utilities_1', 'Phone Bill', -90.00, '2025-09-10T14:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_utilities_id', 'super_admin_id'),
('trans_sep_entertainment_1', 'Streaming Service', -20.00, '2025-09-12T19:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_entertainment_id', 'super_admin_id'),
('trans_sep_health_1', 'Pharmacy', -30.00, '2025-09-15T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_health_id', 'super_admin_id'),
('trans_sep_shopping_1', 'Clothes', -120.00, '2025-09-18T16:00:00Z', 'REGULAR', 'acc_credit_card_master', 'cat_shopping_id', 'super_admin_id'),
('trans_sep_education_1', 'Workshop Fee', -80.00, '2025-09-20T11:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_education_id', 'super_admin_id'),
('trans_sep_travel_1', 'Local Excursion', -150.00, '2025-09-22T09:00:00Z', 'REGULAR', 'acc_credit_card_amex', 'cat_travel_id', 'super_admin_id'),
('trans_sep_personal_care_1', 'Manicure', -25.00, '2025-09-25T17:00:00Z', 'REGULAR', 'acc_cash_wallet_id', 'cat_personal_care_id', 'super_admin_id'),
('trans_sep_gifts_1', 'Friend Gift', -40.00, '2025-09-28T10:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_gifts_id', 'super_admin_id'),
('trans_sep_subscriptions_1', 'Gym Membership', -30.00, '2025-09-30T08:00:00Z', 'REGULAR', 'acc_credit_card_visa', 'cat_subscriptions_id', 'super_admin_id'),
('trans_sep_insurance_1', 'Home Insurance', -180.00, '2025-09-20T09:00:00Z', 'REGULAR', 'acc_main_bank_id', 'cat_insurance_id', 'super_admin_id');

INSERT INTO "Budget" (id, year, month, amount, "categoryId", "userId") VALUES
    ('budget_food_sep_2025', 2025, 9, 600.00, 'cat_food_id', 'super_admin_id'),
    ('budget_transport_sep_2025', 2025, 9, 100.00, 'cat_transport_id', 'super_admin_id'),
    ('budget_utilities_sep_2025', 2025, 9, 200.00, 'cat_utilities_id', 'super_admin_id'),
    ('budget_entertainment_sep_2025', 2025, 9, 150.00, 'cat_entertainment_id', 'super_admin_id'),
    ('budget_shopping_sep_2025', 2025, 9, 300.00, 'cat_shopping_id', 'super_admin_id'),
    ('budget_health_sep_2025', 2025, 9, 100.00, 'cat_health_id', 'super_admin_id'),
    ('budget_education_sep_2025', 2025, 9, 250.00, 'cat_education_id', 'super_admin_id'),
    ('budget_travel_sep_2025', 2025, 9, 400.00, 'cat_travel_id', 'super_admin_id');

-- #############################################
-- #        INSTALLMENTS, LOANS & DEBTS        #
-- #############################################

-- Insert Counterparties
INSERT INTO "Counterparty" (id, name, phone, email, note, "userId") VALUES
    ('cp_john_doe', 'John Doe', '123-456-7890', 'john.doe@example.com', 'Friend', 'super_admin_id'),
    ('cp_jane_smith', 'Jane Smith', '098-765-4321', 'jane.smith@example.com', 'Co-worker', 'super_admin_id'),
    ('cp_bank_loan_dept', 'Bank Loan Department', NULL, NULL, 'Bank for personal loan', 'super_admin_id'),
    ('cp_car_dealership', 'Luxury Motors', NULL, NULL, 'Car Loan Provider', 'super_admin_id'),
    ('cp_furniture_store', 'Home Furnishings', NULL, NULL, 'Furniture Store', 'super_admin_id'),
    ('cp_electronics_store', 'Tech Gadgets Inc.', NULL, NULL, 'Electronics Store', 'super_admin_id')
ON CONFLICT (id) DO NOTHING;

-- Insert Loans (Lending Personal)
INSERT INTO "Loan" (id, "counterpartyId", principal, "outstandingPrincipal", "issueDate", status, "scheduleType", "termMonths", "userId", "interestRate") VALUES
    ('loan_john_1', 'cp_john_doe', 500.00, 300.00, '2025-07-15T00:00:00Z', 'ACTIVE', 'INTEREST_FREE', 5, 'super_admin_id', NULL),
    ('loan_jane_1', 'cp_jane_smith', 1000.00, 1000.00, '2025-09-01T00:00:00Z', 'ACTIVE', 'INTEREST_FREE', 10, 'super_admin_id', NULL),
    ('loan_family_member', 'cp_john_doe', 2000.00, 1800.00, '2025-08-01T00:00:00Z', 'ACTIVE', 'SIMPLE', 12, 'super_admin_id', 0.02)
ON CONFLICT (id) DO NOTHING;

-- Insert Loan Payments
INSERT INTO "LoanPayment" (id, "loanId", date, amount, allocation, note) VALUES
    ('loan_pay_john_1', 'loan_john_1', '2025-08-15T00:00:00Z', 100.00, 'PRINCIPAL', 'First payment'),
    ('loan_pay_john_2', 'loan_john_1', '2025-09-15T00:00:00Z', 100.00, 'PRINCIPAL', 'Second payment'),
    ('loan_pay_family_1', 'loan_family_member', '2025-09-01T00:00:00Z', 200.00, 'PRINCIPAL', 'First payment')
ON CONFLICT (id) DO NOTHING;

-- Insert Installment Plans
INSERT INTO "InstallmentPlan" (id, description, "totalAmount", installments, "paidPrincipal", "userId") VALUES
    ('plan_phone_id', 'New Smartphone', 1200.00, 12, 200.00, 'super_admin_id'),
    ('plan_laptop_id', 'New Laptop', 3000.00, 6, 1000.00, 'super_admin_id'),
    ('plan_tv_id', 'Smart TV', 800.00, 8, 0.00, 'super_admin_id'),
    ('plan_bike_id', 'Mountain Bike', 1500.00, 10, 150.00, 'super_admin_id'),
    ('plan_camera_id', 'Professional Camera', 2400.00, 12, 0.00, 'super_admin_id'), -- New 12-month plan
    ('plan_soundbar_id', 'Soundbar System', 600.00, 6, 0.00, 'super_admin_id') -- New 6-month plan
ON CONFLICT (id) DO NOTHING;

-- Insert Installments for phone plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_phone_1', 'plan_phone_id', 100.00, '2025-08-01T00:00:00Z', 100.00, 'PAID'),
    ('inst_phone_2', 'plan_phone_id', 100.00, '2025-09-01T00:00:00Z', 100.00, 'PAID'),
    ('inst_phone_3', 'plan_phone_id', 100.00, '2025-10-01T00:00:00Z', 0.00, 'PENDING'),
    ('inst_phone_4', 'plan_phone_id', 100.00, '2025-11-01T00:00:00Z', 0.00, 'PENDING'),
    ('inst_phone_5', 'plan_phone_id', 100.00, '2025-12-01T00:00:00Z', 0.00, 'PENDING');

-- Insert Installments for laptop plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_laptop_1', 'plan_laptop_id', 500.00, '2025-08-05T00:00:00Z', 500.00, 'PAID'),
    ('inst_laptop_2', 'plan_laptop_id', 500.00, '2025-09-05T00:00:00Z', 500.00, 'PAID'),
    ('inst_laptop_3', 'plan_laptop_id', 500.00, '2025-10-05T00:00:00Z', 0.00, 'PENDING'),
    ('inst_laptop_4', 'plan_laptop_id', 500.00, '2025-11-05T00:00:00Z', 0.00, 'PENDING');

-- Insert Installments for TV plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_tv_1', 'plan_tv_id', 100.00, '2025-10-10T00:00:00Z', 0.00, 'PENDING'),
    ('inst_tv_2', 'plan_tv_id', 100.00, '2025-11-10T00:00:00Z', 0.00, 'PENDING');

-- Insert Installments for bike plan
INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
    ('inst_bike_1', 'plan_bike_id', 150.00, '2025-09-15T00:00:00Z', 150.00, 'PAID'),
    ('inst_bike_2', 'plan_bike_id', 150.00, '2025-10-15T00:00:00Z', 0.00, 'PENDING');

-- Insert Installments for camera plan (12 months)
DO $$
DECLARE
    plan_id VARCHAR := 'plan_camera_id';
    start_date TIMESTAMP WITH TIME ZONE := '2025-09-01T00:00:00Z';
    installment_amount NUMERIC := 200.00; -- 2400 / 12
    i INT;
BEGIN
    FOR i IN 1..12 LOOP
        INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
        (
            'inst_camera_' || i,
            plan_id,
            installment_amount,
            start_date + (i - 1) * INTERVAL '1 month',
            CASE WHEN i <= 1 THEN installment_amount ELSE 0.00 END, -- First payment paid
            CASE WHEN i <= 1 THEN 'PAID' ELSE 'PENDING' END
        );
    END LOOP;
END $$;

-- Insert Installments for soundbar plan (6 months)
DO $$
DECLARE
    plan_id VARCHAR := 'plan_soundbar_id';
    start_date TIMESTAMP WITH TIME ZONE := '2025-09-20T00:00:00Z';
    installment_amount NUMERIC := 100.00; -- 600 / 6
    i INT;
BEGIN
    FOR i IN 1..6 LOOP
        INSERT INTO "Installment" (id, "installmentPlanId", amount, "dueDate", "paidAmount", status) VALUES
        (
            'inst_soundbar_' || i,
            plan_id,
            installment_amount,
            start_date + (i - 1) * INTERVAL '1 month',
            CASE WHEN i <= 1 THEN installment_amount ELSE 0.00 END, -- First payment paid
            CASE WHEN i <= 1 THEN 'PAID' ELSE 'PENDING' END
        );
    END LOOP;
END $$;

-- Update the installments as paid (for new plans)
UPDATE "Installment" SET "paidAmount" = 200.00, status = 'PAID', "paidAt" = '2025-09-01T00:00:00Z' WHERE id = 'inst_camera_1';
UPDATE "InstallmentPlan" SET "paidPrincipal" = 200.00 WHERE id = 'plan_camera_id';

UPDATE "Installment" SET "paidAmount" = 100.00, status = 'PAID', "paidAt" = '2025-09-20T00:00:00Z' WHERE id = 'inst_soundbar_1';
UPDATE "InstallmentPlan" SET "paidPrincipal" = 100.00 WHERE id = 'plan_soundbar_id';


-- Insert Debts
INSERT INTO "Debt" (id, lender_name, original_amount, outstanding_balance, interest_rate, start_date, end_date, payment_frequency, next_payment_date, next_payment_amount, status, "userId") VALUES
    ('debt_bank_loan_1', 'Bank of America', 10000.00, 7000.00, 0.05, '2024-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'Monthly', '2025-10-01T00:00:00Z', 500.00, 'ACTIVE', 'super_admin_id'),
    ('debt_friend_loan_1', 'Alice Johnson', 500.00, 150.00, NULL, '2025-05-10T00:00:00Z', '2025-11-10T00:00:00Z', 'Bi-Weekly', '2025-09-20T00:00:00Z', 50.00, 'ACTIVE', 'super_admin_id'),
    ('debt_car_loan_1', 'Car Dealership', 15000.00, 14400.00, 0.07, '2025-09-01T00:00:00Z', '2030-09-01T00:00:00Z', 'Monthly', '2025-10-01T00:00:00Z', 300.00, 'ACTIVE', 'super_admin_id'),
    ('debt_personal_loan_2', 'Family Member', 2000.00, 1600.00, 0.03, '2025-07-01T00:00:00Z', '2026-07-01T00:00:00Z', 'Monthly', '2025-10-01T00:00:00Z', 150.00, 'ACTIVE', 'super_admin_id'),
    ('debt_student_loan', 'Student Loan Co.', 20000.00, 19250.00, 0.04, '2024-09-01T00:00:00Z', '2034-09-01T00:00:00Z', 'Monthly', '2025-10-25T00:00:00Z', 250.00, 'ACTIVE', 'super_admin_id'),
    ('debt_medical_bill', 'Hospital', 1000.00, 1000.00, NULL, '2025-09-10T00:00:00Z', '2026-03-10T00:00:00Z', 'Monthly', '2025-10-10T00:00:00Z', 100.00, 'ACTIVE', 'super_admin_id')
ON CONFLICT (id) DO NOTHING;

-- Insert Debt Payments
INSERT INTO "DebtPayment" (id, "debtId", date, amount, allocation, note) VALUES
    ('debt_pay_bank_1', 'debt_bank_loan_1', '2025-08-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_2', 'debt_bank_loan_1', '2025-09-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_3', 'debt_bank_loan_1', '2025-10-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_4', 'debt_bank_loan_1', '2025-11-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_5', 'debt_bank_loan_1', '2025-12-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_6', 'debt_bank_loan_1', '2026-01-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_7', 'debt_bank_loan_1', '2026-02-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_8', 'debt_bank_loan_1', '2026-03-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_9', 'debt_bank_loan_1', '2026-04-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_10', 'debt_bank_loan_1', '2026-05-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_11', 'debt_bank_loan_1', '2026-06-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_bank_12', 'debt_bank_loan_1', '2026-07-01T00:00:00Z', 500.00, 'PRINCIPAL', 'Monthly payment'),
    ('debt_pay_friend_1', 'debt_friend_loan_1', '2025-09-06T00:00:00Z', 50.00, 'PRINCIPAL', 'Bi-weekly payment'),
    ('debt_pay_personal_1', 'debt_personal_loan_2', '2025-09-15T00:00:00Z', 100.00, 'PRINCIPAL', 'First payment'),
    ('debt_pay_student_1', 'debt_student_loan', '2025-09-25T00:00:00Z', 250.00, 'PRINCIPAL', 'Monthly payment')
ON CONFLICT (id) DO NOTHING;
