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
- Node.js + Express.js
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
- Fetch API (gestionado en `src/services/apiService.ts`)

### Arquitectura General

```
Frontend (Vue.js) ←→ API REST (Node.js/Express.js) ←→ Base de Datos (PostgreSQL)
```

---

## 🖥️ BACKEND - API REST (en la carpeta FinanzasBackend)

### Estructura de Directorios

```
src/
├── config/          # Configuración de la base de datos
├── middleware/      # Middlewares (autenticación, roles, suscripción)
├── repositories/    # Lógica de acceso a datos (SQL Puro)
├── routes/          # Definición de rutas de la API
├── services/        # Lógica de negocio de cada módulo
└── index.ts         # Punto de entrada del servidor Express
```

### 🔗 ENDPOINTS DISPONIBLES (Resumen)

Todos los endpoints están prefijados con `/api`.

| Módulo | Endpoints Comunes |
| :--- | :--- |
| **Autenticación** | `POST /auth/login`, `POST /auth/register` |
| **Usuarios** | `GET /me` (datos del usuario actual), `GET /users`, `POST /users`, `PUT /users/:id`, `DELETE /users/:id` (Rutas de admin) |
| **Suscripción** | `POST /payment/subscribe` |
| **Cuentas** | `GET /accounts`, `POST /accounts`, `GET /accounts/:id`, `PUT /accounts/:id`, `DELETE /accounts/:id` |
| **Transacciones** | `GET /transactions`, `POST /transactions/regular`, `POST /transactions/transfer`, `GET /transactions/:id`, `PUT /transactions/:id`, `DELETE /transactions/:id` |
| **Categorías** | `GET /categories`, `POST /categories`, `GET /categories/:id`, `PUT /categories/:id`, `DELETE /categories/:id` |
| **Presupuestos** | `GET /budgets`, `POST /budgets`, `GET /budgets/:id`, `PUT /budgets/:id`, `DELETE /budgets/:id` |
| **Préstamos y Contrapartes** | `GET /counterparties`, `POST /counterparties`, `GET /loans`, `POST /loans`, `GET /loans/:id`, `POST /loans/:id/payments` |
| **Planes de Cuotas** | `GET /installment-plans`, `POST /installment-plans`, `GET /installment-plans/:id`, `GET /installment-plans/:id/installments`, `POST /installments/:id/pay` |
| **Dashboard** | `GET /dashboard/summary`, `GET /dashboard/income-expense-summary`, `GET /dashboard/budget-progress`, `GET /dashboard/loans-installments-summary`, `GET /dashboard/recent-transactions` |
| **Reportes** | `GET /reports/loan-installment-status`, `GET /reports/upcoming-obligations`, `GET /reports/income-expense-summary`, `GET /reports/balance-evolution`, `GET /reports/spending-by-category`, `GET /reports/cash-flow`, `GET /reports/budget-summary` |
| **Importación** | `POST /import/transactions` (subida de archivos) |

---

## 🎨 FRONTEND - APLICACIÓN VUE.JS (en la carpeta FinanzasFrontend)

### Estructura de Directorios

```
src/
├── components/      # Componentes reutilizables (formularios, listas, etc.)
│   └── ui/          # Componentes de UI de shadcn-vue
├── i18n/            # Internacionalización
├── lib/             # Utilidades generales
├── router/          # Configuración de rutas con Vue Router
├── services/        # Lógica de comunicación con la API (apiService)
├── stores/          # Stores de Pinia (estado global)
├── views/           # Vistas/Pantallas principales
└── main.ts          # Punto de entrada de la aplicación Vue
```

### 🛣️ RUTAS PRINCIPALES

| Ruta | Vista/Componente Principal |
| :--- | :--- |
| `/login` | `Login.vue` |
| `/register` | `Register.vue` |
| `/payment` | `Payment.vue` |
| `/` o `/dashboard` | `Dashboard.vue` |
| `/accounts` | `AccountList.vue` |
| `/accounts/create` | `AccountForm.vue` |
| `/accounts/edit/:id` | `AccountForm.vue` |
| `/transactions/create` | `TransactionForm.vue` |
| `/categories` | `CategoryList.vue` |
| `/budgets` | `Budgets.vue` |
| `/loans` | `LoanList.vue` |
| `/loans/:id` | `LoanDetail.vue` |
| `/installment-plans` | `InstallmentPlanList.vue` |
| `/installment-plans/:id` | `InstallmentDetail.vue` |
| `/import-data` | `DataImport.vue` |
| `/reports/*` | Vistas específicas para cada reporte |
| `/users` | `UserManagement.vue` (Solo SUPER_ADMIN) |

### 🗃️ STORES DE PINIA

- `authStore`: Maneja la autenticación, el token y los datos del usuario.
- `accountStore`: CRUD de Cuentas.
- `categoryStore`: CRUD de Categorías.
- `transactionStore`: Creación de Transacciones.
- `budgetStore`: CRUD de Presupuestos.
- `loanStore`: CRUD de Préstamos y Contrapartes.
- `installmentStore`: CRUD de Planes de Cuotas.
- `dashboardStore`: Obtiene los datos para el Dashboard.
- `reportStore`: Obtiene los datos para los diferentes reportes.
- `userStore`: CRUD de Usuarios (para Super Admin).
- `notificationStore`: Gestiona las notificaciones y toasts.

