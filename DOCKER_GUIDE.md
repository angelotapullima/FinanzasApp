# Guía de Docker para el Proyecto de Finanzas

Este documento centraliza toda la configuración, comandos y conceptos clave para levantar y gestionar el entorno de desarrollo completo (Frontend, Backend, Base de Datos) usando Docker.

## 🗂️ 1. Estructura de Archivos de Docker

Estos son los archivos que hemos añadido o modificado para dockerizar la aplicación.

1.  **`.env`** (en la raíz del proyecto): Archivo central para gestionar todas las variables de entorno y secretos.
2.  **`docker-compose.yml`** (en la raíz del proyecto): El orquestador que define y conecta todos nuestros servicios.
3.  **`FinanzasBackend/Dockerfile`**: Las instrucciones para construir la imagen del servicio de Backend (Node.js).
4.  **`FinanzasFrontend/Dockerfile`**: Las instrucciones para construir la imagen del servicio de Frontend (Vue.js + Nginx).
5.  **`FinanzasFrontend/nginx.conf`**: El archivo de configuración para el servidor Nginx que sirve el frontend.

---

## 🚀 2. Comandos Principales de Docker

Estos son los comandos que usarás con más frecuencia. Ejecútalos desde la terminal en la raíz de tu proyecto.

| Comando | Descripción |
| :--- | :--- |
| `docker-compose build` | Construye (o reconstruye) las imágenes de tus servicios (`frontend` y `backend`) según lo definido en sus `Dockerfile`. Úsalo cuando hagas cambios en un `Dockerfile` o después de un `npm run build` local en el frontend. |
| `docker-compose up -d` | Inicia todos los servicios en segundo plano (`-d` significa "detached"). Si las imágenes no existen, las construye primero. |
| `docker-compose down` | Detiene y elimina los contenedores definidos en `docker-compose.yml`. No borra los volúmenes de datos. |
| `docker-compose ps` | Muestra el estado de los contenedores de tu proyecto (corriendo, detenido, etc.). |
| `docker-compose logs -f [servicio]` | Muestra los logs (registros) de un servicio en tiempo real. Esencial para depurar. Ej: `docker-compose logs -f backend`. |
| `docker-compose exec [servicio] [comando]` | Ejecuta un comando dentro de un contenedor que ya está en ejecución. Ej: `docker-compose exec db psql -U gemini`. |
| `docker volume ls` | Lista todos los volúmenes de Docker en tu sistema. |
| `docker volume rm [nombre_volumen]` | **(¡Peligroso!)** Elimina un volumen permanentemente. Ej: `docker volume rm addemdum_pgdata`. |

---

## 📋 3. Flujo de Trabajo Típico

### Primera Vez / Instalación Limpia

1.  **Construir el Frontend localmente:**
    *   `cd FinanzasFrontend`
    *   `npm install`
    *   `npm run build` (Esto creará la carpeta `dist`)
    *   `cd ..` (Vuelve a la raíz del proyecto)
2.  **Construir las imágenes de Docker:** `docker-compose build`
3.  **Levantar los servicios:** `docker-compose up -d`
4.  **Inicialización automática de la base de datos:**
    La base de datos se inicializará automáticamente con el esquema (`create_db.sql`) y los datos de prueba (`populate_test_data.sql`) la primera vez que el contenedor `db` se inicie con un volumen vacío. No se requiere ninguna acción manual aquí.
5.  **Acceder a la app:** Abre `http://localhost:8080` en tu navegador.

### Desarrollo Diario

1.  **Iniciar todo:** `docker-compose up -d`
2.  **Para cambios en el Backend:**
    *   Los cambios en el código del backend se reflejarán automáticamente gracias al volumen montado.
    *   Si haces cambios en `package.json` (añadir/quitar dependencias), necesitarás reconstruir la imagen del backend: `docker-compose build backend`.
3.  **Para cambios en el Frontend:**
    *   Los cambios en el código fuente se reflejarán automáticamente en el navegador gracias al hot-reloading del servidor de desarrollo de Vite.
    *   Si haces cambios en `package.json` (añadir/quitar dependencias), necesitarás reconstruir la imagen del frontend: `docker-compose build frontend`.
4.  **Ver logs si algo falla:** `docker-compose logs -f backend` o `docker-compose logs -f frontend`
5.  **Cuando termines de trabajar:** `docker-compose down`

---

## 🧠 4. Conceptos Clave a Recordar

#### a. Inicialización de la Base de Datos
- El usuario y la contraseña de la base de datos (`POSTGRES_USER`, `POSTGRES_PASSWORD`) **solo se usan la primera vez** que el contenedor `db` se inicia con un volumen de datos vacío.
- Cambiar estas variables en el `.env` **no tendrá efecto** en una base de datos ya creada.

#### b. Cómo Cambiar la Contraseña de la BD (si ya fue creada)
- **Opción Segura (sin perder datos):** Conéctate a la base de datos y ejecuta el comando SQL: `ALTER USER gemini WITH PASSWORD 'nueva_contraseña';`. Luego, actualiza la variable `POSTGRES_PASSWORD` en tu archivo `.env`.
- **Opción Drástica (borra todos los datos):** Ejecuta `docker-compose down`, luego `docker volume rm addemdum_pgdata`, actualiza el `.env` y finalmente `docker-compose up -d`.

#### c. Persistencia de Datos
- Los datos de tu base de datos PostgreSQL se guardan en un **volumen** de Docker (`pgdata`).
- Este volumen sobrevive aunque los contenedores se detengan o eliminen (`docker-compose down`). Por eso tus datos están a salvo.

