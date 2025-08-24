# Funcionalidades del Frontend: Diseño y Flujo de Usuario

Este documento detalla las funcionalidades clave de la aplicación desde la perspectiva del frontend, describiendo cómo el usuario interactuará con cada característica y qué datos se mostrarán o se requerirán. Sirve como una guía para el desarrollo de la interfaz de usuario, asegurando que todas las necesidades del negocio estén cubiertas.

---

## 1. Dashboard / Vista General

*   **Objetivo**: Proporcionar un resumen rápido y visual del estado financiero del usuario.
*   **Flujo de Usuario (UX/UI)**:
    *   Pantalla principal al iniciar sesión.
    *   Widgets o tarjetas con información clave.
    *   Navegación a secciones detalladas.
*   **Datos a Mostrar/Ingresar**:
    *   **Saldos Totales**: Suma de todos los saldos de cuentas (bancos, efectivo, tarjetas).
    *   **Saldos por Cuenta**: Lista de cuentas con su nombre, tipo y saldo actual.
    *   **Progreso de Presupuestos**: Barras de progreso para categorías con presupuesto definido (ej: "Comida: S/ 500 de S/ 800").
    *   **Próximos Vencimientos**: Recordatorios de pagos de tarjetas, cuotas de préstamos recibidos o a pagar.
    *   **Resumen de Gastos/Ingresos**: Gráfico simple de barras o pastel de gastos por categoría del mes actual.
*   **Integración con la API**: `GET /accounts`, `GET /budgets/summary`, `GET /transactions/summary`, `GET /loans/upcoming`.

---

## 2. Gestión de Cuentas (Bancos, Efectivo, Billeteras)

*   **Objetivo**: Permitir al usuario registrar, ver, editar y eliminar sus diferentes fuentes de dinero.
*   **Flujo de Usuario (UX/UI)**:
    *   **Listado**: Tabla o lista de todas las cuentas con opción de ver detalle/editar.
    *   **Crear Nueva Cuenta**: Formulario con campos para `nombre`, `tipo` (dropdown: Banco, Efectivo, Billetera), `moneda` (dropdown: PEN), `saldo inicial`.
    *   **Editar Cuenta**: Formulario pre-llenado con datos de la cuenta seleccionada.
*   **Datos a Mostrar/Ingresar**:
    *   `id`, `name`, `type`, `currency`, `balance`.
*   **Integración con la API**: `GET /accounts`, `POST /accounts`, `PUT /accounts/:id`, `DELETE /accounts/:id`.

---

## 3. Registro de Transacciones (Ingresos, Gastos, Transferencias)

*   **Objetivo**: Registrar todos los movimientos financieros del usuario.
*   **Flujo de Usuario (UX/UI)**:
    *   **Botón "Nueva Transacción"**: Abre un modal o una nueva página.
    *   **Selector de Tipo**: Radio buttons o tabs para elegir `Gasto`, `Ingreso`, `Transferencia`.
    *   **Formulario de Gasto/Ingreso**:
        *   `Monto` (numérico).
        *   `Fecha` (selector de fecha).
        *   `Descripción` (texto libre).
        *   `Cuenta` (dropdown de cuentas del usuario).
        *   `Categoría` (dropdown de categorías del usuario).
        *   `Notas` (opcional).
    *   **Formulario de Transferencia**:
        *   `Monto`.
        *   `Fecha`.
        *   `Cuenta Origen` (dropdown).
        *   `Cuenta Destino` (dropdown).
        *   `Descripción` (opcional).
*   **Datos a Mostrar/Ingresar**:
    *   `amount`, `date`, `description`, `accountId`, `categoryId`.
    *   Para transferencias: `sourceAccountId`, `destinationAccountId`.
*   **Integración con la API**: `POST /transactions` (con lógica interna para manejar `TRANSFER` type).

---

## 4. Gestión de Categorías

*   **Objetivo**: Permitir al usuario organizar sus transacciones mediante categorías personalizadas.
*   **Flujo de Usuario (UX/UI)**:
    *   **Listado**: Tabla o lista de categorías existentes.
    *   **Crear/Editar Categoría**: Formulario simple con campo `nombre`.
*   **Datos a Mostrar/Ingresar**:
    *   `id`, `name`.
*   **Integración con la API**: `GET /categories`, `POST /categories`, `PUT /categories/:id`, `DELETE /categories/:id`.

---

## 5. Presupuestos Mensuales

*   **Objetivo**: Ayudar al usuario a controlar sus gastos por categoría.
*   **Flujo de Usuario (UX/UI)**:
    *   **Listado de Presupuestos**: Tabla o tarjetas mostrando `categoría`, `mes/año`, `monto presupuestado`, `monto gastado`, `restante` y `progreso` (barra).
    *   **Crear/Editar Presupuesto**: Formulario con `categoría` (dropdown), `mes/año` (selector), `monto` y `rollover` (checkbox).
    *   **Detalle de Presupuesto**: Posibilidad de ver las transacciones asociadas a ese presupuesto.
*   **Datos a Mostrar/Ingresar**:
    *   `categoryId`, `year`, `month`, `amount`, `rollover`.
    *   Calculados: `spentAmount`, `remainingAmount`.
*   **Integración con la API**: `GET /budgets`, `POST /budgets`, `PUT /budgets/:id`, `GET /budgets/:id/transactions`.

---