---

## 🔄 FLUJO DE DATOS

### Mapeo de Rutas Frontend a Endpoints Backend

| Ruta Frontend (URL) | Vista/Componente | Store (Pinia) | Endpoints API Consumidos |
| :--- | :--- | :--- | :--- |
| `/login` | `Login.vue` | `authStore` | `POST /api/auth/login`, `GET /api/me` |
| `/register` | `Register.vue` | `authStore` | `POST /api/auth/register` |
| `/payment` | `Payment.vue` | `authStore` | `POST /api/payment/subscribe` |
| `/dashboard` | `Dashboard.vue` | `dashboardStore` | `GET /api/dashboard/*` |
| `/accounts` | `AccountList.vue` | `accountStore` | `GET /api/accounts`, `DELETE /api/accounts/:id` |
| `/accounts/create` | `AccountForm.vue` | `accountStore` | `POST /api/accounts` |
| `/transactions/create` | `TransactionForm.vue` | `transactionStore` | `POST /api/transactions/regular`, `POST /api/transactions/transfer` |
| `/categories` | `CategoryList.vue` | `categoryStore` | `GET /api/categories`, `DELETE /api/categories/:id` |
| `/budgets` | `Budgets.vue` | `budgetStore` | `GET /api/budgets`, `DELETE /api/budgets/:id` |
| `/loans` | `LoanList.vue` | `loanStore` | `GET /api/loans`, `DELETE /api/loans/:id` |
| `/installment-plans` | `InstallmentPlanList.vue` | `installmentStore` | `GET /api/installment-plans`, `DELETE /api/installment-plans/:id` |
| `/import-data` | `DataImport.vue` | N/A (directo a `apiService`) | `POST /api/import/transactions` |
| `/reports/*` | Vistas en `views/reports/` | `reportStore` | `GET /api/reports/*` |
| `/users` | `UserManagement.vue` | `userStore` | `GET /api/users`, `POST /api/users`, `PUT /api/users/:id`, `DELETE /api/users/:id` |

---

## 🧠 LÓGICA DE NEGOCIO POR MÓDULO

### 1. Suscripciones y Control de Acceso

- **Prueba Inicial (Trial)**: Al registrarse, un usuario recibe un período de prueba de 7 días (`trial_ends_at`).
- **Suscripción de Pago**: Cuando un usuario paga, se actualiza su estado a `is_paid_user = true` y se establece una fecha de vencimiento en `subscription_expires_at` (30 días en el futuro).
- **Middleware de Verificación**: El `subscriptionMiddleware` en el backend protege las rutas y verifica en cada llamada:
    1. Si el usuario tiene una suscripción activa (`is_paid_user` es `true` y `subscription_expires_at` es una fecha futura), se le da acceso.
    2. Si la suscripción ha expirado, se le bloquea el acceso y se le informa.
    3. Si no es un usuario de pago, se verifica si su período de prueba sigue vigente. Si ha expirado, se le bloquea.
- **Redirección en Frontend**: El `router` de Vue complementa esta lógica, redirigiendo al usuario a la página `/payment` si su prueba o suscripción ha expirado.

### 2. Manejo de Transferencias Internas

- **Concepto**: Una transferencia entre cuentas propias no es un gasto ni un ingreso real. Debe ser neutral en los reportes.
- **Implementación**: Se modela como un par de transacciones enlazadas (`linkedTransactionId`) con un tipo especial (`TransactionType.TRANSFER`).
- **Reportes**: Las transferencias se excluyen automáticamente de los reportes de gastos/ingresos.

### 3. Modelo de Presupuestos (Budgets)

- **Objetivo**: Permitir a los usuarios definir un límite de gasto para una categoría en un período específico.
- **Cálculo**: La lógica para comparar el gasto real con el presupuesto reside en el backend.
- **Rollover**: Un campo booleano `rollover` permite que el excedente o déficit del mes anterior afecte al presupuesto del mes actual.

### 4. Preparación para SaaS (Multi-tenancy)

- **Aislamiento de Datos**: Cada tabla que contiene información de un usuario tiene una relación obligatoria con la tabla `User` (`userId`).
- **Seguridad**: Toda la lógica de acceso a datos en el backend incluye una cláusula `WHERE userId = ?` para prevenir fugas de datos.
- **Rendimiento**: El `userId` está indexado en todas las tablas relevantes para optimizar las consultas.

### 5. Compras en Cuotas sin Intereses

- **Objetivo**: Registrar compras financiadas y llevar seguimiento del saldo pendiente.
- **Modelo**: `InstallmentPlan` agrupa las `Installment` (cuotas) individuales.
- **Pagos**: Se pueden registrar pagos para cada cuota individual.

### 6. Préstamos Otorgados (Lending Personal)

- **Objetivo**: Controlar el dinero prestado a terceros.
- **Desembolso**: Genera una salida de dinero desde una cuenta y establece el capital pendiente.
- **Pagos**: Cada `LoanPayment` reduce el capital pendiente.
