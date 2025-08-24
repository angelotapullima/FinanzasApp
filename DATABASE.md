# Arquitectura y Modelo de Datos

Este documento explica las decisiones de diseño detrás del esquema de la base de datos del proyecto, gestionado a través de Prisma ORM. El esquema fuente se encuentra en `prisma/schema.prisma`.

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
-   **Tipo Específico (`TransactionType.TRANSFER`)**: Un `enum` en el modelo `Transaction` permite clasificar estas operaciones de forma distinta a los gastos e ingresos (`REGULAR`).

**Ventaja**: Al generar reportes de gastos (`SUM(amount) WHERE type = 'REGULAR'`), las transferencias se excluyen automáticamente, resultando en datos precisos y sin inflar las cifras.

---

## 2. Modelo de Presupuestos (Budgets)

**El Reto**: Permitir a los usuarios definir un límite de gasto para una categoría en un período específico (mes/año) y monitorear el progreso.

**La Solución**:

-   **Tabla `Budget`**: Una tabla dedicada almacena el monto (`amount`), el período (`year`, `month`), y la categoría a la que aplica.
-   **Relaciones Claras**: Se relaciona directamente con `User` y `Category`. Una restricción `@@unique` previene presupuestos duplicados para la misma categoría en el mismo mes por el mismo usuario.
-   **Cálculo en el Backend**: La lógica para comparar el gasto real con el presupuesto no reside en la BD, sino en la aplicación. Esta consulta la BD por las transacciones relevantes (`SUM(transactions) WHERE categoryId = ? AND date = ?`) y las compara con el monto del `Budget`.
-   **Rollover**: Un campo booleano `rollover` actúa como un interruptor para que la lógica de negocio decida si el excedente o déficit del mes anterior debe afectar al presupuesto del mes actual.

---

## 3. Preparación para SaaS (Multi-tenancy)

**El Reto**: Garantizar un aislamiento de datos absoluto entre los diferentes usuarios en la futura versión SaaS. Un usuario NUNCA debe poder acceder a los datos de otro.

**La Solución**:

-   **Identificador de Usuario (`userId`) en todo**: Cada tabla que contiene información perteneciente a un usuario (cuentas, transacciones, categorías, presupuestos, etc.) tiene una relación obligatoria con la tabla `User`.
-   **Indexación de `userId`**: Se ha añadido un índice (`@@index([userId])`) en todas las tablas relevantes. Esto es crucial para el rendimiento, ya que casi todas las consultas a la base de datos filtrarán por el `userId` del usuario autenticado.
-   **Disciplina en el Backend**: Este diseño obliga a que toda la lógica de acceso a datos en el backend deba incluir siempre una cláusula `WHERE userId = ?`. Esto previene fugas de datos entre usuarios.

---

## Esquema Completo de Prisma

```prisma
// SPDX-License-Identifier: MIT
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id        String    @id @default(cuid())
  email     String    @unique
  name      String?
  password  String
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt

  accounts      Account[]
  categories    Category[]
  transactions  Transaction[]
  budgets       Budget[]
  loans         Loan[]
  counterparties Counterparty[]
  installmentPlans InstallmentPlan[]
}

model Account {
  id        String   @id @default(cuid())
  name      String
  type      String
  currency  String   @default("PEN")
  balance   Decimal  @default(0)
  createdAt DateTime @default(now())

  user      User     @relation(fields: [userId], references: [id])
  userId    String
  
  @@index([userId])
}

model Category {
  id    String @id @default(cuid())
  name  String
  
  user   User   @relation(fields: [userId], references: [id])
  userId String

  budgets Budget[]

  @@unique([userId, name])
  @@index([userId])
}

model Transaction {
  id          String   @id @default(cuid())
  description String
  amount      Decimal
  date        DateTime
  
  type        TransactionType @default(REGULAR)

  account     Account  @relation(fields: [accountId], references: [id])
  accountId   String
  category    Category @relation(fields: [categoryId], references: [id])
  categoryId  String
  user        User     @relation(fields: [userId], references: [id])
  userId      String

  linkedTransactionId String? @unique

  @@index([userId, date])
}

enum TransactionType {
  REGULAR
  TRANSFER
  LENDING
  INSTALLMENT
}

model Budget {
  id        String   @id @default(cuid())
  year      Int
  month     Int
  amount    Decimal
  rollover  Boolean  @default(false)

  category    Category @relation(fields: [categoryId], references: [id])
  categoryId  String
  user        User     @relation(fields: [userId], references: [id])
  userId      String

  @@unique([userId, categoryId, year, month])
  @@index([userId])
}

model Counterparty {
  id     String @id @default(cuid())
  name   String
  
  user   User   @relation(fields: [userId], references: [id])
  userId String
  loans  Loan[]
  
  @@index([userId])
}

model Loan {
  id                  String   @id @default(cuid())
  principal           Decimal
  outstandingPrincipal Decimal
  issueDate           DateTime
  status              String

  counterparty   Counterparty @relation(fields: [counterpartyId], references: [id])
  counterpartyId String
  user           User         @relation(fields: [userId], references: [id])
  userId         String
  
  @@index([userId])
}

model InstallmentPlan {
  id              String   @id @default(cuid())
  description     String
  totalAmount     Decimal
  installments    Int
  
  user            User     @relation(fields: [userId], references: [id])
  userId          String
  
  @@index([userId])
}
```
