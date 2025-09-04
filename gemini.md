# Notas de Operación del Agente Gemini

## Ejecución de Comandos en Subdirectorios

Cuando se necesita ejecutar comandos dentro de un subdirectorio (ej. `FinanzasBackend`, `FinanzasFrontend`), la herramienta `run_shell_command` puede no reconocer el `directory` directamente.

**Solución:** Utilizar `cd <nombre_del_subdirectorio> && <comando>` para cambiar al directorio y ejecutar el comando en una sola instrucción.

**Ejemplo:**
`cd FinanzasBackend && npm install multer`

## Documentación del Proyecto

Para una comprensión completa del proyecto y su contexto, se recomienda encarecidamente revisar los siguientes documentos:

*   `DATABASE.md`: Detalla la arquitectura y el modelo de datos de la base de datos.
*   `DOCUMENTACION_COMPLETA.md`: Proporciona una visión general completa del sistema, incluyendo la arquitectura general, el backend, el frontend, el flujo de datos y la lógica de negocio.