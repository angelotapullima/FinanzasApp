-- Eliminar tablas si existen (en orden inverso de dependencia)
DROP TABLE IF EXISTS "Installment" CASCADE;
DROP TABLE IF EXISTS "InstallmentPlan" CASCADE;
DROP TABLE IF EXISTS "LoanPayment" CASCADE;
DROP TABLE IF EXISTS "Loan" CASCADE;
DROP TABLE IF EXISTS "Counterparty" CASCADE;
DROP TABLE IF EXISTS "Budget" CASCADE;
DROP TABLE IF EXISTS "Transaction" CASCADE;
DROP TABLE IF EXISTS "Account" CASCADE;
DROP TABLE IF EXISTS "Category" CASCADE;
DROP TABLE IF EXISTS "DebtPayment" CASCADE; -- Added CASCADE
DROP TABLE IF EXISTS "Debt" CASCADE; -- Added CASCADE
DROP TABLE IF EXISTS "User" CASCADE;

-- Eliminar tipos ENUM si existen
DROP TYPE IF EXISTS "TransactionType";
DROP TYPE IF EXISTS "LoanScheduleType";
DROP TYPE IF EXISTS "LoanPaymentAllocation";
DROP TYPE IF EXISTS user_role;

-- Crear tipos ENUM
CREATE TYPE "TransactionType" AS ENUM ('REGULAR', 'TRANSFER', 'LENDING', 'INSTALLMENT');
CREATE TYPE "LoanScheduleType" AS ENUM ('INTEREST_FREE', 'SIMPLE', 'FIXED');
CREATE TYPE "LoanPaymentAllocation" AS ENUM ('PRINCIPAL', 'INTEREST', 'FEE');
CREATE TYPE user_role AS ENUM ('SUPER_ADMIN', 'ADMIN');

-- Crear tabla User
CREATE TABLE "User" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'ADMIN',
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" TIMESTAMP WITH TIME ZONE NOT NULL,
    trial_ends_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '7 days',
    is_paid_user BOOLEAN DEFAULT FALSE,
    subscription_expires_at TIMESTAMP WITH TIME ZONE
);

-- Crear tabla Account
CREATE TABLE "Account" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    currency VARCHAR(255) DEFAULT 'PEN' NOT NULL,
    balance NUMERIC(18, 2) DEFAULT 0 NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    credit_limit NUMERIC(18, 2),
    current_statement_balance NUMERIC(18, 2),
    available_credit NUMERIC(18, 2),
    statement_due_date TIMESTAMP WITH TIME ZONE,
    payment_due_date TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_account_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_account_user_id ON "Account" ("userId");

-- Crear tabla Category
CREATE TABLE "Category" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    name VARCHAR(255) NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_category_user FOREIGN KEY ("userId") REFERENCES "User"(id),
    UNIQUE ("userId", name)
);
CREATE INDEX idx_category_user_id ON "Category" ("userId");

-- Crear tabla Transaction
CREATE TABLE "Transaction" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    description VARCHAR(255) NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    type "TransactionType" DEFAULT 'REGULAR' NOT NULL,
    "accountId" VARCHAR(255) NOT NULL,
    "categoryId" VARCHAR(255) NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    "linkedTransactionId" VARCHAR(255) UNIQUE,
    CONSTRAINT fk_transaction_account FOREIGN KEY ("accountId") REFERENCES "Account"(id),
    CONSTRAINT fk_transaction_category FOREIGN KEY ("categoryId") REFERENCES "Category"(id),
    CONSTRAINT fk_transaction_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_transaction_user_id_date ON "Transaction" ("userId", date);

-- Crear tabla Budget
CREATE TABLE "Budget" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    year INT NOT NULL,
    month INT NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    rollover BOOLEAN DEFAULT FALSE NOT NULL,
    "categoryId" VARCHAR(255) NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_budget_category FOREIGN KEY ("categoryId") REFERENCES "Category"(id),
    CONSTRAINT fk_budget_user FOREIGN KEY ("userId") REFERENCES "User"(id),
    UNIQUE ("userId", "categoryId", year, month)
);
CREATE INDEX idx_budget_user_id ON "Budget" ("userId");

