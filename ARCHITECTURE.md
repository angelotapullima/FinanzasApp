# Documento de Arquitectura del Proyecto de Finanzas Personales

## 1. Introducción y Visión General

Este documento describe la arquitectura propuesta para la aplicación de control financiero personal, con una visión a futuro de escalabilidad a un modelo SaaS multiusuario. El objetivo principal es registrar y gestionar de forma eficiente gastos, ingresos, cuentas bancarias, tarjetas de crédito, deudas, préstamos y presupuestos, inicialmente para uso personal vía web, con una futura expansión a una aplicación móvil en Flutter.

## 2. Arquitectura de Alto Nivel

La aplicación sigue una arquitectura de microservicios o una arquitectura modular bien definida, separando claramente las responsabilidades entre el frontend, el backend (API) y la base de datos, complementada con servicios de caché/jobs.

```
+-------------------+       +-------------------+       +-------------------+
|     Frontend      |       |      Backend      |       |    Base de Datos  |
|   (Web / Mobile)  | <---> |       (API)       | <---> |    (PostgreSQL)   |
+-------------------+       +-------------------+       +-------------------+
        ^
        |
        +---------------------------+
              Cache / Jobs (Redis)
```

**Tecnologías Clave por Capa:**

*   **Frontend (Web)**: Vue3, TypeScript, shadcn/ui, Tailwind CSS.
*   **Frontend (Mobile)**: Flutter (Dart).
*   **Backend (API)**: Node.js + TypeScript (NestJS o Express con modularización).
*   **Base de Datos**: PostgreSQL.
*   **ORM**: SQL Puro (futuro TypeORM).
*   **Cache/Jobs**: Redis.
*   **Infraestructura**: Docker Compose (local), escalable a Azure (PaaS, DBaaS).

## 3. Componentes Detallados

### 3.1. Frontend (Web)

El frontend web es la interfaz principal para el usuario, construida con un enfoque en la experiencia de usuario (UX) y la interfaz de usuario (UI).

*   **Tecnologías**: Vue3, TypeScript, shadcn/ui, Tailwind CSS.
*   **Módulos/Funcionalidades Principales**:
    *   **Dashboard / Vista General**: Resumen financiero con saldos, progreso de presupuestos, próximos vencimientos y gráficos de gastos/ingresos.
    *   **Gestión de Cuentas**: CRUD (Crear, Leer, Actualizar, Eliminar) para cuentas bancarias, efectivo y billeteras digitales.
    *   **Registro de Transacciones**: Formularios para registrar ingresos, gastos y transferencias internas, con selección de tipo, monto, fecha, descripción, cuenta y categoría.
    *   **Gestión de Categorías**: CRUD para categorías personalizadas de transacciones.
    *   **Presupuestos Mensuales**: Listado y gestión de presupuestos por categoría y mes, con seguimiento del gasto y opción de *rollover*.
    *   **Compras en Cuotas sin Intereses**: Registro y seguimiento de planes de cuotas, con detalle de cuotas individuales, pagos parciales y prepagos.
    *   **Préstamos que YO Realizo**: Gestión de préstamos otorgados a terceros, incluyendo registro de desembolsos, pagos recibidos, reestructuraciones y condonaciones.
    *   **Reportes y Análisis**: Visualizaciones (gráficos de barras, pastel, líneas) y tablas para entender patrones financieros (gastos por categoría, flujo de caja, evolución de saldos).
    *   **Importación de Datos**: Carga masiva de transacciones desde archivos CSV/Excel con mapeo de columnas y previsualización.
    *   **Alertas y Notificaciones**: Sistema de notificaciones para vencimientos, presupuestos excedidos, etc.
*   **Flujo de Interacción con la API**: Cada funcionalidad del frontend interactúa con el backend a través de endpoints RESTful específicos (ej. `GET /accounts`, `POST /transactions`, `PUT /budgets/:id`).

### 3.2. Backend (API)

El backend es el cerebro de la aplicación, responsable de la lógica de negocio, la persistencia de datos y la exposición de la API.

*   **Tecnologías**: Node.js + TypeScript (NestJS o Express con modularización).
*   **Responsabilidades**:
    *   **Exposición de API RESTful**: Provee los endpoints necesarios para que el frontend interactúe con los datos y la lógica de negocio.
    *   **Lógica de Negocio**: Implementa las reglas financieras, validaciones de datos, cálculos de saldos, gestión de presupuestos, lógica de cuotas y préstamos.
    *   **Interacción con la Base de Datos**: Interactúa con PostgreSQL utilizando SQL puro, realizando operaciones CRUD y consultas complejas. Se planea migrar a TypeORM en el futuro.
    *   **Autenticación**: Inicialmente una autenticación simple para uso personal, diseñada para escalar a sistemas más robustos como OAuth/JWT para el modelo SaaS.
*   **Endpoints Clave (Ejemplos)**:
    *   `/accounts`: GET, POST, PUT, DELETE
    *   `/transactions`: POST (maneja ingresos, gastos, transferencias)
    *   `/categories`: GET, POST, PUT, DELETE
    *   `/budgets`: GET, POST, PUT
    *   `/installment-plans`: GET, POST
    *   `/installments/:id/pay`: POST
    *   `/installment-plans/:id/prepay`: POST
    *   `/loans`: GET, POST, PUT
    *   `/loans/:id/payments`: POST
    *   `/reports/*`: GET (para diferentes tipos de reportes)
    *   `/import/transactions`: POST (para importación de CSV/Excel)
    *   `/notifications`: GET, PUT

### 3.3. Base de Datos

PostgreSQL es la base de datos relacional elegida, gestionada a través de SQL puro. Se planea migrar a TypeORM en el futuro para un desarrollo más eficiente y tipado seguro.

