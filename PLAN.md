# Plan de Implementación del Proyecto Finanzas Personales

Este documento detalla el plan de acción para implementar las funcionalidades del proyecto, siguiendo un enfoque iterativo y por fases.

## Fase 1: Configuración y Gestión de Cuentas [COMPLETA] [COMPLETA]

### Objetivo
Establecer el entorno de desarrollo y desarrollar la funcionalidad completa de gestión de cuentas (CRUD) tanto en el backend como en el frontend, incluyendo pruebas unitarias en el backend.

### Tareas

- [ ] **1. Configuración Inicial y Verificación del Entorno**
    - [x] 1.1. Verificar la ubicación de `docker-compose.yml` (confirmado en la conversación previa).
    - [x] 1.2. **Configurar la conexión a la base de datos PostgreSQL local.** (Ajuste: No usar Docker para PostgreSQL, usar la instancia local del usuario).
    - [x] 1.3. **Crear la base de datos y las tablas necesarias manualmente o mediante scripts SQL.** (Ajuste: No usar migraciones de Prisma, usar SQL puro).
    - [x] 1.4. Instalar dependencias del Backend (`FinanzasBackend`).
    - [x] 1.5. Instalar dependencias del Frontend (`FinanzasFrontend`).
    - [x] 1.6. Iniciar el servidor de desarrollo del Backend.
    - [x] 1.7. Iniciar el servidor de desarrollo del Frontend.
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
    - [x] 7.2. **Reporte: Flujo de Caja** (Backend y Frontend)
    - [x] 7.3. **Reporte: Evolución de Saldos** (Backend y Frontend)
    - [x] 7.4. **Reporte: Resumen de Ingresos y Gastos** (Backend y Frontend)
    - [x] 7.5. **Reporte: Obligaciones Próximas / Pagos Pendientes** (Backend y Frontend)
    - [x] 7.6. **Reporte: Resumen de Presupuestos** (Backend y Frontend)
    - [x] 7.7. **Reporte: Estado de Préstamos y Cuotas** (Backend y Frontend)
    - [x] 7.8. **Refactorización del Sidebar para Reportes:** Implementar subsecciones colapsables para los reportes.
    - [x] 7.9. **Refactorización de Arquitectura de Reportes:** Migrar a páginas dedicadas por reporte (`/reports/flujo-de-caja`, etc.) y una página de índice en `/reports`.
    - [x] 7.10. **Mejoras de UX en Reportes:** Añadir carga por defecto (mes actual) y filtros rápidos (semana, día, rango personalizado) a todas las páginas de reportes.
- [x] **Fase 8: Importación de Datos (CSV/Excel)**
    - [x] 8.1. **Backend: Implementar endpoint para carga de archivos.**
        - [ ] 8.1.1. Crear ruta (`/api/import/transactions`) para recibir archivos (CSV/Excel).
        - [ ] 8.1.2. Configurar middleware para manejo de archivos (ej. `multer`).
        - [ ] 8.1.3. Implementar lógica inicial para guardar el archivo temporalmente en el servidor.
    - [x] 8.2. **Frontend: Desarrollar UI para carga de archivos.**
        - [ ] 8.2.1. Crear componente `DataImport.vue` con un input de tipo `file`.
        - [ ] 8.2.2. Integrar con `apiService` para enviar el archivo al backend.
    - [x] 8.3. **Backend: Procesamiento y validación de datos importados.**
        - [ ] 8.3.1. Implementar servicio para leer y parsear el archivo (CSV/Excel).
        - [ ] 8.3.2. Validar la estructura y el contenido de los datos (ej. tipos de datos, campos obligatorios).
        - [ ] 8.3.3. Mapear columnas del archivo a campos de la base de datos (ej. transacciones).
    - [x] 8.4. **Frontend: Previsualización y mapeo de columnas.**
        - [ ] 8.4.1. Mostrar una previsualización de los datos cargados.
        - [ ] 8.4.2. Permitir al usuario seleccionar el tipo de datos a importar (ej. transacciones, cuentas).
        - [ ] 8.4.3. Permitir al usuario mapear columnas del archivo a campos de la aplicación.
    - [x] 8.5. **Backend: Guardar datos importados en la base de datos.**
        - [ ] 8.5.1. Implementar lógica para insertar los datos validados en las tablas correspondientes.
        - [ ] 8.5.2. Manejar transacciones de base de datos para asegurar atomicidad.
    - [x] 8.6. **Frontend: Manejo de errores y feedback al usuario.**
        - [ ] 8.6.1. Mostrar mensajes de éxito o error durante el proceso de importación.
        - [ ] 8.6.2. Resaltar filas o campos con errores en la previsualización.
