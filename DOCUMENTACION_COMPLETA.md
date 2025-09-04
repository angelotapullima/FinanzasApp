# DOCUMENTACIÓN COMPLETA DEL SISTEMA DE FINANZAS PERSONALES

## 📋 ÍNDICE

1.  [Arquitectura General](#arquitectura-general)
2.  [Backend - API REST](#backend---api-rest)
3.  [Frontend - Aplicación Vue.js](#frontend---aplicación-vuejs)
4.  [Flujo de Datos](#flujo-de-datos)
5.  [Lógica de Negocio por Módulo](#lógica-de-negocio-por-módulo)

---

## 🏗️ ARQUITECTURA GENERAL

### Stack Tecnológico

**Backend:**
- Node.js + Express.js (o similar modularización)
- TypeScript
- PostgreSQL (Base de datos)
- SQL Puro (para interacciones con la base de datos)
- Autenticación (JWT)
- Roles (RBAC)

**Frontend:**
- Vue.js 3
- Shadcn UI (Componentes de UI construidos sobre Radix Vue y Tailwind CSS)
- Pinia (State Management)
- Vue Router
- Tailwind CSS
- Fetch API (para llamadas a la API, gestionado en `src/services/apiService.ts`)

### Arquitectura General

```
Frontend (Vue.js) ←→ API REST (Node.js/Express.js) ←→ Base de Datos (PostgreSQL)
```

---

## 🖥️ BACKEND - API REST (en la carpeta FinanzasBackend)

### Estructura de Directorios (Ejemplo)

```
src/
├── config/          # Configuración de la base de datos
├── middleware/      # Middlewares de Express (ej. autenticación, roles)
├── repositories/    # Interacción directa con la base de datos (SQL Puro)
│   └── userRepository.ts # Repositorio para usuarios
├── routes/          # Definición de rutas
│   ├── authRoutes.ts    # Rutas de autenticación (login, registro)
│   └── userRoutes.ts    # Rutas para gestión de usuarios
├── services/        # Lógica de negocio
│   ├── authService.ts   # Lógica de autenticación
│   └── userService.ts   # Lógica de gestión de usuarios
└── index.ts         # Entrada del servidor
```

### 🔗 ENDPOINTS DISPONIBLES (Resumen)

Todos los endpoints están prefijados con `/api`.

| Módulo | Endpoints Comunes |
| :--- | :--- |
| **Autenticación** | `POST /auth/login` |
| **Usuarios** | `GET /users`, `POST /users`, `GET /users/:id`, `PUT /users/:id`, `DELETE /users/:id` |
| **Cuentas** | `GET /accounts`, `POST /accounts`, `GET /accounts/:id`, `PUT /accounts/:id`, `DELETE /accounts/:id` |
| **Transacciones** | `GET /transactions`, `POST /transactions/regular`, `POST /transactions/transfer`, `GET /transactions/:id`, `PUT /transactions/:id`, `DELETE /transactions/:id` |
| **Categorías** | `GET /categories`, `POST /categories`, `GET /categories/:id`, `PUT /categories/:id`, `DELETE /categories/:id` |
| **Presupuestos** | `GET /budgets`, `POST /budgets`, `GET /budgets/:id`, `PUT /budgets/:id`, `DELETE /budgets/:id` |
| **Préstamos y Contrapartes** | `GET /loans/counterparties`, `POST /loans/counterparties`, `GET /loans/loans`, `POST /loans/loans`, `GET /loans/loans/:id`, `POST /loans/loans/:id/payments` |
| **Planes de Cuotas** | `GET /installments`, `POST /installments`, `GET /installments/:id`, `POST /installments/:id/pay`, `GET /installments/:id/installments` |
| **Dashboard** | `GET /dashboard/summary` |
| **Reportes** | `GET /reports/loan-installment-status`, `GET /reports/upcoming-obligations`, `GET /reports/income-expense-summary`, `GET /reports/balance-evolution`, `GET /reports/spending-by-category`, `GET /reports/cash-flow`, `GET /reports/budget-summary` |
| **Importación** | `POST /import/transactions` |

---

## 🎨 FRONTEND - APLICACIÓN VUE.JS (en la carpeta FinanzasFrontend)

### Estructura de Directorios (Ejemplo)

```
src/
├── components/      # Componentes reutilizables (formularios, listas, etc.)
│   └── ui/          # Componentes de UI de shadcn-vue
├── i18n/            # Internacionalización
├── lib/             # Utilidades generales (ej. `cn` para clases)
├── router/          # Configuración de rutas
├── services/        # Lógica de comunicación con la API (apiService)
├── stores/          # Stores de Pinia (estado global)
│   ├── authStore.ts     # Gestión de autenticación y estado del usuario
│   └── userStore.ts     # Gestión de usuarios (CRUD)
├── types/           # Definiciones de tipos
├── views/           # Vistas/Pantallas principales
│   ├── Login.vue        # Vista de inicio de sesión
│   ├── UserManagement.vue # Vista de gestión de usuarios
│   └── reports/     # Vistas específicas para cada reporte
└── main.ts          # Entrada de la aplicación
```

### 🛣️ RUTAS PRINCIPALES (Ejemplo)

| Ruta | Vista/Componente Principal |
| :--- | :--- |
| `/login` | `Login.vue` |
| `/` | `Dashboard.vue` |
| `/accounts` | `AccountList.vue` |
| `/accounts/create` | `AccountForm.vue` |
| `/accounts/edit/:id` | `AccountForm.vue` |
| `/categories` | `CategoryList.vue` |
| `/budgets` | `Budgets.vue` |
| `/loans` | `LoanList.vue` |
| `/loans/create` | `LoanForm.vue` |
| `/loans/:id` | `LoanDetail.vue` |
| `/installments` | `InstallmentPlanList.vue` |
| `/installments/:id` | `InstallmentDetail.vue` |
| `/import` | `DataImport.vue` |
| `/reports` | `ReportsIndex.vue` |
| `/reports/spending-by-category` | `SpendingByCategoryReport.vue` |
| `/reports/cash-flow` | `CashFlowReport.vue` |
| `/reports/balance-evolution` | `BalanceEvolutionReport.vue` |
| `/reports/income-expense-summary` | `IncomeExpenseSummaryReport.vue` |
| `/reports/upcoming-obligations` | `UpcomingObligationsReport.vue` |
| `/reports/budget-summary` | `BudgetSummaryReport.vue` |
| `/reports/loan-installment-status` | `LoanInstallmentStatusReport.vue` |
| `/users` | `UserManagement.vue` |

### 🗃️ STORES DE PINIA

- `accountStore`
- `authStore`
- `budgetStore`
- `categoryStore`
- `dashboardStore`
- `installmentStore`
- `loanStore`
- `reportStore`
- `transactionStore`
- `userStore`

### Diseño de Layout y Navegación (Sidebar)

El layout principal de la aplicación (`Layout.vue`) ha sido diseñado para proporcionar una experiencia de usuario consistente y responsiva, con un enfoque particular en la navegación lateral (sidebar).

**Características Clave:**

*   **Sidebar Fijo y Colapsable (Desktop):**
    *   En pantallas de escritorio (`md:` en adelante), el sidebar se mantiene fijo a la izquierda de la pantalla (`fixed inset-y-0`), ocupando toda la altura del viewport.
    *   Es colapsable, permitiendo al usuario alternar entre un estado expandido (ancho de `64` unidades Tailwind) y un estado colapsado (ancho de `20` unidades Tailwind), optimizando el espacio de la pantalla.
    *   El contenido principal de la aplicación ajusta su margen izquierdo (`md:ml-20` o `md:ml-64`) dinámicamente para evitar superposiciones con el sidebar.
    *   El scroll interno del sidebar se gestiona mediante el componente `ScrollArea`, que utiliza `flex-1` y `h-0` para asegurar que el área de contenido del sidebar ocupe el espacio restante y muestre barras de desplazamiento solo cuando sea necesario.

*   **Sidebar en Hoja Deslizable (Mobile):**
    *   En pantallas móviles, el sidebar se presenta como una hoja deslizable (`SheetContent`) que aparece desde la izquierda al activar un botón de menú.
    *   El contenido de la navegación en la hoja móvil siempre muestra las etiquetas de texto completas y el espaciado adecuado, sin estar sujeto al estado de colapso del sidebar de escritorio.
    *   El scroll interno de la hoja móvil también se maneja con `ScrollArea`, utilizando `flex-1` y `h-0` para asegurar un desplazamiento fluido de todo el contenido de navegación.

*   **Scroll General de la Página:**
    *   La aplicación utiliza `min-h-screen` en el contenedor principal para permitir que el contenido de la página crezca más allá de la altura del viewport, habilitando el scroll de la página completa cuando sea necesario, sin generar barras de desplazamiento dobles o conflictos con el scroll interno del sidebar.

---

## 🔄 FLUJO DE DATOS

### Mapeo de Rutas Frontend a Endpoints Backend Consumidos

Esta sección detalla qué rutas del frontend interactúan con qué endpoints de la API del backend para obtener o enviar datos.

| Ruta Frontend (URL) | Vista/Componente Principal | Store (Pinia) | Endpoints API Backend Consumidos |
| :--- | :--- | :--- | :--- |
| `/login` | `Login.vue` | `authStore.ts` | `POST /api/auth/login` |
| `/` | `Dashboard.vue` | `dashboardStore.ts` | `GET /api/dashboard/summary` |
| `/accounts` | `AccountList.vue` / `AccountForm.vue` | `accountStore.ts` | `GET /api/accounts`<br>`POST /api/accounts`<br>`PUT /api/accounts/:id`<br>`DELETE /api/accounts/:id` |
| `/transactions/create` | `TransactionForm.vue` | `transactionStore.ts` | `POST /api/transactions/regular`<br>`POST /api/transactions/transfer` |
| `/categories` | `CategoryList.vue` / `CategoryForm.vue` | `categoryStore.ts` | `GET /api/categories`<br>`POST /api/categories`<br>`PUT /api/categories/:id`<br>`DELETE /api/categories/:id` |
| `/budgets` | `Budgets.vue` | `budgetStore.ts` | `GET /api/budgets`<br>`POST /api/budgets`<br>`PUT /api/budgets/:id` |
| `/loans` | `LoanList.vue` / `LoanDetail.vue` | `loanStore.ts` | `GET /api/loans/loans`<br>`POST /api/loans/loans`<br>`GET /api/loans/loans/:id`<br>`POST /api/loans/loans/:id/payments`<br>`GET /api/loans/counterparties` |
| `/installments` | `InstallmentPlanList.vue` / `InstallmentDetail.vue` | `installmentStore.ts` | `GET /api/installments`<br>`POST /api/installments`<br>`GET /api/installments/:id/installments`<br>`POST /api/installments/:id/pay` |
| `/import` | `DataImport.vue` | `transactionStore.ts` (indirectamente) | `POST /api/import/transactions` |
| `/reports/*` | Vistas en `views/reports/` | `reportStore.ts` | `GET /api/reports/*` (con varios parámetros) |
| `/users` | `UserManagement.vue` | `userStore.ts` | `GET /api/users`<br>`POST /api/users`<br>`PUT /api/users/:id`<br>`DELETE /api/users/:id` |

---

## 🧠 LÓGICA DE NEGOCIO POR MÓDULO

Esta sección detalla las reglas y comportamientos clave que rigen las funcionalidades del sistema.

### 1. Manejo de Transferencias Internas

*   **Concepto**: Una transferencia entre cuentas propias (ej: Banco -> Efectivo) no es un gasto ni un ingreso real. Debe ser neutral en los reportes financieros.
*   **Implementación**: Se modela como un par de transacciones enlazadas (`linkedTransactionId`) con un tipo especial (`TransactionType.TRANSFER`).
*   **Reportes**: Las transferencias se excluyen automáticamente de los reportes de gastos/ingresos para evitar inflar las cifras.

### 2. Modelo de Presupuestos (Budgets)

*   **Objetivo**: Permitir a los usuarios definir un límite de gasto para una categoría en un período específico (mes/año) y monitorear el progreso.
*   **Cálculo**: La lógica para comparar el gasto real con el presupuesto reside en el backend, consultando las transacciones relevantes (`SUM(transactions) WHERE categoryId = ? AND date = ?`) y comparándolas con el monto del `Budget`.
*   **Rollover**: El campo `rollover` (booleano) indica si el excedente o déficit del mes anterior debe afectar al presupuesto del mes actual.

### 3. Preparación para SaaS (Multi-tenancy)

*   **Aislamiento de Datos**: Cada tabla que contiene información perteneciente a un usuario tiene una relación obligatoria con la tabla `User` (`userId`).
*   **Seguridad**: Toda la lógica de acceso a datos en el backend debe incluir siempre una cláusula `WHERE userId = ?` para prevenir fugas de datos entre usuarios.
*   **Rendimiento**: El `userId` está indexado (`@@index([userId])`) en todas las tablas relevantes para optimizar las consultas.

### 4. Compras en Cuotas sin Intereses

*   **Objetivo**: Registrar compras financiadas en cuotas sin intereses y llevar seguimiento del `pagado` y `saldo pendiente`.
*   **Modelo**: `InstallmentPlan` incluye `paidPrincipal` (acumulado pagado al principal). Cada `Installment` tiene `paidAmount` y `paidAt`.
*   **Pagos**: Un pago se asigna a la `cuota vigente`; si excede, avanza a la siguiente o aplica a `paidPrincipal`.
*   **Prepagos**: La funcionalidad de prepago está contemplada con estrategias de `reduce_term` (reduce el número de cuotas) o `reduce_amount` (reduce el monto de las cuotas restantes), aunque la lógica de negocio para estas estrategias aún no está implementada en el backend.
*   **Obligaciones Mensuales**: El impacto en las obligaciones del mes se calcula como la suma de `amount - paidAmount` de las cuotas con `dueDate` dentro del mes.

### 5. Préstamos que YO Realizo (Lending Personal)

*   **Objetivo**: Controlar el dinero prestado a terceros, incluyendo desembolso, pagos parciales, intereses opcionales y estado.
*   **Desembolso**: Genera una salida de dinero desde una `Account` y setea `outstandingPrincipal` igual al `principal`.
*   **Pagos**: Cada `LoanPayment` reduce el `outstandingPrincipal`. La lógica actual no distingue entre principal, interés o comisiones; todo pago reduce el capital pendiente.
*   **Tipos de Préstamo**: El modelo de datos soporta tipos de préstamo como `INTEREST_FREE`, `SIMPLE` y `FIXED`, pero la lógica de negocio para el cálculo de intereses y cuotas fijas aún no está implementada. Actualmente, todos los préstamos funcionan como si fueran de tipo `INTEREST_FREE`.
*   **Cierre**: El `status` cambia a `CLOSED` cuando `outstandingPrincipal <= 0`.

### 6. Manejo de Reembolsos y Devoluciones

*   **Concepto**: Un caso de uso común que impacta directamente en la conciliación de saldos.
*   **Implementación**: Se creará un tipo de transacción específico como `REFUND` o `REIMBURSEMENT`.
*   **Lógica de Ajuste**: El sistema permitirá anular una transacción previa o registrar un nuevo movimiento que ajuste el saldo de la cuenta o tarjeta (ej: reducir el `paidAmount` pendiente de una compra o generar un crédito).