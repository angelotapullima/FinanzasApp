# Plan de Implementación del Proyecto Finanzas Personales

Este documento detalla el plan de acción para implementar las funcionalidades del proyecto, siguiendo un enfoque iterativo y por fases.

## Fase 1: Configuración y Gestión de Cuentas [COMPLETA] [COMPLETA]

### Objetivo
Establecer el entorno de desarrollo y desarrollar la funcionalidad completa de gestión de cuentas (CRUD) tanto en el backend como en el frontend, incluyendo pruebas unitarias en el backend.

### Tareas

- [ ] **1. Configuración Inicial y Verificación del Entorno**
    - [x] 1.1. Verificar la ubicación de `docker-compose.yml` (confirmado en la conversación previa).
    - [ ] 1.2. **Configurar la conexión a la base de datos PostgreSQL local.** (Ajuste: No usar Docker para PostgreSQL, usar la instancia local del usuario).
    - [x] 1.3. **Crear la base de datos y las tablas necesarias manualmente o mediante scripts SQL.** (Ajuste: No usar migraciones de Prisma, usar SQL puro).
    - [ ] 1.4. Instalar dependencias del Backend (`FinanzasBackend`).
    - [ ] 1.5. Instalar dependencias del Frontend (`FinanzasFrontend`).
    - [x] 1.6. Iniciar el servidor de desarrollo del Backend.
    - [ ] 1.7. Iniciar el servidor de desarrollo del Frontend.
    - [x] 1.8. Confirmar que ambos servidores están operativos y accesibles.

- [x] **2. Implementación Backend: Gestión de Cuentas (`FinanzasBackend`)**
    - [x] 2.1. Analizar la estructura de carpetas existente (`src/repositories`, `src/routes`, `src/services`) para replicar el patrón.
    - [x] 2.2. Crear el repositorio para `Account` **utilizando SQL puro para las interacciones con la base de datos.**
    - [x] 2.3. Crear el servicio para `Account` con lógica de negocio para CRUD.
    - [x] 2.4. Crear las rutas (controladores) para `Account` (GET, POST, PUT, DELETE).
    - [x] 2.5. Implementar la lógica CRUD en el servicio y las rutas.
    - [x] 2.6. Escribir tests unitarios para el servicio de `Account`.

- [x] **3. Implementación Frontend: Gestión de Cuentas (`FinanzasFrontend`)**
    - [x] 3.1. Analizar la estructura de carpetas existente (`src/components`, `src/views`, `src/router`, `src/stores`).
    - [x] 3.2. Crear un componente Vue para la lista de cuentas (`AccountList.vue`).
    - [x] 3.3. Crear un componente Vue para el formulario de creación/edición de cuentas (`AccountForm.vue`).
    - [x] 3.4. Crear un store (Pinia) para la gestión del estado de las cuentas.
    - [x] 3.5. Integrar los componentes con el store y la API del backend.
    - [x] 3.6. Añadir las rutas necesarias en `src/router/index.ts` para la sección de cuentas.

## Fases Futuras (Esquema General)

- [x] **3. Registro de Transacciones (Ingresos, Gastos, Transferencias)**
- [x] **4. Gestión de Categorías**
- [x] **Fase 4: Presupuestos Mensuales**
- [x] **Fase 5: Compras en Cuotas sin Intereses**
- [x] **Fase 6: Préstamos que YO Realizo (Lending Personal)**
- [ ] **Fase 7: Reportes y Análisis**
    - [x] 7.1. **Reporte: Gastos por Categoría** (Backend y Frontend)
    - [ ] 7.2. **Reporte: Flujo de Caja** (Backend y Frontend)
    - [ ] 7.3. **Reporte: Evolución de Saldos** (Backend y Frontend)
    - [ ] 7.4. **Reporte: Resumen de Ingresos y Gastos** (Backend y Frontend)
    - [ ] 7.5. **Reporte: Obligaciones Próximas / Pagos Pendientes** (Backend y Frontend)
    - [ ] 7.6. **Reporte: Resumen de Presupuestos** (Backend y Frontend)
    - [ ] 7.7. **Reporte: Estado de Préstamos y Cuotas** (Backend y Frontend)
    - [x] 7.1. **Reporte: Gastos por Categoría** (Backend y Frontend)
    - [ ] 7.2. **Reporte: Flujo de Caja** (Backend y Frontend)
    - [ ] 7.3. **Reporte: Evolución de Saldos** (Backend y Frontend)
    - [ ] 7.4. **Reporte: Resumen de Ingresos y Gastos** (Backend y Frontend)
    - [ ] 7.5. **Reporte: Obligaciones Próximas / Pagos Pendientes** (Backend y Frontend)
    - [x] 7.6. **Reporte: Resumen de Presupuestos** (Backend y Frontend)
    - [ ] 7.7. **Reporte: Estado de Préstamos y Cuotas** (Backend y Frontend)
    - [ ] 7.8. **Refactorización del Sidebar para Reportes:** Implementar subsecciones colapsables para los reportes.
- [ ] **Fase 8: Importación de Datos (CSV/Excel)**
- [ ] **Fase 9: Alertas y Notificaciones**
- [ ] **Fase 10: Mejoras de UX y Pulido**
    - [ ] 10.1. **Feedback Inmediato:** Implementar notificaciones "Toast" para acciones exitosas/fallidas (crear, editar, eliminar).
    - [ ] 10.2. **Estados de Carga:** Mostrar esqueletos de carga o spinners mientras se obtienen datos de la API.
    - [ ] 10.3. **Estados Vacíos:** Diseñar y mostrar mensajes amigables con botones de acción cuando las listas están vacías (ej. "Aún no tienes cuentas. ¡Crea tu primera cuenta!").
    - [ ] 10.4. **Claridad en Formularios:** Adaptar formularios dinámicamente (ej. ocultar categoría en transferencias).
    - [ ] 10.5. **Detalles Visuales:** Mejorar la visualización en `LoanDetail.vue` y `InstallmentDetail.vue` con barras de progreso, colores de estado y resaltado de cuotas.
    - [ ] 10.6. **Guías de Usuario:** Añadir tooltips explicativos en campos complejos y placeholders descriptivos en inputs.