## Fase 9: Alertas y Notificaciones
    - [ ] 9.1. **Definir tipos de Alertas/Notificaciones:**
        - [ ] 9.1.1. Establecer una taxonomía para los tipos de mensajes (ej. `success`, `error`, `warning`, `info`).
        - [ ] 9.1.2. Decidir si las notificaciones serán solo efímeras (toasts) o persistentes (requieren almacenamiento en DB).
    - [ ] 9.2. **Frontend: Integrar sistema de Notificaciones Efímeras (Toasts):**
        - [ ] 9.2.1. Asegurar que el sistema de Toast de Shadcn UI esté completamente funcional y estilizado. (Ya implementado, pero se puede refinar).
        - [ ] 9.2.2. Implementar `useToast` en componentes clave para mostrar feedback de operaciones (ej. creación/edición/eliminación de cuentas, transacciones).
    - [ ] 9.3. **Backend: Implementar lógica para Notificaciones Persistentes (Opcional/Futuro):**
        - [ ] 9.3.1. Diseñar tabla `Notification` en la base de datos (si se decide por persistencia).
        - [ ] 9.3.2. Crear endpoints API para `GET /api/notifications` (obtener notificaciones del usuario) y `PUT /api/notifications/:id/read` (marcar como leída).
        - [ ] 9.3.3. Implementar lógica en servicios para generar y guardar notificaciones en la DB.
    - [ ] 9.4. **Frontend: Desarrollar UI para Centro de Notificaciones (Opcional/Futuro):**
        - [ ] 9.4.1. Crear un componente `NotificationCenter.vue` para listar notificaciones persistentes.
        - [ ] 9.4.2. Integrar con los endpoints del backend para mostrar y gestionar notificaciones.
    - [ ] 9.5. **Integración de Notificaciones en Flujos Clave:**
        - [ ] 9.5.1. Revisar flujos de usuario críticos (ej. importación de datos, creación de préstamos) para asegurar que se emitan notificaciones adecuadas.**
- [ ] **Fase 10: Mejoras de UX y Pulido**
    - [x] 10.1. **Feedback Inmediato:** Implementar notificaciones "Toast" para acciones exitosas/fallidas (crear, editar, eliminar).
    - [x] 10.2. **Estados de Carga:** Mostrar esqueletos de carga o spinners mientras se obtienen datos de la API.
    - [x] 10.3. **Estados Vacíos:** Diseñar y mostrar mensajes amigables con botones de acción cuando las listas están vacías (ej. "Aún no tienes cuentas. ¡Crea tu primera cuenta!").
    - [x] 10.4. **Claridad en Formularios:** Adaptar formularios dinámicamente (ej. ocultar categoría en transferencias).
    - [x] 10.5. **Detalles Visuales:** Mejorar la visualización en `LoanDetail.vue` y `InstallmentDetail.vue` con barras de progreso, colores de estado y resaltado de cuotas.
        - [x] 10.6. **Guías de Usuario:** Añadir tooltips explicativos en campos complejos y placeholders descriptivos en inputs.
    - [x] 10.7. **Migración a shadcn-vue:** Instalar y refactorizar componentes existentes para usar `shadcn-vue` y lograr un diseño profesional.
    - [x] 10.8. **Mejora de Layout y Scroll del Sidebar:** Implementación de scroll interno y ajuste de layout para el sidebar en desktop y mobile.
- [ ] **Fase 11: Refactorización y Deuda Técnica (Sugerencias de la revisión)**
    - [ ] 11.1. **Optimización de Borrado en Cascada:** Refactorizar `installmentService` y `loanService` para usar una única consulta SQL en lugar de bucles para el borrado.
    - [ ] 11.2. **Centralizar Lógica de Unión de Datos:** Mover la lógica de combinación de datos (ej. añadir `counterpartyName` a los préstamos) del frontend al backend.
    - [ ] 11.3. **Eliminar Placeholders:** Reemplazar valores hardcodeados (como el `categoryId` en transferencias) por configuraciones o selecciones dinámicas.