*   **Tecnología**: PostgreSQL.
*   **ORM**: SQL Puro (futuro TypeORM).
*   **Esquema de Datos (Definido en `create_db.sql`)**:

    *   `User`: Gestión de usuarios (preparado para SaaS).
        *   `id`, `email`, `name`, `password`, `createdAt`, `updatedAt`.
    *   `Account`: Cuentas financieras (banco, efectivo, billetera).
        *   `id`, `name`, `type` (BANK, CASH, E_WALLET), `currency` (PEN), `balance`, `userId`.
    *   `Category`: Categorías de transacciones.
        *   `id`, `name`, `userId`.
    *   `Transaction`: El corazón de los movimientos financieros.
        *   `id`, `description`, `amount`, `date`, `type` (REGULAR, TRANSFER, LENDING, INSTALLMENT), `accountId`, `categoryId`, `userId`.
        *   `linkedTransactionId`: Para enlazar transacciones de transferencia.
    *   `Budget`: Presupuestos mensuales por categoría.
        *   `id`, `year`, `month`, `amount`, `rollover`, `categoryId`, `userId`.
    *   `Counterparty`: Entidades a las que se les presta dinero.
        *   `id`, `name`, `userId`.
    *   `Loan`: Préstamos que el usuario ha otorgado a terceros.
        *   `id`, `principal`, `outstandingPrincipal`, `issueDate`, `status` (ACTIVE, CLOSED), `counterpartyId`, `userId`.
    *   `InstallmentPlan`: Planes de compras a cuotas sin interés.
        *   `id`, `description`, `totalAmount`, `installments`, `userId`.

### 3.4. Otros Servicios

*   **Redis (Cache/Jobs)**: Utilizado para tareas en segundo plano (ej. procesamiento de importaciones, generación de reportes complejos) y para caching de datos frecuentemente accedidos, mejorando el rendimiento.

## 4. Lógica Financiera Clave

La aplicación incorpora lógica financiera específica para manejar escenarios complejos:

*   **Compras sin Cuotas (con seguimiento de pago)**:
    *   Registradas como `Transaction` con `isInstallment=false` (aunque este campo no está en el `schema.prisma` actual, se menciona en `README4.md` como una extensión).
    *   El `paidAmount` (también mencionado en `README4.md` como extensión) se actualiza con los pagos, y la compra se liquida cuando `paidAmount` iguala el `amount` total.
*   **Préstamos Entregados (`Loan`)**:
    *   El `outstandingPrincipal` se reduce con cada `LoanPayment` recibido.
    *   El estado del préstamo cambia a `CLOSED` cuando `outstandingPrincipal` llega a cero.
    *   Se contempla la asignación flexible de pagos (principal, interés, fees) y la condonación de deuda.
*   **Compras en Cuotas sin Intereses (`InstallmentPlan`)**:
    *   Permite registrar pagos parciales por cuota (`POST /installments/:id/pay`).
    *   Soporta prepagos con estrategias de reducción de plazo o monto (`POST /installments/plans/:id/prepay`).
*   **Manejo de Reembolsos y Devoluciones**:
    *   Se introducirá un tipo de transacción `REFUND` o lógica de ajuste para anular o compensar transacciones previas, impactando directamente los saldos.
*   **Transferencias Internas**:
    *   Las transferencias entre cuentas (ej. banco a efectivo) ajustan automáticamente los saldos de ambas cuentas, manteniendo la conciliación.

## 5. Escalabilidad y Despliegue

El diseño de la arquitectura considera la escalabilidad desde el inicio:

*   **Escalabilidad**:
    *   **Horizontal**: El backend modular y el uso de Docker facilitan la escalabilidad horizontal de los servicios.
    *   **Base de Datos**: PostgreSQL es robusto y escalable, y el uso de DBaaS en Azure permitirá una gestión simplificada de la escalabilidad de la base de datos.
    *   **Cache/Jobs**: Redis es fundamental para manejar tareas asíncronas y reducir la carga de la base de datos.
*   **Despliegue**:
    *   **Local**: Docker Compose para levantar el entorno de desarrollo (PostgreSQL, Redis).
    *   **Producción**: Planificado para Azure, utilizando servicios PaaS (App Services para el backend, Azure Database for PostgreSQL, Azure Cache for Redis).
    *   **CI/CD**: Se implementarán pipelines de Integración Continua y Despliegue Continuo para automatizar el proceso de entrega.

## 6. Entorno de Desarrollo

Para configurar el entorno de desarrollo local:

*   **Prerrequisitos**: Node.js (v18+), npm, Docker y Docker Compose, Git.
*   **Pasos de Instalación y Ejecución**:
    1.  Clonar el repositorio.
    2.  `docker-compose up -d` para levantar DB y Redis.
    3.  `cd backend && npm install`
    4.  Configurar `.env` en el backend.
    5.  `cd ../frontend && npm install`
    6.  Configurar `.env.local` en el frontend.
    7.  `cd backend && npm run start:dev`
    8.  `cd ../frontend && npm run dev`

## 7. Roadmap (Resumen)

El proyecto se desarrollará en fases:

*   **Fase 1 — Personal (Web)**: Enfoque en las funcionalidades básicas de registro, gestión de cuentas, presupuestos y préstamos para uso personal.
*   **Fase 2 — Personal (Móvil Flutter)**: Desarrollo de la aplicación móvil en Flutter, consumiendo la misma API, con sincronización y notificaciones optimizadas para móvil.
*   **Fase 3 — SaaS**: Implementación de funcionalidades multiusuario, roles, permisos, suscripciones e integraciones bancarias para escalar a un modelo de negocio SaaS.
