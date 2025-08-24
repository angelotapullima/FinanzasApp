# 📒 Finanzas Personales — Documentación Inicial

Aplicación web (y posteriormente móvil en Flutter) para gestión integral de finanzas personales. La prioridad es una **versión para uso personal**, escalable hacia un **producto SaaS** más adelante.

---

## 🎯 Objetivo General

Permitir registrar, organizar y analizar de forma clara todas las finanzas personales, incluyendo:

* Gastos diarios y presupuestos.
* Cuentas bancarias, tarjetas de crédito y efectivo.
* Compras en cuotas sin intereses con seguimiento de pagos.
* Deudas y planes de pago.
* Préstamos que uno otorga a otras personas.
* Transferencias entre cuentas para mantener la conciliación.
* Reportes y alertas sobre la salud financiera.

---

## 🧩 Core de Negocio

### 1. **Cuentas y saldos**

* **Bancos**: saldo actual, movimientos, transferencias.
* **Tarjetas de crédito**:

  * Crédito total, crédito utilizado y disponible.
  * Compras directas y en cuotas.
  * Pagos manuales y automáticos.
* **Efectivo**: se actualiza con ingresos, gastos y transferencias desde cuentas o retiros de cajeros.

### 2. **Gastos y compras**

* Registro de gastos simples (sin cuotas).
* Clasificación por categorías (alimentación, transporte, entretenimiento, etc.).
* Gastos en cuotas sin interés:

  * Número de cuotas.
  * Cuotas pagadas y pendientes.
  * Posibilidad de pago anticipado.
* Comparación con presupuesto mensual.

### 3. **Deudas y planes de pago**

* Registro de deudas personales (ej: préstamos bancarios, créditos externos).
* Plan de pago asociado:

  * Monto total, número de cuotas, tasa de interés.
  * Calendario de vencimientos.
  * Estado de cada cuota (pendiente, pagada, en mora).
* Alertas de vencimiento próximo.

### 4. **Préstamos otorgados**

* Registro de dinero prestado a terceros.
* Datos del deudor.
* Monto, condiciones (con o sin interés).
* Cronograma de pagos.
* Control de pagos recibidos, saldo pendiente, intereses generados.
* Historial de cumplimiento.

### 5. **Transferencias internas**

* Transferencia de fondos entre:

  * Banco → Efectivo.
  * Banco → Tarjeta de crédito.
  * Efectivo → Banco.
* Toda transferencia debe cuadrar para que los saldos globales sean consistentes.

### 6. **Conciliación financiera**

* El sistema debe reflejar que **todo movimiento tiene origen y destino**.
* Validación de que los saldos totales suman correctamente.
* Reporte de discrepancias.

### 7. **Presupuestos y alertas**

* Definir un presupuesto mensual por categoría y total.
* Seguimiento en tiempo real del gasto frente al presupuesto.
* Alertas:

  * Presupuesto alcanzado o excedido.
  * Vencimientos próximos de deudas o préstamos.
  * Cuotas de tarjeta de crédito pendientes.

### 8. **Reportes y análisis**

* Evolución de saldos en el tiempo.
* Distribución de gastos por categoría.
* Comparativa ingresos vs. gastos.
* Estado de deudas y préstamos.
* Flujo neto de efectivo.

---

## 🛠️ Arquitectura inicial

* **Frontend (fase 1 personal)**: Web App con React + Tailwind.
* **Backend**: Node.js + TypeScript + NestJS.
* **Base de datos**: PostgreSQL (via Prisma ORM).
* **Autenticación**: simple (para uso personal), escalable a OAuth/JWT.
* **Infraestructura**: Docker Compose local; escalable a Azure (PaaS, DBaaS) en versión SaaS.
* **Móvil (fase 2 personal)**: Flutter, compartiendo backend y contratos.
* **SaaS (fase 3)**: Multiusuario, multiempresa, facturación y planes.

---

## 📌 Roadmap de implementación

### Fase 1 — Personal (Web)

* [ ] Registro manual de gastos y compras simples.
* [ ] Manejo de cuentas bancarias, efectivo y tarjetas.
* [ ] Transferencias internas.
* [ ] Presupuesto mensual básico.
* [ ] Reporte simple de gastos y saldos.

### Fase 2 — Personal (Móvil Flutter)

* [ ] Sincronización con backend.
* [ ] Interfaz optimizada para uso rápido en celular.
* [ ] Notificaciones locales (ej: recordatorio de cuota).

### Fase 3 — SaaS

* [ ] Autenticación multiusuario.
* [ ] Roles y permisos.
* [ ] Facturación.
* [ ] Dashboard avanzado con insights financieros.
* [ ] Integración con APIs bancarias (open banking, donde sea posible).

---

## 🔮 Futuras mejoras

* Integración automática con bancos y tarjetas (API bancaria / scraping).
* Machine Learning para predicción de gastos futuros.
* Recomendaciones personalizadas de ahorro.
* Exportación de reportes (PDF, Excel).
* Sincronización multi-dispositivo en tiempo real.
