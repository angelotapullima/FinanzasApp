# 💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)

> **Objetivo General**: Crear una aplicación web para uso personal que registre gastos/ingresos, controle cuentas bancarias, tarjetas de crédito, efectivo, deudas, préstamos y presupuestos. Debe ser escalable a **SaaS multiusuario**. La app móvil se implementará más adelante en **Flutter**.

-----

## 📌 Tabla de contenidos

  - [💰 App de Control Financiero Personal (Web primero, Mobile Flutter después)](https://www.google.com/search?q=%23-app-de-control-financiero-personal-web-primero-mobile-flutter-despu%C3%A9s)
      - [📌 Tabla de contenidos](https://www.google.com/search?q=%23-tabla-de-contenidos)
      - [Visión y Alcance](https://www.google.com/search?q=%23visi%C3%B3n-y-alcance)
      - [Core de Negocio y Casos de Uso Clave](https://www.google.com/search?q=%23core-de-negocio-y-casos-de-uso-clave)
      - [Requisitos Funcionales](https://www.google.com/search?q=%23requisitos-funcionales)
      - [Arquitectura](https://www.google.com/search?q=%23arquitectura)
      - [Modelo de Datos](https://www.google.com/search?q=%23modelo-de-datos)
      - [Lógica Financiera](https://www.google.com/search?q=%23l%C3%B3gica-financiera)
      - [Roadmap de Implementación](https://www.google.com/search?q=%23roadmap-de-implementaci%C3%B3n)
          - [Fase 1 — Personal (Web)](https://www.google.com/search?q=%23fase-1--personal-web)
          - [Fase 2 — Personal (Móvil Flutter)](https://www.google.com/search?q=%23fase-2--personal-m%C3%B3vil-flutter)
          - [Fase 3 — SaaS](https://www.google.com/search?q=%23fase-3--saas)
  - [Addendum — Cambios Solicitados (Agosto 2025)](https://www.google.com/search?q=%23addendum--cambios-solicitados-agosto-2025)
      - [1) Mobile con **Flutter**](https://www.google.com/search?q=%231-mobile-con-flutter)
      - [2) Compras en **cuotas sin intereses** con seguimiento de pagos](https://www.google.com/search?q=%232-compras-en-cuotas-sin-intereses-con-seguimiento-de-pagos)
          - [Objetivo](https://www.google.com/search?q=%23objetivo)
          - [Modelo (extensión)](https://www.google.com/search?q=%23modelo-extensi%C3%B3n)
          - [API](https://www.google.com/search?q=%23api)
          - [Lógica](https://www.google.com/search?q=%23l%C3%B3gica)
          - [UX](https://www.google.com/search?q=%23ux)
      - [3) **Préstamos que YO realizo** (lending personal)](https://www.google.com/search?q=%233-pr%C3%A9stamos-que-yo-realizo-lending-personal)
          - [Objetivo](https://www.google.com/search?q=%23objetivo-1)
          - [Entidades nuevas](https://www.google.com/search?q=%23entidades-nuevas)
          - [API](https://www.google.com/search?q=%23api-1)
          - [Reglas de Negocio](https://www.google.com/search?q=%23reglas-de-negocio)
          - [UX](https://www.google.com/search?q=%23ux-1)
          - [Reportes y Recordatorios](https://www.google.com/search?q=%23reportes-y-recordatorios)
  - [Concepciones Clave para el Lanzamiento](https://www.google.com/search?q=%23concepciones-clave-para-el-lanzamiento)
      - [1. Manejo de Reembolsos y Devoluciones](https://www.google.com/search?q=%231-manejo-de-reembolsos-y-devoluciones)
      - [2. Flexibilidad en Préstamos Otorgados](https://www.google.com/search?q=%232-flexibilidad-en-pr%C3%A9stamos-otorgados)
  - [Configuración del Entorno de Desarrollo](https://www.google.com/search?q=%23configuraci%C3%B3n-del-entorno-de-desarrollo)
      - [Prerrequisitos](https://www.google.com/search?q=%23prerrequisitos)
      - [Pasos de Instalación](https://www.google.com/search?q=%23pasos-de-instalaci%C3%B3n)
  - [Cómo Ejecutar la Aplicación](https://www.google.com/search?q=%23c%C3%B3mo-ejecutar-la-aplicaci%C3%B3n)
  - [Pruebas](https://www.google.com/search?q=%23pruebas)
  - [Despliegue](https://www.google.com/search?q=%23despliegue)
  - [Futuras Mejoras](https://www.google.com/search?q=%23futuras-mejoras)

-----

## Visión y Alcance

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

-----

## Core de Negocio y Casos de Uso Clave

La aplicación busca permitir registrar, organizar y analizar de forma clara todas las finanzas personales. Los casos de uso clave incluyen:

1.  **Cuentas y Saldos**: Gestión de bancos, tarjetas de crédito y efectivo.
2.  **Gastos y Compras**: Registro de gastos simples y en cuotas sin interés.
3.  **Deudas y Planes de Pago**: Registro de deudas personales con plan de pago asociado.
4.  **Préstamos Otorgados**: Registro de dinero prestado a terceros con seguimiento de pagos.
5.  **Transferencias Internas**: Movimiento de fondos entre cuentas.
6.  **Conciliación Financiera**: Validación de que todo movimiento tiene origen y destino.
7.  **Presupuestos y Alertas**: Definición de presupuestos mensuales por categoría y seguimiento en tiempo real.
8.  **Reportes y Análisis**: Evolución de saldos, distribución de gastos, comparativa ingresos vs. gastos, estado de deudas y préstamos, flujo neto de efectivo.
9.  **Importación**: Importar CSV/Excel y conciliar con registros internos.

-----

## Requisitos Funcionales

  * **Cuentas**: tipo (banco, efectivo, billetera), moneda (PEN), saldo.
  * **Tarjetas de crédito**: emisor, cupo, saldo usado, fecha corte/pago, compras en cuotas o sin cuotas.
  * **Transacciones**: ingreso/gasto/transferencia, categoría, subcategoría, etiqueta, método de pago, beneficiario.
  * **Cuotas/planes**: monto total, \#cuotas, valor cuota, fechas, saldo pendiente, prepagos.
  * **Compras sin cuotas**: registrar gasto con tarjeta, marcar pagos parciales hasta cubrir el consumo.
  * **Préstamos entregados**: registrar monto, beneficiario, cronograma de pago, saldo pendiente y pagos realizados.
  * **Presupuestos**: por categoría y mes; rollover opcional.
  * **Informes**: flujo de caja, gastos por categoría, evolución mensual, deuda total, préstamos vigentes.
  * **Alertas**: sobrepresupuesto, vencimientos próximos, saldo bajo, préstamo atrasado.

-----

## Arquitectura

  * **Web**: Vue3, TypeScript, shadcn/ui, Tailwind.
  * **Backend**: Node.js + Express.js con modularización.
  * **Base de Datos**: PostgreSQL (SQL Puro).
  * **Infraestructura**: Docker Compose local para servicios futuros; actualmente la base de datos se ejecuta localmente. Escalable a Azure (PaaS, DBaaS) en versión SaaS.
  * **Móvil (futuro)**: Flutter (iOS/Android) consumiendo la misma API.
  * **Autenticación**: simple (para uso personal), escalable a OAuth/JWT.

-----

## Modelo de Datos

  * **Transaction**: ahora admite `isInstallment` (true/false) y `paidAmount` para compras sin cuotas pero que se pagan después.
  * **Loan** (préstamo entregado): id, beneficiario, monto, fechaInicio, tasa (opcional), cuotas?, pagos[].
  * **LoanPayment**: id, loanId, fecha, monto, saldoRestante.

Ejemplo de esquema de datos (SQL):



-----

## Lógica Financiera

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

-----

## Roadmap de Implementación

### Fase 1 — Personal (Web)

  * Registro manual de gastos y compras simples.
  * Manejo de cuentas bancarias, efectivo y tarjetas.
  * Transferencias internas.
  * Presupuesto mensual básico.
  * Reporte simple de gastos y saldos.
  * CRUD + cálculos + presupuestos + conciliación básica + préstamos.

### Fase 2 — Personal (Móvil Flutter)

  * Sincronización con backend.
  * Interfaz optimizada para uso rápido en celular.
  * Notificaciones locales (ej: recordatorio de cuota).
  * App **Flutter**, integraciones bancarias.

### Fase 3 — SaaS

  * Autenticación multiusuario.
  * Roles y permisos.
  * Facturación.
  * Dashboard avanzado con insights financieros.
  * Integración con APIs bancarias (open banking, donde sea posible).
  * Multiusuario/workspaces, planes de suscripción, límites.

-----

# Addendum — Cambios Solicitados (Agosto 2025)

## 1\) Mobile con **Flutter**

  * La primera etapa será **Web + API** para uso personal.
  * Cuando se habilite mobile, la app será construida en **Flutter** (Dart) consumiendo la **misma API** y compartiendo contratos (OpenAPI/JSON Schema) y reglas de negocio.
  * El **target móvil oficial** pasa a ser **Flutter**.

## 2\) Compras en **cuotas sin intereses** con seguimiento de pagos

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

## 3\) **Préstamos que YO realizo** (lending personal)

### Objetivo

Llevar control de dinero prestado a terceros: desembolso, cronograma (si aplica), pagos parciales, intereses opcionales, moras/fees y estado del préstamo.

### Entidades nuevas

  * `Counterparty` (persona/empresa): { id, name, phone?, email?, note? }.
  * `Loan`: { id, counterpartyId, principal, interestRate?, scheduleType: INTEREST\_FREE|SIMPLE|FIXED, issueDate, termMonths?, outstandingPrincipal, status }.
  * `LoanPayment`: { id, loanId, date, amount, allocation: PRINCIPAL|INTEREST|FEE, note? }.

### API

  * `POST /loans` (crear); `GET /loans/:id` (detalle); `POST /loans/:id/payments` (registrar cobro parcial/total); `PATCH /loans/:id` (reestructurar/cerrar).
  * `GET /reports/loans-summary` (colocado total, cobrado, saldo, moras).

### Reglas de Negocio

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

### Reportes y Recordatorios

  * Widgets en Dashboard: **Saldo prestado**, **Cobros próximos**.
  * Jobs de notificación (Lima TZ): avisos previos a vencimiento y recordatorios de cobro.

-----

## Concepciones Clave para el Lanzamiento

Estas ideas son ahora parte integral de la fase inicial del proyecto y serán consideradas como requisitos fundamentales para garantizar la robustez y una experiencia de usuario superior.

### 1\. Manejo de Reembolsos y Devoluciones

Se implementará una lógica para gestionar **reembolsos** y **devoluciones**, un caso de uso común que impacta directamente en la conciliación de saldos.

  * **Nuevo Tipo de Transacción**: Se creará un tipo de transacción específico, como `REFUND` o `REIMBURSEMENT`.
  * **Lógica de Ajuste**: El sistema permitirá anular una transacción previa o registrar un nuevo movimiento que ajuste el saldo de la cuenta o tarjeta. Por ejemplo, un reembolso a una tarjeta de crédito podría reducir el `paidAmount` pendiente de una compra o generar un crédito para futuras transacciones.

### 2\. Flexibilidad en Préstamos Otorgados

Para hacer la gestión de préstamos a terceros más realista, se considera:

  * **Asignación de Pagos Flexible**: En lugar de una regla estricta de asignación de pagos (`INTEREST → PRINCIPAL → FEE`), el sistema ofrecerá al usuario la opción de definir cómo se asigna cada pago recibido, permitiendo un mayor control sobre la contabilidad de la deuda.
  * **Opción de Condonación**: Se añadirá una funcionalidad explícita para **condonar** total o parcialmente el saldo de un préstamo. Esta acción ajustará el `outstandingPrincipal` sin necesidad de un registro de pago, lo que es útil en situaciones de negociación o perdón de deuda.

### 3\. Usabilidad Avanzada y Analíticas

  * **Gráficos Interactivos**: El dashboard incluirá gráficos dinámicos que permitan filtrar la información financiera por diferentes criterios (fecha, categoría, cuenta), ofreciendo una visualización más profunda de los hábitos de gasto.
  * **Metas de Ahorro**: Se añadirá un módulo para que los usuarios establezcan objetivos de ahorro específicos y rastreen su progreso. Esta funcionalidad está diseñada para ser un motor de motivación y ayuda a los usuarios a alcanzar sus metas financieras.
  * **Soporte Multi-Moneda**: Aunque la moneda base es el PEN, la arquitectura será diseñada para permitir el registro de transacciones en múltiples divisas, lo que es crucial para usuarios que viajan o manejan cuentas en el extranjero.
  * **Importación Inteligente**: El sistema podría "aprender" de las categorizaciones del usuario durante la importación desde CSV/Excel y sugerir o pre-categorizar transacciones futuras basándose en el beneficiario o la descripción.

-----

## Configuración del Entorno de Desarrollo

Para poner en marcha el proyecto localmente, necesitarás los siguientes prerrequisitos y seguir estos pasos:

### Prerrequisitos

  * **Node.js**: Versión 18 o superior.
  * **npm** (Node Package Manager): Viene con Node.js.
  * **PostgreSQL**: Una instancia local de PostgreSQL en ejecución.
  * **Git**: Para clonar el repositorio.

### Pasos de Instalación

1.  **Clonar el Repositorio**:
    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd <nombre_del_repositorio>
    ```
2.  **Configurar la Base de Datos**:
    Asegúrate de que tu instancia local de PostgreSQL esté en funcionamiento.
    Crea una base de datos para el proyecto.
3.  **Instalar Dependencias del Backend**:
    ```bash
    cd FinanzasBackend
    npm install
    ```
4.  **Configurar Variables de Entorno del Backend**:
    Crea un archivo `.env` en la raíz del directorio del backend (`FinanzasBackend`) con la variable de entorno `DATABASE_URL` apuntando a tu base de datos local.
    Ejemplo: `DATABASE_URL="postgresql://user:password@localhost:5432/database_name"`
5.  **Ejecutar el Script de Creación de la Base de Datos**:
    Ejecuta el contenido del script `create_db.sql` en tu base de datos para crear las tablas necesarias.
6.  **Instalar Dependencias del Frontend**:
    ```bash
    cd ../FinanzasFrontend
    npm install
    ```
7.  **Configurar Variables de Entorno del Frontend**:
    Crea un archivo `.env.local` en la raíz del directorio del frontend (`FinanzasFrontend`) con la variable `VITE_API_URL` apuntando a la URL del backend (ej. `VITE_API_URL=http://localhost:3000/api`).

-----

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

-----

## Pruebas

Para ejecutar las pruebas del proyecto:

  * **Backend**:
    ```bash
    cd backend
    npm test # o el comando de pruebas configurado (ej. `npm run test:e2e`)
    ```
  * **Frontend**:
    ```bash
    cd frontend
    npm test # o el comando de pruebas configurado
    ```

-----

## Despliegue

El despliegue final está planificado para **Azure**. Los detalles específicos de CI/CD y la configuración de los servicios de Azure (App Services, Azure Database for PostgreSQL, Azure Cache for Redis) se documentarán en una fase posterior del proyecto.

-----

## Futuras Mejoras

  * Integración automática con bancos y tarjetas (API bancaria / scraping).
  * Machine Learning para predicción de gastos futuros.
  * Recomendaciones personalizadas de ahorro.
  * Exportación de reportes (PDF, Excel).
  * Sincronización multi-dispositivo en tiempo real.
  * Recomendaciones inteligentes (ML ligero), OCR de vouchers.