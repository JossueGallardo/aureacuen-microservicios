# ?? Hotel Microservices - Sistema de Gestión Hotelera

## ?? Arquitectura del Proyecto

Este proyecto implementa una arquitectura de microservicios para un sistema de gestión hotelera.

### Servicios

1. **ApiGateway** (Puerto 8080) - Gateway principal usando YARP
2. **CatalogosService** (Puerto 5001) - Gestión de ciudades, hoteles, amenidades, tipos de habitación
3. **HabitacionesService** (Puerto 5002) - API GraphQL para habitaciones
4. **ReservasService** (Puerto 5003) - API gRPC para reservas
5. **UsuariosPagosService** (Porto 5004) - Gestión de usuarios y pagos

### Proyectos Compartidos

- **Shared.Data** - Repositorios y acceso a datos
- **Shared.DTOs** - Objetos de transferencia de datos
- **Shared.EventBus** - Bus de eventos con RabbitMQ

---

## ?? Despliegue en Railway.app

### Requisitos Previos

1. ? Cuenta de GitHub
2. ? Cuenta de Railway.app (https://railway.app)
3. ? .NET 8 SDK instalado localmente

---

## ?? PASO 1: Preparar el Repositorio de GitHub

### 1.1 Inicializar Git (si no está inicializado)

```bash
cd "D:\Jossue\Desktop\RETO 3\BACK\V1\Microservicios"
git init
git add .
git commit -m "Initial commit - Microservices architecture"
```

### 1.2 Crear repositorio en GitHub

1. Ve a https://github.com/new
2. Crea un nuevo repositorio (nombre sugerido: `hotel-microservices`)
3. **NO inicialices con README, .gitignore ni licencia** (ya los tienes)

### 1.3 Conectar y subir

```bash
git branch -M main
git remote add origin https://github.com/TU_USUARIO/hotel-microservices.git
git push -u origin main
```

---

## ?? PASO 2: Configurar Railway

### 2.1 Crear proyecto en Railway

1. Ve a https://railway.app
2. Click en **"New Project"**
3. Selecciona **"Deploy from GitHub repo"**
4. Autoriza Railway a acceder a tu GitHub
5. Selecciona el repositorio `hotel-microservices`

### 2.2 Agregar Base de Datos PostgreSQL

1. En el dashboard de Railway, click en **"New"**
2. Selecciona **"Database"** ? **"PostgreSQL"**
3. Espera a que se cree la base de datos
4. Click en PostgreSQL ? **"Variables"** ? Copia el valor de `DATABASE_URL`

---

## ?? PASO 3: Crear los 5 Servicios

Railway detectará automáticamente que es un monorepo. Debes crear un servicio por cada proyecto:

### 3.1 Crear ApiGateway

1. En el proyecto de Railway, click en **"New"**
2. Selecciona **"GitHub Repo"** ? Elige tu repositorio
3. En **"Settings"** ? **"Root Directory"** ? escribe: `ApiGateway`
4. En **"Deploy"** ? Espera a que compile

### 3.2 Crear CatalogosService

1. Click en **"New"** ? **"GitHub Repo"**
2. Selecciona tu repositorio de nuevo
3. En **"Settings"** ? **"Root Directory"** ? escribe: `CatalogosService`

### 3.3 Crear HabitacionesService

1. Click en **"New"** ? **"GitHub Repo"**
2. En **"Settings"** ? **"Root Directory"** ? escribe: `HabitacionesService`

### 3.4 Crear ReservasService

1. Click en **"New"** ? **"GitHub Repo"**
2. En **"Settings"** ? **"Root Directory"** ? escribe: `ReservasService`

### 3.5 Crear UsuariosPagosService

1. Click en **"New"** ? **"GitHub Repo"**
2. En **"Settings"** ? **"Root Directory"** ? escribe: `UsuariosPagosService`

---

## ?? PASO 4: Configurar Variables de Entorno

### 4.1 Para TODOS los servicios (excepto ApiGateway)

En cada servicio, ve a **"Variables"** y agrega:

```env
ASPNETCORE_ENVIRONMENT=Production
DATABASE_URL=<copia_el_valor_de_postgresql>
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

> ?? Dejar `RABBITMQ_URL` vacío usará el NullEventBus (sin RabbitMQ)

### 4.2 Para UsuariosPagosService (adicional)

Agregar también:

```env
RESERVAS_SERVICE_URL=https://reservas-service-production.up.railway.app
```

> ?? Deberás actualizar esta URL después de que ReservasService se despliegue

### 4.3 Para ApiGateway

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=https://catalogos-service-production.up.railway.app
HABITACIONES_SERVICE_URL=https://habitaciones-service-production.up.railway.app
RESERVAS_SERVICE_URL=https://reservas-service-production.up.railway.app
USUARIOS_PAGOS_SERVICE_URL=https://usuarios-pagos-service-production.up.railway.app
```

> ?? Actualiza estas URLs después de obtener las URLs públicas de cada servicio

---

## ?? PASO 5: Obtener URLs Públicas

### 5.1 Generar dominios públicos

Para cada servicio:

1. Click en el servicio
2. Ve a **"Settings"** ? **"Networking"**
3. Click en **"Generate Domain"**
4. Copia la URL generada (ejemplo: `https://apigateway-production.up.railway.app`)

### 5.2 Actualizar variables de ApiGateway

Vuelve a ApiGateway ? Variables ? Actualiza las URLs de los servicios con las URLs reales generadas.

### 5.3 Redesplegar ApiGateway

1. Ve a ApiGateway
2. Click en **"Deployments"**
3. Click en los 3 puntos del último deploy ? **"Redeploy"**

---

## ? PASO 6: Verificar el Despliegue

### 6.1 Probar ApiGateway

```
https://tu-apigateway.up.railway.app/swagger
```

Deberías ver el Swagger UI con todos los endpoints.

### 6.2 Endpoints disponibles

- **Catálogos**: `GET /api/catalogos/ciudades`
- **Habitaciones GraphQL**: `POST /graphql`
- **Integración RECA**: 
  - `GET /api/integracion/habitaciones`
  - `POST /api/integracion/disponibilidad`
  - `POST /api/integracion/reservas/confirmar`
  - `POST /api/integracion/facturas`

---

## ?? PASO 7: Conectar con Angular

En tu proyecto Angular, actualiza el archivo `environment.prod.ts`:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://tu-apigateway.up.railway.app',
  endpoints: {
    catalogos: '/api/catalogos',
    habitaciones: '/graphql',
    integracion: {
      habitaciones: '/api/integracion/habitaciones',
      disponibilidad: '/api/integracion/disponibilidad',
      reservas: '/api/integracion/reservas',
      facturas: '/api/integracion/facturas'
    }
  }
};
```

---

## ?? Troubleshooting

### Error: "No se puede conectar a la base de datos"

1. Verifica que `DATABASE_URL` esté configurada en todos los servicios
2. Asegúrate de que Railway PostgreSQL esté activo
3. Revisa los logs: click en servicio ? **"Deployments"** ? último deploy ? **"View Logs"**

### Error: "Service unavailable"

1. Espera 2-3 minutos (el servicio puede estar iniciando)
2. Verifica que el dominio público esté generado
3. Revisa los logs del servicio

### Error: "JWT validation failed"

1. Verifica que `JWT_SECRET_KEY` sea la **misma** en todos los servicios
2. El secreto debe tener al menos 32 caracteres

---

## ?? Costos Estimados

Railway ofrece **$5 USD de crédito mensual gratuito**.

**Estimación de uso:**
- 5 servicios pequeños (.NET) = ~$3-4 USD/mes
- PostgreSQL = Incluido en el crédito
- **Total: $0 USD/mes** (con crédito gratuito)

Si necesitas más recursos:
- Plan Hobby: $5 USD/mes
- Plan Pro: $20 USD/mes

---

## ?? Soporte

Si tienes problemas:

1. Revisa los logs en Railway
2. Verifica las variables de entorno
3. Asegúrate de que todos los servicios estén "deployed"

---

## ?? Checklist Final

- [ ] Código subido a GitHub
- [ ] 5 servicios creados en Railway
- [ ] PostgreSQL agregado y configurado
- [ ] Variables de entorno configuradas en todos los servicios
- [ ] Dominios públicos generados
- [ ] URLs actualizadas en ApiGateway
- [ ] ApiGateway redesplegado
- [ ] Swagger funcionando
- [ ] Frontend Angular actualizado con nueva URL

---

## ?? ¡Listo!

Tu sistema de microservicios está desplegado y listo para conectar con tu frontend Angular.

URL principal: `https://tu-apigateway.up.railway.app`
