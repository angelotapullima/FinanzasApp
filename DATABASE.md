# Arquitectura y Modelo de Datos

Este documento explica las decisiones de diseño detrás del esquema de la base de datos del proyecto, que se gestiona mediante scripts de SQL puro. El script de creación de la estructura se encuentra en `create_db.sql`.

## Filosofía General

El modelo de datos está diseñado con tres principios en mente:

1.  **Claridad**: La estructura debe ser fácil de entender.
2.  **Robustez**: Debe garantizar la integridad de los datos financieros.
3.  **Escalabilidad**: Debe estar preparado para la futura versión SaaS multiusuario.

---

## 1. Manejo de Transferencias Internas

**El Reto**: Una transferencia entre cuentas propias (ej: Banco -> Efectivo) no es un gasto ni un ingreso real. Debe ser neutral en los reportes financieros.

**La Solución**:

Se modela una transferencia como un par de transacciones enlazadas con un tipo especial.

-   **Dos Transacciones**: Se crea una transacción de salida en la cuenta de origen y una de entrada en la cuenta de destino.
-   **Enlace (`linkedTransactionId`)**: Un campo opcional y único que conecta las dos transacciones, asegurando su atomicidad a nivel de aplicación.
-   **Tipo Específico (`TransactionType.TRANSFER`)**: Un tipo `ENUM` en la tabla `Transaction` permite clasificar estas operaciones de forma distinta a los gastos e ingresos (`REGULAR`).

**Ventaja**: Al generar reportes de gastos (`SUM(amount) WHERE type = 'REGULAR'`), las transferencias se excluyen automáticamente, resultando en datos precisos y sin inflar las cifras.

---

## 2. Modelo de Presupuestos (Budgets)

**El Reto**: Permitir a los usuarios definir un límite de gasto para una categoría en un período específico (mes/año) y monitorear el progreso.

**La Solución**:

-   **Tabla `Budget`**: Una tabla dedicada almacena el monto (`amount`), el período (`year`, `month`), y la categoría a la que aplica.
-   **Relaciones Claras**: Se relaciona directamente con `User` y `Category`. Una restricción `UNIQUE` previene presupuestos duplicados para la misma categoría en el mismo mes por el mismo usuario.
-   **Cálculo en el Backend**: La lógica para comparar el gasto real con el presupuesto no reside en la BD, sino en la aplicación. Esta consulta la BD por las transacciones relevantes (`SUM(transactions) WHERE categoryId = ? AND date = ?`) y las compara con el monto del `Budget`.
-   **Rollover**: Un campo booleano `rollover` actúa como un interruptor para que la lógica de negocio decida si el excedente o déficit del mes anterior debe afectar al presupuesto del mes actual.

---

## 3. Preparación para SaaS (Multi-tenancy)

**El Reto**: Garantizar un aislamiento de datos absoluto entre los diferentes usuarios en la futura versión SaaS. Un usuario NUNCA debe poder acceder a los datos de otro.

**La Solución**:

-   **Identificador de Usuario (`userId`) en todo**: Cada tabla que contiene información perteneciente a un usuario (cuentas, transacciones, categorías, presupuestos, etc.) tiene una relación obligatoria con la tabla `User` a través de una clave foránea.
-   **Indexación de `userId`**: Se ha añadido un índice en la columna `userId` en todas las tablas relevantes. Esto es crucial para el rendimiento, ya que casi todas las consultas a la base de datos filtrarán por el `userId` del usuario autenticado.
-   **Disciplina en el Backend**: Este diseño obliga a que toda la lógica de acceso a datos en el backend deba incluir siempre una cláusula `WHERE userId = ?`. Esto previene fugas de datos entre usuarios.

---

## Esquema SQL Completo (`create_db.sql`)

A continuación se muestra el script SQL completo que define la estructura de la base de datos.

```sql
-- Eliminar tablas si existen (en orden inverso de dependencia)
DROP TABLE IF EXISTS "Installment";
DROP TABLE IF EXISTS "InstallmentPlan";
DROP TABLE IF EXISTS "LoanPayment";
DROP TABLE IF EXISTS "Loan";
DROP TABLE IF EXISTS "Counterparty";
DROP TABLE IF EXISTS "Budget";
DROP TABLE IF EXISTS "Transaction";
DROP TABLE IF EXISTS "Account";
DROP TABLE IF EXISTS "Category";
DROP TABLE IF EXISTS "User";

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
```