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

**Frontend:**
- Vue.js 3
- Pinia (State Management)
- Vue Router
- Tailwind CSS (as per `FinanzasFrontend/tailwind.config.js`)
- Axios (implied by API calls in stores)

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
├── controllers/     # Lógica de controladores (rutas)
├── repositories/    # Interacción directa con la base de datos (SQL Puro)
├── routes/          # Definición de rutas
├── services/        # Lógica de negocio
└── index.ts         # Entrada del servidor
```

### 🔗 ENDPOINTS DISPONIBLES (Resumen)

| Módulo | Endpoints Comunes |
| :--- | :--- |
| **Cuentas** | `GET /api/accounts`, `POST /api/accounts`, `PUT /api/accounts/:id`, `DELETE /api/accounts/:id` |
| **Transacciones** | `GET /api/transactions`, `POST /api/transactions` |
| **Categorías** | `GET /api/categories`, `POST /api/categories`, `PUT /api/categories/:id`, `DELETE /api/categories/:id` |
| **Presupuestos** | `GET /api/budgets`, `POST /api/budgets`, `PUT /api/budgets/:id`, `GET /api/budgets/:id/transactions` |
| **Préstamos** | `GET /api/loans`, `POST /api/loans`, `GET /api/loans/:id`, `POST /api/loans/:id/payments` |
| **Contrapartes** | `GET /api/counterparties`, `POST /api/counterparties` |
| **Cuotas** | `GET /api/installment-plans`, `POST /api/installment-plans`, `POST /api/installments/:id/pay`, `POST /api/installment-plans/:id/prepay` |
| **Dashboard** | `GET /api/dashboard/summary` |

---

## 🎨 FRONTEND - APLICACIÓN VUE.JS (en la carpeta FinanzasFrontend)

### Estructura de Directorios (Ejemplo)

```
src/
├── components/      # Componentes reutilizables (formularios, listas, etc.)
├── i18n/            # Internacionalización
├── router/          # Configuración de rutas
├── stores/          # Stores de Pinia (estado global)
├── types/           # Definiciones de tipos
├── views/           # Vistas/Pantallas principales
└── main.ts          # Entrada de la aplicación
```

### 🛣️ RUTAS PRINCIPALES (Ejemplo)

| Ruta | Vista Principal |
| :--- | :--- |
| `/` | Dashboard |
| `/accounts` | Cuentas |
| `/transactions` | Transacciones |
| `/categories` | Categorías |
| `/budgets` | Presupuestos |
| `/loans` | Préstamos |
| `/installments` | Cuotas |

### 🗃️ STORES DE PINIA

- `accountStore`
- `budgetStore`
- `categoryStore`
- `dashboardStore`
- `installmentStore`
- `loanStore`
- `transactionStore`

---

## 🔄 FLUJO DE DATOS

### Mapeo de Rutas Frontend a Endpoints Backend Consumidos

Esta sección detalla qué rutas del frontend interactúan con qué endpoints de la API del backend para obtener o enviar datos.

| Ruta Frontend (URL) | Vista/Componente Principal | Store (Pinia) | Endpoints API Backend Consumidos |
| :--- | :--- | :--- | :--- |
| `/` | `Dashboard.vue` | `dashboardStore.ts` | `GET /api/dashboard/summary` |
| `/accounts` | `AccountList.vue` / `AccountForm.vue` | `accountStore.ts` | `GET /api/accounts`<br>`POST /api/accounts`<br>`PUT /api/accounts/:id`<br>`DELETE /api/accounts/:id` |
| `/transactions` | `TransactionForm.vue` (y listas) | `transactionStore.ts` | `GET /api/transactions`<br>`POST /api/transactions` (incluye transferencias)<br>`GET /api/transactions/summary` |
| `/categories` | `CategoryList.vue` / `CategoryForm.vue` | `categoryStore.ts` | `GET /api/categories`<br>`POST /api/categories`<br>`PUT /api/categories/:id`<br>`DELETE /api/categories/:id` |
| `/budgets` | `Budgets.vue` | `budgetStore.ts` | `GET /api/budgets`<br>`POST /api/budgets`<br>`PUT /api/budgets/:id`<br>`GET /api/budgets/:id/transactions` |
| `/loans` | `LoanList.vue` / `LoanDetail.vue` | `loanStore.ts` | `GET /api/loans`<br>`POST /api/loans`<br>`GET /api/loans/:id`<br>`POST /api/loans/:id/payments`<br>`GET /api/counterparties`<br>`POST /api/counterparties` |
| `/installments` | `InstallmentPlanList.vue` | `installmentStore.ts` | `GET /api/installment-plans`<br>`POST /api/installment-plans`<br>`POST /api/installments/:id/pay`<br>`POST /api/installment-plans/:id/prepay` |

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
*   **Pagos**: Un pago se asigna a la `cuota vigente`; si excede, avanza a la siguiente o aplica a `paidPrincipal` (según estrategia de prepago).
*   **Prepagos**: Se manejan con estrategias de `reduce_term` (reduce el número de cuotas) o `reduce_amount` (reduce el monto de las cuotas restantes).
*   **Obligaciones Mensuales**: El impacto en las obligaciones del mes se calcula como la suma de `amount - paidAmount` de las cuotas con `dueDate` dentro del mes.

### 5. Préstamos que YO Realizo (Lending Personal)

*   **Objetivo**: Controlar el dinero prestado a terceros, incluyendo desembolso, pagos parciales, intereses opcionales y estado.
*   **Desembolso**: Genera una salida de dinero desde una `Account` y setea `outstandingPrincipal` igual al `principal`.
*   **Pagos**: Cada `LoanPayment` reduce el `outstandingPrincipal`. La asignación por defecto es `INTEREST → PRINCIPAL → FEE`, pero puede ser flexible.
*   **Tipos de Préstamo**: 
    *   `INTEREST_FREE`: Sin intereses, solo principal.
    *   `SIMPLE`: Interés simple (mensual/anual) sobre saldo.
    *   `FIXED`: Cuotas fijas manuales.
*   **Mora**: Si `hoy > dueDate` de una cuota, se puede calcular una `fee` y registrarla como `LoanPayment { allocation: FEE }`.
*   **Cierre**: El `status` cambia a `CLOSED` cuando `outstandingPrincipal == 0` y no hay intereses/fees pendientes.
*   **Condonación**: Funcionalidad explícita para ajustar el `outstandingPrincipal` sin un registro de pago, útil para perdonar deuda.

### 6. Manejo de Reembolsos y Devoluciones

*   **Concepto**: Un caso de uso común que impacta directamente en la conciliación de saldos.
*   **Implementación**: Se puede crear un tipo de transacción específico como `REFUND` o `REIMBURSEMENT`.
*   **Lógica de Ajuste**: El sistema permite anular una transacción previa o registrar un nuevo movimiento que ajuste el saldo de la cuenta o tarjeta (ej: reducir el `paidAmount` pendiente de una compra o generar un crédito).