## 6. Compras en Cuotas sin Intereses

*   **Objetivo**: Registrar y seguir el pago de compras financiadas en cuotas sin intereses.
*   **Flujo de Usuario (UX/UI)**:
    *   **Listado de Planes de Cuotas**: Tabla o lista de `InstallmentPlan` con `descripción`, `monto total`, `cuotas`, `pagado/pendiente` (barra de progreso).
    *   **Crear Nuevo Plan**: Formulario con `descripción`, `monto total`, `número de cuotas`, `fecha de compra`, `tarjeta asociada`.
    *   **Detalle del Plan**: Muestra el `InstallmentPlan` y una lista de sus `Installment` individuales (`número de cuota`, `monto`, `fecha de vencimiento`, `estado` (Pagada/Pendiente)).
    *   **Acciones en Detalle**: Botones para `Pagar Cuota` (registra un pago parcial/total) y `Prepagar` (con opciones de `reduce_term` o `reduce_amount`).
*   **Datos a Mostrar/Ingresar**:
    *   `InstallmentPlan`: `description`, `totalAmount`, `installments`.
    *   `Installment`: `amount`, `dueDate`, `paidAmount`, `status`.
*   **Integración con la API**: `GET /installment-plans`, `POST /installment-plans`, `POST /installments/:id/pay`, `POST /installment-plans/:id/prepay`.

---

## 7. Préstamos que YO Realizo (Lending Personal)

*   **Objetivo**: Controlar el dinero prestado a terceros, incluyendo seguimiento de pagos y estado.
*   **Flujo de Usuario (UX/UI)**:
    *   **Listado de Préstamos**: Tabla o lista de `Loan` con `beneficiario`, `monto principal`, `saldo pendiente`, `estado`.
    *   **Crear Nuevo Préstamo**: Formulario con `beneficiario` (seleccionar existente o crear nuevo `Counterparty`), `monto principal`, `fecha de desembolso`, `tasa de interés` (opcional), `tipo de cronograma`.
    *   **Detalle del Préstamo**: Muestra `Loan` y una lista de `LoanPayment` (`fecha`, `monto`, `asignación`).
    *   **Acciones en Detalle**: Botones para `Registrar Pago` (formulario de `monto`, `fecha`, `asignación`), `Reestructurar`, `Condonar`.
*   **Datos a Mostrar/Ingresar**:
    *   `Loan`: `principal`, `outstandingPrincipal`, `issueDate`, `status`, `counterpartyId`.
    *   `Counterparty`: `name`, `phone`, `email`.
    *   `LoanPayment`: `amount`, `date`, `allocation`.
*   **Integración con la API**: `GET /loans`, `POST /loans`, `PUT /loans/:id`, `POST /loans/:id/payments`, `POST /counterparties`.

---

## 8. Reportes y Análisis

*   **Objetivo**: Proporcionar visualizaciones y resúmenes para entender los patrones financieros.
*   **Flujo de Usuario (UX/UI)**:
    *   **Selector de Reporte**: Dropdown o tabs para elegir tipo de reporte (ej: "Gastos por Categoría", "Flujo de Caja", "Evolución de Saldos").
    *   **Selector de Período**: Selector de rango de fechas (mes, año, personalizado).
    *   **Visualización**: Gráficos (barras, pastel, líneas) y tablas de datos.
*   **Datos a Mostrar/Ingresar**:
    *   Agregaciones de `Transaction` (suma por categoría, por mes).
    *   Evolución de `Account.balance`.
    *   Resúmenes de `Loan`.
*   **Integración con la API**: `GET /reports/spending-by-category`, `GET /reports/cash-flow`, `GET /reports/balance-evolution`, etc.

---

## 9. Importación de Datos (CSV/Excel)

*   **Objetivo**: Facilitar la carga masiva de transacciones desde extractos bancarios.
*   **Flujo de Usuario (UX/UI)**:
    *   **Botón "Importar"**: Abre un modal o una nueva página.
    *   **Carga de Archivo**: Campo para subir archivo CSV/Excel.
    *   **Mapeo de Columnas**: Interfaz para que el usuario asigne las columnas del archivo a los campos de la transacción (ej: "Columna A" es `Monto`, "Columna B" es `Descripción`).
    *   **Previsualización**: Muestra las primeras filas de datos mapeados para confirmación.
    *   **Confirmación/Importación**: Botón para iniciar la importación.
*   **Datos a Mostrar/Ingresar**:
    *   Archivo CSV/Excel.
    *   Mapeo de columnas.
*   **Integración con la API**: `POST /import/transactions` (con el archivo y el mapeo).

---

## 10. Alertas y Notificaciones

*   **Objetivo**: Informar al usuario sobre eventos importantes (vencimientos, presupuestos excedidos).
*   **Flujo de Usuario (UX/UI)**:
    *   **Icono de Notificaciones**: En la cabecera, con un contador de notificaciones no leídas.
    *   **Panel de Notificaciones**: Lista de alertas (ej: "Tu presupuesto de Comida está al 90%", "Próximo pago de tarjeta el 25/08").
    *   **Configuración de Alertas**: Opcional, permitir al usuario personalizar qué alertas quiere recibir.
*   **Datos a Mostrar/Ingresar**:
    *   Mensaje de la alerta, fecha, tipo.
*   **Integración con la API**: `GET /notifications`, `PUT /notifications/:id/read`.