#### d. Conexión entre Contenedores
- Los servicios se comunican entre sí usando sus nombres definidos en `docker-compose.yml`.
- Por ejemplo, el `backend` se conecta a la base de datos usando `db` como el nombre del host: `postgresql://gemini:supersecret@db:5432/finanzas_db`.

#### e. Conexión a la Base de Datos desde tu PC
- Para conectarte con una herramienta gráfica (DBeaver, DataGrip, etc.), usa las siguientes credenciales, gracias al mapeo de puertos (`ports: - "5432:5432"`):
    - **Host:** `localhost`
    - **Puerto:** `5432`
    - **Usuario:** `gemini` (o lo que tengas en `.env`)
    - **Contraseña:** `supersecret` (o lo que tengas en `.env`)
    - **Base de datos:** `finanzas_db` (o lo que tengas en `.env`)

#### f. Health Checks
- Los health checks permiten a Docker verificar si un contenedor está realmente "sano" y listo para operar, no solo si está corriendo.
- Son cruciales para la orquestación y el despliegue, ya que otros servicios pueden esperar a que un servicio dependiente esté "sano" antes de iniciar.
- Se definen en `docker-compose.yml` para cada servicio:
    - **`db` (PostgreSQL):** Verifica si la base de datos está lista para aceptar conexiones.
    - **`backend` (API Node.js):** Asume un endpoint `/health` que devuelve 200 OK.
    - **`frontend` (Nginx proxying Vite dev server):** Verifica si Nginx está respondiendo en el puerto 80.

#### f. Health Checks
- Los health checks permiten a Docker verificar si un contenedor está realmente "sano" y listo para operar, no solo si está corriendo.
- Son cruciales para la orquestación y el despliegue, ya que otros servicios pueden esperar a que un servicio dependiente esté "sano" antes de iniciar.
- Se definen en `docker-compose.yml` para cada servicio:
    - **`db` (PostgreSQL):** Verifica si la base de datos está lista para aceptar conexiones.
    - **`backend` (API Node.js):** Asume un endpoint `/health` que devuelve 200 OK.
    - **`frontend` (Nginx proxying Vite dev server):** Verifica si Nginx está respondiendo en el puerto 80.

#### f. Health Checks
- Los health checks permiten a Docker verificar si un contenedor está realmente "sano" y listo para operar, no solo si está corriendo.
- Son cruciales para la orquestación y el despliegue, ya que otros servicios pueden esperar a que un servicio dependiente esté "sano" antes de iniciar.
- Se definen en `docker-compose.yml` para cada servicio:
    - **`db` (PostgreSQL):** Verifica si la base de datos está lista para aceptar conexiones.
    - **`backend` (API Node.js):** Asume un endpoint `/health` que devuelve 200 OK.
    - **`frontend` (Nginx proxying Vite dev server):** Verifica si Nginx está respondiendo en el puerto 80.

---

## 📜 5. Contenido de los Archivos de Configuración

<details>
<summary>Ver contenido de <code>.env</code></summary>

```
# PostgreSQL DB Configuration
POSTGRES_USER=gemini
POSTGRES_PASSWORD=supersecret
POSTGRES_DB=finanzas_db

# Backend Configuration
DATABASE_URL="postgresql://gemini:supersecret@db:5432/finanzas_db?schema=public"
API_PORT=3000

# Frontend Configuration
FRONTEND_PORT=8080
```
</details>

<details>
<summary>Ver contenido de <code>docker-compose.yml</code></summary>

```yaml
services:
  db:
    image: postgres:15-alpine
    container_name: finanzas-db
    restart: always
    env_file:
      - .env
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    container_name: finanzas-backend
    build:
      context: ./FinanzasBackend
      dockerfile: Dockerfile
    restart: always
    env_file:
      - .env
    ports:
      - "${API_PORT}:${API_PORT}"
    depends_on:
      - db
    volumes:
      - ./FinanzasBackend:/usr/src/app # Para desarrollo con hot-reload
      - /usr/src/app/node_modules # No sobreescribir node_modules
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"] # Asumiendo un endpoint /health
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s

  frontend:
    container_name: finanzas-frontend
    build:
      context: ./FinanzasFrontend
      dockerfile: Dockerfile
    restart: always
    ports:
      - "${FRONTEND_PORT}:80"
    depends_on:
      - backend
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s

volumes:
  pgdata:
```
</details>

<details>
<summary>Ver contenido de <code>FinanzasBackend/Dockerfile</code></summary>

```dockerfile
# Stage 1: Build the application
FROM node:22 AS build

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Create the production-ready image
FROM node:22-slim

WORKDIR /usr/src/app

# Copy only the built files and production node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "dist/index.js"]
```
</details>

<details>
<summary>Ver contenido de <code>FinanzasFrontend/Dockerfile</code></summary>

```dockerfile
FROM node:22

WORKDIR /app

COPY package*.json ./
RUN npm install

# Expose Vite's default dev server port
EXPOSE 5173

CMD ["npm", "run", "dev"] # This will be overridden by docker-compose for dev
```
</details>

<details>
<summary>Ver contenido de <code>FinanzasFrontend/nginx.conf</code></summary>

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://frontend:5173; # Proxy to Vite dev server
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Proxy API requests to the backend service (this remains the same)
    location /api {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
</details>

<details>
<summary>Ver contenido de <code>FinanzasFrontend/package.json</code></summary>

```json
{
  "name": "finanzas-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "pinia": "^2.x.x",
    "vue": "^3.x.x",
    "vue-i18n": "^9.x.x",
    "vue-router": "^4.x.x"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.x.x",
    "autoprefixer": "^10.x.x",
    "postcss": "^8.x.x",
    "tailwindcss": "^3.x.x",
    "typescript": "^5.x.x",
    "vite": "^5.x.x",
    "vue-tsc": "^2.0.0"
  }
}
```
</details>