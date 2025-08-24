# 💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)

> **Objetivo General**: Crear una aplicación web para uso personal que registre gastos/ingresos, controle cuentas bancarias, tarjetas de crédito, efectivo, deudas, préstamos y presupuestos. Debe ser escalable a **SaaS multiusuario**. La app móvil se implementará más adelante en **Flutter**.

---

## 📌 Tabla de contenidos

- [💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)](#-app-de-control-financiero-personal-web-primero-mobile-flutter-después)
  - [📌 Tabla de contenidos](#-tabla-de-contenidos)
  - [Visión y Alcance](#visión-y-alcance)
  - [Core de Negocio y Casos de Uso Clave](#core-de-negocio-y-casos-de-uso-clave)
  - [Requisitos Funcionales](#requisitos-funcionales)
  - [Arquitectura](#arquitectura)
  - [Modelo de Datos](#modelo-de-datos)
  - [Lógica Financiera](#lógica-financiera)
  - [Roadmap de Implementación](#roadmap-de-implementación)
    - [Fase 1 — Personal (Web)](#fase-1--personal-web)
    - [Fase 2 — Personal (Móvil Flutter)](#fase-2--personal-móvil-flutter)
    - [Fase 3 — SaaS](#fase-3--saas)
- [Addendum — Cambios Solicitados (Agosto 2025)](#addendum--cambios-solicitados-agosto-2025)
  - [1) Mobile con **Flutter**](#1-mobile-con-flutter)
  - [2) Compras en **cuotas sin intereses** con seguimiento de pagos](#2-compras-en-cuotas-sin-intereses-con-seguimiento-de-pagos)
    - [Objetivo](#objetivo)
    - [Modelo (extensión)](#modelo-extensión)
    - [API](#api)
    - [Lógica](#lógica)
    - [UX](#ux)
  - [3) **Préstamos que YO realizo** (lending personal)](#3-préstamos-que-yo-realizo-lending-personal)
    - [Objetivo](#objetivo-1)
    - [Entidades nuevas](#entidades-nuevas)
    - [API](#api-1)
    - [Reglas de Negocio](#reglas-de-negocio)
    - [UX](#ux-1)
    - [Reportes y Recordatorios](#reportes-y-recordatorios)
  - [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
    - [Prerrequisitos](#prerrequisitos)
    - [Pasos de Instalación](#pasos-de-instalación)
  - [Cómo Ejecutar la Aplicación](#cómo-ejecutar-la-aplicación)
  - [Pruebas](#pruebas)
  - [Despliegue](#despliegue)
  - [Futuras Mejoras](#futuras-mejoras)

---

## Visión y Alcance

**Para hoy (uso personal)**

*   Registro manual y por importación (CSV/Excel) de movimientos.
*   Soporta **PEN** (S/), zona horaria **America/Lima**.
*   Control de **cuentas bancarias**, **tarjetas de crédito** (cupo usado/disponible, fecha de corte/pago, compras sin cuotas y con cuotas), **efectivo**, **deudas**, **préstamos** y **presupuestos**.
*   Transferencias internas (banco → efectivo, banco → tarjeta, etc.) que **cuadren** saldos automáticamente.
*   Registrar compras con tarjeta **sin cuotas** y marcar cuánto ya fue pagado.
*   Registrar **préstamos entregados** a terceros y llevar seguimiento de pagos recibidos.

**Para mañana (SaaS)**

*   Multiusuario, workspaces, suscripciones, integración bancaria por API, webhooks, auditoría, límites por plan.
*   App móvil desarrollada en **Flutter**.

---

## Core de Negocio y Casos de Uso Clave

La aplicación busca permitir registrar, organizar y analizar de forma clara todas las finanzas personales. Los casos de uso clave incluyen:

1.  **Cuentas y Saldos**: Gestión de bancos, tarjetas de crédito (crédito total, utilizado, disponible, compras directas y en cuotas, pagos) y efectivo.
2.  **Gastos y Compras**: Registro de gastos simples y en cuotas sin interés (número de cuotas, pagadas/pendientes, pago anticipado). Clasificación por categorías.
3.  **Deudas y Planes de Pago**: Registro de deudas personales (ej: préstamos bancarios, créditos externos) con plan de pago asociado (monto, cuotas, interés, vencimientos, estado).
4.  **Préstamos Otorgados**: Registro de dinero prestado a terceros (deudor, monto, condiciones, cronograma, pagos recibidos, saldo pendiente, historial).
5.  **Transferencias Internas**: Movimiento de fondos entre cuentas (Banco ↔ Efectivo, Banco ↔ Tarjeta de crédito) asegurando la consistencia de saldos.
6.  **Conciliación Financiera**: Validación de que todo movimiento tiene origen y destino, y que los saldos totales cuadran correctamente. Reporte de discrepancias.
7.  **Presupuestos y Alertas**: Definición de presupuestos mensuales por categoría y seguimiento en tiempo real. Alertas por presupuesto excedido, vencimientos próximos, cuotas pendientes.
8.  **Reportes y Análisis**: Evolución de saldos, distribución de gastos, comparativa ingresos vs. gastos, estado de deudas y préstamos, flujo neto de efectivo.
9.  **Importación**: Importar CSV/Excel y conciliar con registros internos.

---

## Requisitos Funcionales

*   **Cuentas**: tipo (banco, efectivo, billetera), moneda (PEN), saldo.
*   **Tarjetas de crédito**: emisor, cupo, saldo usado, fecha corte/pago, TEA (opcional), compras en cuotas o sin cuotas.
*   **Transacciones**: ingreso/gasto/transferencia, categoría, subcategoría, etiqueta, método de pago, beneficiario.
*   **Cuotas/planes**: monto total, #cuotas, valor cuota, fechas, saldo pendiente, prepagos.
*   **Compras sin cuotas**: registrar gasto con tarjeta, marcar pagos parciales hasta cubrir el consumo.
*   **Préstamos entregados**: registrar monto, beneficiario, cronograma de pago, saldo pendiente y pagos realizados.
*   **Presupuestos**: por categoría y mes; rollover opcional.
*   **Informes**: flujo de caja, gastos por categoría, evolución mensual, deuda total, préstamos vigentes.
*   **Alertas**: sobrepresupuesto, vencimientos próximos, saldo bajo, préstamo atrasado.

---

## Arquitectura

*   **Web**: Vue3, TypeScript, shadcn/ui, Tailwind.
*   **Backend**: Node.js + TypeScript (NestJS o Express con modularización).
*   **Base de Datos**: PostgreSQL + Prisma ORM.
*   **Cache/Jobs**: Redis.
*   **Infraestructura**: Docker Compose local; escalable a Azure (PaaS, DBaaS) en versión SaaS.
*   **Móvil (futuro)**: Flutter (iOS/Android) consumiendo la misma API.
*   **Autenticación**: simple (para uso personal), escalable a OAuth/JWT.

---

## Modelo de Datos

*   **Transaction**: ahora admite `isInstallment` (true/false) y `paidAmount` para compras sin cuotas pero que se pagan después.
*   **Loan** (préstamo entregado): id, beneficiario, monto, fechaInicio, tasa (opcional), cuotas?, pagos[].
*   **LoanPayment**: id, loanId, fecha, monto, saldoRestante.

Ejemplo Prisma extendido:

```prisma
model Loan {
  id           String   @id @default(cuid())
  borrower     String   // nombre de la persona
  totalAmount  Decimal
  startDate    DateTime
  installments Int?
  interestRate Decimal? // opcional
  status       String   // ACTIVE | CLOSED | DEFAULTED
  payments     LoanPayment[]
}

model LoanPayment {
  id        String   @id @default(cuid())
  loanId    String
  loan      Loan @relation(fields: [loanId], references: [id])
  date      DateTime
  amount    Decimal
  remaining Decimal
}

model Transaction {
  id           String   @id @default(cuid())
  kind         TransactionKind
  amount       Decimal
  date         DateTime
  accountId    String?
  cardId       String?
  categoryId   String?
  note         String?
  isInstallment Boolean @default(false)
  paidAmount   Decimal  @default(0)
}
```

---

## Lógica Financiera

**Compras sin cuotas (tarjeta)**

*   Se registran como `Transaction(kind=EXPENSE, isInstallment=false)`.
*   A medida que pagas con transferencias desde el banco → tarjeta, el campo `paidAmount` aumenta.
*   El saldo pendiente de esa compra es `amount - paidAmount`.
*   Cuando `paidAmount = amount`, la compra queda **liquidada**.

**Préstamos entregados**

*   Al registrar un préstamo: `Loan(totalAmount, borrower, startDate)`.
*   Cada pago recibido (`LoanPayment`) reduce el `remaining`.
*   `remaining = totalAmount - SUM(payments.amount)`.
*   Estado cambia a **CLOSED** cuando `remaining = 0`.
*   Alertas si un pago esperado (según plan) no se recibe a tiempo.

---

## Roadmap de Implementación

### Fase 1 — Personal (Web)

*   Registro manual de gastos y compras simples.
*   Manejo de cuentas bancarias, efectivo y tarjetas.
*   Transferencias internas.
*   Presupuesto mensual básico.
*   Reporte simple de gastos y saldos.
*   CRUD + cálculos + presupuestos + conciliación básica + préstamos.

### Fase 2 — Personal (Móvil Flutter)

*   Sincronización con backend.
*   Interfaz optimizada para uso rápido en celular.
*   Notificaciones locales (ej: recordatorio de cuota).
*   App **Flutter**, integraciones bancarias.

### Fase 3 — SaaS

*   Autenticación multiusuario.
*   Roles y permisos.
*   Facturación.
*   Dashboard avanzado con insights financieros.
*   Integración con APIs bancarias (open banking, donde sea posible).
*   Multiusuario/workspaces, planes de suscripción, límites.

---

# Addendum — Cambios Solicitados (Agosto 2025)

## 1) Mobile con **Flutter**

*   La primera etapa será **Web + API** para uso personal.
*   Cuando se habilite mobile, la app será construida en **Flutter** (Dart) consumiendo la **misma API** y compartiendo contratos (OpenAPI/JSON Schema) y reglas de negocio.
*   El **target móvil oficial** pasa a ser **Flutter**.

## 2) Compras en **cuotas sin intereses** con seguimiento de pagos

### Objetivo

Registrar compras en cuotas sin intereses (p.ej., 3, 6, 12 cuotas) y llevar **cuánto ya pagué** (incluye pagos parciales o prepagos) y **saldo pendiente**.

### Modelo (extensión)

*   `InstallmentPlan`: agregar `paidPrincipal: Decimal` (acumulado pagado al principal).
*   `Installment`: agregar `paidAmount: Decimal` y `paidAt?: DateTime` (para pagos parciales/totales por cuota).

### API

*   `POST /installments/:id/pay` → `{ amount, date }` permite pagos **parciales**. Si `paidAmount >= amount`, marca `paidAt`.
*   `POST /installments/plans/:id/prepay` → `{ amount, date, strategy }` donde `strategy ∈ { reduce_term, reduce_amount }`.

### Lógica

*   El pago se asigna a la **cuota vigente**; si excede, avanza a la siguiente o aplica a `paidPrincipal` (según `strategy`).
*   Reportes muestran: total, pagado, pendiente, próximas cuotas.
*   Impacto en **Obligaciones del mes**: suma de `amount - paidAmount` de las cuotas con `dueDate` dentro del mes.

### UX

*   En “Registrar” → opción **Compra en cuotas sin intereses** (wizard). Luego, en detalle de plan: barra de progreso (pagado/pending) y botón **Pagar cuota**/**Prepagar**.

## 3) **Préstamos que YO realizo** (lending personal)

### Objetivo

Llevar control de dinero prestado a terceros: desembolso, cronograma (si aplica), pagos parciales, intereses opcionales, moras/fees y estado del préstamo.

### Entidades nuevas

*   `Counterparty` (persona/empresa): { id, name, phone?, email?, note? }
*   `Loan`: { id, counterpartyId, principal, interestRate?, scheduleType: INTEREST_FREE|SIMPLE|FIXED, issueDate, termMonths?, outstandingPrincipal, status }
*   `LoanPayment`: { id, loanId, date, amount, allocation: PRINCIPAL|INTEREST|FEE, note? }

### API

*   `POST /loans` (crear); `GET /loans/:id` (detalle); `POST /loans/:id/payments` (registrar cobro parcial/total); `PATCH /loans/:id` (reestructurar/cerrar).
*   `GET /reports/loans-summary` (colocado total, cobrado, saldo, moras).

### Reglas de Negocio

*   **Desembolso**: genera salida desde una `Account` (banco/efectivo) y setea `outstandingPrincipal = principal`.
*   **Pagos**: por defecto asignación `INTEREST → PRINCIPAL → FEE` (configurable). Reduce `outstandingPrincipal`.
*   **Tipos**:
    *   `INTEREST_FREE`: sin intereses, solo principal; opcionalmente con cronograma simple.
    *   `SIMPLE`: interés simple (mensual/anual) sobre saldo.
    *   `FIXED`: cuotas fijas manuales (monto/fecha predefinidos).
*   **Mora** (opcional): si `hoy > dueDate` de una cuota, calcular `fee`, registrar como `LoanPayment { allocation: FEE }`.
*   **Cierre**: `status = CLOSED` cuando `outstandingPrincipal == 0` y sin intereses/fees pendientes.

### UX

*   Módulo **Préstamos**: listado (por estado) y detalle con cronograma, pagos, saldo.
*   Acciones rápidas: **Desembolsar**, **Registrar pago**, **Prepago**, **Reestructurar**, **Condonar**.

### Reportes y Recordatorios

*   Widgets en Dashboard: **Saldo prestado**, **Cobros próximos**.
*   Jobs de notificación (Lima TZ): avisos previos a vencimiento y recordatorios de cobro.

---

## Configuración del Entorno de Desarrollo

Para poner en marcha el proyecto localmente, necesitarás los siguientes prerrequisitos y seguir estos pasos:

### Prerrequisitos

*   **Node.js**: Versión 18 o superior.
*   **npm** (Node Package Manager): Viene con Node.js.
*   **Docker y Docker Compose**: Para la base de datos (PostgreSQL) y Redis.
*   **Git**: Para clonar el repositorio.

### Pasos de Instalación

1.  **Clonar el Repositorio**:
    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd <nombre_del_repositorio>
    ```
2.  **Configurar la Base de Datos y Cache (Docker Compose)**:
    ```bash
    docker-compose up -d
    ```
    Esto levantará los contenedores de PostgreSQL y Redis. Asegúrate de que los puertos no estén en uso.
3.  **Instalar Dependencias del Backend**:
    ```bash
    cd backend # o la ruta a tu carpeta de backend
    npm install
    ```
4.  **Configurar Variables de Entorno del Backend**:
    Crea un archivo `.env` en la raíz del directorio del backend con las variables de entorno necesarias (ej. `DATABASE_URL`, `REDIS_URL`, etc.). Consulta un posible archivo `.env.example` si existe.
5.  **Ejecutar Migraciones de la Base de Datos**:
    ```bash
    npx prisma migrate dev --name init # o el comando de migración correspondiente
    ```
6.  **Instalar Dependencias del Frontend**:
    ```bash
    cd ../frontend # o la ruta a tu carpeta de frontend
    npm install
    ```
7.  **Configurar Variables de Entorno del Frontend**:
    Crea un archivo `.env.local` en la raíz del directorio del frontend con las variables de entorno necesarias (ej. `NEXT_PUBLIC_API_URL`).

---

## Cómo Ejecutar la Aplicación

Una vez configurado el entorno, puedes iniciar la aplicación:

1.  **Iniciar el Backend**:
    ```bash
    cd backend # si no estás ya en el directorio
    npm run start:dev # o el comando para iniciar el servidor de desarrollo
    ```
    El backend debería estar disponible en `http://localhost:3000` (o el puerto configurado).
2.  **Iniciar el Frontend**:
    ```bash
    cd frontend # si no estás ya en el directorio
    npm run dev # o el comando para iniciar el servidor de desarrollo de Next.js
    ```
    El frontend debería estar disponible en `http://localhost:3001` (o el puerto configurado).

---

## Pruebas

Para ejecutar las pruebas del proyecto:

*   **Backend**:
    ```bash
    cd backend
    npm test # o el comando de pruebas configurado (ej. `npm run test:e2e`)
    ```
*   **Frontend**:
    ```bash
    cd frontend
    npm test # o el comando de pruebas configurado
    ```

---

## Despliegue

El despliegue final está planificado para **Azure**. Los detalles específicos de CI/CD y la configuración de los servicios de Azure (App Services, Azure Database for PostgreSQL, Azure Cache for Redis) se documentarán en una fase posterior del proyecto.

---

## Futuras Mejoras

*   Integración automática con bancos y tarjetas (API bancaria / scraping).
*   Machine Learning para predicción de gastos futuros.
*   Recomendaciones personalizadas de ahorro.
*   Exportación de reportes (PDF, Excel).
*   Sincronización multi-dispositivo en tiempo real.
*   Recomendaciones inteligentes (ML ligero), OCR de vouchers.