-- Crear tabla Counterparty
CREATE TABLE "Counterparty" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    email VARCHAR(255),
    note TEXT,
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_counterparty_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_counterparty_user_id ON "Counterparty" ("userId");

-- Crear tabla Loan
CREATE TABLE "Loan" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    principal NUMERIC(18, 2) NOT NULL,
    "outstandingPrincipal" NUMERIC(18, 2) NOT NULL,
    "issueDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(255) NOT NULL, -- e.g., 'ACTIVE', 'CLOSED', 'DEFAULTED'
    "interestRate" NUMERIC(5, 4), -- Tasa de interés, e.g., 0.05 para 5%
    "scheduleType" "LoanScheduleType",
    "termMonths" INT,
    "counterpartyId" VARCHAR(255) NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_loan_counterparty FOREIGN KEY ("counterpartyId") REFERENCES "Counterparty"(id),
    CONSTRAINT fk_loan_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_loan_user_id ON "Loan" ("userId");

-- Crear tabla LoanPayment
CREATE TABLE "LoanPayment" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    "loanId" VARCHAR(255) NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    allocation "LoanPaymentAllocation" NOT NULL,
    note TEXT,
    CONSTRAINT fk_loan_payment_loan FOREIGN KEY ("loanId") REFERENCES "Loan"(id)
);

-- Crear tabla InstallmentPlan
CREATE TABLE "InstallmentPlan" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    description VARCHAR(255) NOT NULL,
    "totalAmount" NUMERIC(18, 2) NOT NULL,
    installments INT NOT NULL,
    "paidPrincipal" NUMERIC(18, 2) DEFAULT 0 NOT NULL,
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_installment_plan_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_installment_plan_user_id ON "InstallmentPlan" ("userId");

-- Crear tabla Installment
CREATE TABLE "Installment" (
    id VARCHAR(255) PRIMARY KEY, -- Asume que el CUID es generado por la aplicación
    "installmentPlanId" VARCHAR(255) NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    "dueDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "paidAmount" NUMERIC(18, 2) DEFAULT 0 NOT NULL,
    "paidAt" TIMESTAMP WITH TIME ZONE,
    status VARCHAR(255) NOT NULL, -- e.g., 'PENDING', 'PAID', 'PARTIAL'
    CONSTRAINT fk_installment_installment_plan FOREIGN KEY ("installmentPlanId") REFERENCES "InstallmentPlan"(id)
);

-- Crear tabla Debt
CREATE TABLE "Debt" (
    id VARCHAR(255) PRIMARY KEY,
    lender_name VARCHAR(255) NOT NULL,
    original_amount NUMERIC(18, 2) NOT NULL,
    outstanding_balance NUMERIC(18, 2) NOT NULL,
    interest_rate NUMERIC(5, 4),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    payment_frequency VARCHAR(50),
    next_payment_date TIMESTAMP WITH TIME ZONE,
    next_payment_amount NUMERIC(18, 2),
    status VARCHAR(50) NOT NULL, -- e.g., 'ACTIVE', 'PAID', 'DEFAULTED'
    "userId" VARCHAR(255) NOT NULL,
    CONSTRAINT fk_debt_user FOREIGN KEY ("userId") REFERENCES "User"(id)
);
CREATE INDEX idx_debt_user_id ON "Debt" ("userId");

-- Crear tabla DebtPayment
CREATE TABLE "DebtPayment" (
    id VARCHAR(255) PRIMARY KEY,
    "debtId" VARCHAR(255) NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    allocation "LoanPaymentAllocation" NOT NULL, -- Reutilizando el ENUM existente
    note TEXT,
    CONSTRAINT fk_debt_payment_debt FOREIGN KEY ("debtId") REFERENCES "Debt"(id)
);
