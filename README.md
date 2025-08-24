# 💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)

> **Objetivo**: Crear una app web para uso personal que registre gastos/ingresos, controle cuentas bancarias, tarjetas de crédito, efectivo, deudas, préstamos y presupuestos. Debe ser escalable a **SaaS multiusuario**. La app móvil se implementará más adelante en **Flutter**.

---

## 📌 Tabla de contenidos

- [💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)](#-app-de-control-financiero-personal-web-primero-mobile-flutter-después)
  - [📌 Tabla de contenidos](#-tabla-de-contenidos)
  - [Visión y alcance](#visión-y-alcance)
  - [Casos de uso clave](#casos-de-uso-clave)
  - [Requisitos funcionales](#requisitos-funcionales)
  - [Arquitectura](#arquitectura)
  - [Modelo de datos (extensión con préstamos y compras sin cuotas)](#modelo-de-datos-extensión-con-préstamos-y-compras-sin-cuotas)
  - [Lógica financiera (nueva)](#lógica-financiera-nueva)
  - [Roadmap hacia SaaS](#roadmap-hacia-saas)
- [Addendum — Cambios solicitados (Agosto 2025)](#addendum--cambios-solicitados-agosto-2025)
  - [1) Mobile con **Flutter** (para después)](#1-mobile-con-flutter-para-después)
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
    - [Reglas de negocio](#reglas-de-negocio)
    - [UX](#ux-1)
    - [Reportes y recordatorios](#reportes-y-recordatorios)

---

## Visión y alcance

**Para hoy (uso personal)**

* Registro manual y por importación (CSV/Excel) de movimientos.
* Soporta **PEN** (S/), zona horaria **America/Lima**.
* Control de **cuentas bancarias**, **tarjetas de crédito** (cupo usado/disponible, fecha de corte/pago, compras sin cuotas y con cuotas), **efectivo**, **deudas**, **préstamos** y **presupuestos**.
* Transferencias internas (banco → efectivo, banco → tarjeta, etc.) que **cuadren** saldos automáticamente.
* Registrar compras con tarjeta **sin cuotas** y marcar cuánto ya fue pagado.
* Registrar **préstamos entregados** a terceros y llevar seguimiento de pagos recibidos.

**Para mañana (SaaS)**

* Multiusuario, workspaces, suscripciones, integración bancaria por API, webhooks, auditoría, límites por plan.
* App móvil desarrollada en **Flutter**.

---

## Casos de uso clave

1. Registrar un **gasto** pagado con efectivo/banco/tarjeta.
2. Registrar un **ingreso** (sueldo, freelance, devoluciones).
3. Registrar **transferencias internas** (no afectan el neto, sí mueven saldos).
4. Registrar compras con tarjeta **sin cuotas**, y controlar cuánto se ha pagado de ese consumo.
5. Crear **cuotas sin intereses** y **planes de pago** (tarjeta o préstamo), con cronograma.
6. Registrar **préstamos entregados** (a quién, monto, fecha, plan de pago, pagos recibidos).
7. Calcular **a pagar este mes por cada tarjeta** según fecha de corte/pago.
8. Ver **presupuesto vs ejecutado** por categoría/mes y recibir alertas.
9. Ver **caja actual**: efectivo + bancos – obligaciones del mes.
10. Importar **CSV/Excel** y **conciliar** con registros internos.

---

## Requisitos funcionales

* **Cuentas**: tipo (banco, efectivo, billetera), moneda (PEN), saldo.
* **Tarjetas de crédito**: emisor, cupo, saldo usado, fecha corte/pago, TEA (opcional), compras en cuotas o sin cuotas.
* **Transacciones**: ingreso/gasto/transferencia, categoría, subcategoría, etiqueta, método de pago, beneficiario.
* **Cuotas/planes**: monto total, #cuotas, valor cuota, fechas, saldo pendiente, prepagos.
* **Compras sin cuotas**: registrar gasto con tarjeta, marcar pagos parciales hasta cubrir el consumo.
* **Préstamos entregados**: registrar monto, beneficiario, cronograma de pago, saldo pendiente y pagos realizados.
* **Presupuestos**: por categoría y mes; rollover opcional.
* **Informes**: flujo de caja, gastos por categoría, evolución mensual, deuda total, préstamos vigentes.
* **Alertas**: sobrepresupuesto, vencimientos próximos, saldo bajo, préstamo atrasado.

---

## Arquitectura

* **Web**: Vue3, TypeScript, shadcn/ui, Tailwind.
* **Backend**: Node.js + TypeScript (NestJS o Express con modularización).
* **DB**: PostgreSQL + Prisma ORM.
* **Cache/Jobs**: Redis.
* **Infra**: Docker local, Azure para despliegue.
* **Mobile (futuro)**: Flutter (iOS/Android) consumiendo la misma API.

---

## Modelo de datos (extensión con préstamos y compras sin cuotas)

* **Transaction**: ahora admite `isInstallment` (true/false) y `paidAmount` para compras sin cuotas pero que se pagan después.
* **Loan** (préstamo entregado): id, beneficiario, monto, fechaInicio, tasa (opcional), cuotas?, pagos\[].
* **LoanPayment**: id, loanId, fecha, monto, saldoRestante.

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

## Lógica financiera (nueva)

**Compras sin cuotas (tarjeta)**

* Se registran como `Transaction(kind=EXPENSE, isInstallment=false)`.
* A medida que pagas con transferencias desde el banco → tarjeta, el campo `paidAmount` aumenta.
* El saldo pendiente de esa compra es `amount - paidAmount`.
* Cuando `paidAmount = amount`, la compra queda **liquidada**.

**Préstamos entregados**

* Al registrar un préstamo: `Loan(totalAmount, borrower, startDate)`.
* Cada pago recibido (`LoanPayment`) reduce el `remaining`.
* `remaining = totalAmount - SUM(payments.amount)`.
* Estado cambia a **CLOSED** cuando `remaining = 0`.
* Alertas si un pago esperado (según plan) no se recibe a tiempo.

---

## Roadmap hacia SaaS

1. **v0 (personal web)**: CRUD + cálculos + presupuestos + conciliación básica + préstamos.
2. **v1**: compras sin cuotas con tracking de pagos + reglas automáticas.
3. **v2**: multiusuario/workspaces, planes de suscripción, límites.
4. **v3**: app **Flutter**, integraciones bancarias.
5. **v4**: recomendaciones inteligentes (ML ligero), OCR de vouchers.

---

---

# Addendum — Cambios solicitados (Agosto 2025)

## 1) Mobile con **Flutter** (para después)

* La primera etapa será **Web + API** para uso personal.
* Cuando se habilite mobile, la app será construida en **Flutter** (Dart) consumiendo la **misma API** y compartiendo contratos (OpenAPI/JSON Schema) y reglas de negocio.
* Mantener en este README cualquier mención previa a RN/Expo como histórica; el **target móvil oficial** pasa a ser **Flutter**.

## 2) Compras en **cuotas sin intereses** con seguimiento de pagos

### Objetivo

Registrar compras en cuotas sin intereses (p.ej., 3, 6, 12 cuotas) y llevar **cuánto ya pagué** (incluye pagos parciales o prepagos) y **saldo pendiente**.

### Modelo (extensión)

* `InstallmentPlan`: agregar `paidPrincipal: Decimal` (acumulado pagado al principal).
* `Installment`: agregar `paidAmount: Decimal` y `paidAt?: DateTime` (para pagos parciales/totales por cuota).

### API

* `POST /installments/:id/pay` → `{ amount, date }` permite pagos **parciales**. Si `paidAmount >= amount`, marca `paidAt`.
* `POST /installments/plans/:id/prepay` → `{ amount, date, strategy }` donde `strategy ∈ { reduce_term, reduce_amount }`.

### Lógica

* El pago se asigna a la **cuota vigente**; si excede, avanza a la siguiente o aplica a `paidPrincipal` (según `strategy`).
* Reportes muestran: total, pagado, pendiente, próximas cuotas.
* Impacto en **Obligaciones del mes**: suma de `amount - paidAmount` de las cuotas con `dueDate` dentro del mes.

### UX

* En “Registrar” → opción **Compra en cuotas sin intereses** (wizard). Luego, en detalle de plan: barra de progreso (pagado/pending) y botón **Pagar cuota**/**Prepagar**.

## 3) **Préstamos que YO realizo** (lending personal)

### Objetivo

Llevar control de dinero prestado a terceros: desembolso, cronograma (si aplica), pagos parciales, intereses opcionales, moras/fees y estado del préstamo.

### Entidades nuevas

* `Counterparty` (persona/empresa): { id, name, phone?, email?, note? }
* `Loan`: { id, counterpartyId, principal, interestRate?, scheduleType: INTEREST\_FREE|SIMPLE|FIXED, issueDate, termMonths?, outstandingPrincipal, status }
* `LoanPayment`: { id, loanId, date, amount, allocation: PRINCIPAL|INTEREST|FEE, note? }

### API

* `POST /loans` (crear); `GET /loans/:id` (detalle); `POST /loans/:id/payments` (registrar cobro parcial/total); `PATCH /loans/:id` (reestructurar/cerrar).
* `GET /reports/loans-summary` (colocado total, cobrado, saldo, moras).

### Reglas de negocio

* **Desembolso**: genera salida desde una `Account` (banco/efectivo) y setea `outstandingPrincipal = principal`.
* **Pagos**: por defecto asignación `INTEREST → PRINCIPAL → FEE` (configurable). Reduce `outstandingPrincipal`.
* **Tipos**:

  * `INTEREST_FREE`: sin intereses, solo principal; opcionalmente con cronograma simple.
  * `SIMPLE`: interés simple (mensual/anual) sobre saldo.
  * `FIXED`: cuotas fijas manuales (monto/fecha predefinidos).
* **Mora** (opcional): si `hoy > dueDate` de una cuota, calcular `fee`, registrar como `LoanPayment { allocation: FEE }`.
* **Cierre**: `status = CLOSED` cuando `outstandingPrincipal == 0` y sin intereses/fees pendientes.

### UX

* Módulo **Préstamos**: listado (por estado) y detalle con cronograma, pagos, saldo.
* Acciones rápidas: **Desembolsar**, **Registrar pago**, **Prepago**, **Reestructurar**, **Condonar**.

### Reportes y recordatorios

* Widgets en Dashboard: **Saldo prestado**, **Cobros próximos**.
* Jobs de notificación (Lima TZ): avisos previos a vencimiento y recordatorios de cobro.

> Nota: Estas extensiones no rompen el diseño original; se integran en los modelos existentes y el roadmap. El primer release seguirá siendo **Web + API personal**, con **Flutter** en una versión posterior.
