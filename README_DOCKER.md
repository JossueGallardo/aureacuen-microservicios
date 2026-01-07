# ?? Despliegue con Docker - Railway

Si prefieres usar Docker (más profesional y portable), sigue estos pasos:

---

## ? Ventajas de usar Docker

- ? Mismo entorno en desarrollo y producción
- ? Más fácil de escalar
- ? Más control sobre dependencias
- ? Railway lo detecta automáticamente

---

## ?? PASO 1: Verificar que tienes los Dockerfiles

Ya tienes los Dockerfiles creados en cada servicio:

```
ApiGateway/Dockerfile
CatalogosService/Dockerfile
HabitacionesService/Dockerfile
ReservasService/Dockerfile
UsuariosPagosService/Dockerfile
```

---

## ?? PASO 2: Probar localmente con Docker Compose (OPCIONAL)

### 2.1 Instalar Docker Desktop

Si no lo tienes: https://www.docker.com/products/docker-desktop

### 2.2 Ejecutar todo el sistema

```bash
cd "D:\Jossue\Desktop\RETO 3\BACK\V1\Microservicios"

# Construir y levantar todos los servicios
docker-compose up --build

# En otra terminal, ver los logs
docker-compose logs -f api-gateway
```

### 2.3 Probar

```
http://localhost:8080/swagger
```

### 2.4 Detener

```bash
docker-compose down
```

---

## ?? PASO 3: Desplegar en Railway con Docker

### 3.1 Subir a GitHub (igual que antes)

```bash
git init
git add .
git commit -m "Docker setup complete"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/hotel-microservices.git
git push -u origin main
```

### 3.2 Crear proyecto en Railway

1. Ve a https://railway.app
2. **New Project** ? **Deploy from GitHub repo**
3. Selecciona tu repositorio

### 3.3 Railway detecta Docker automáticamente

Railway escaneará el repositorio y encontrará los Dockerfiles.

### 3.4 Crear servicios (uno por uno)

**Para ApiGateway:**
1. **New** ? **GitHub Repo** ? Selecciona tu repo
2. **Settings** ? **Root Directory**: `ApiGateway`
3. Railway detectará `ApiGateway/Dockerfile` automáticamente
4. **Deploy**

**Repite para los otros 4 servicios:**
- `CatalogosService`
- `HabitacionesService`
- `ReservasService`
- `UsuariosPagosService`

### 3.5 Agregar PostgreSQL

1. **New** ? **Database** ? **PostgreSQL**

---

## ?? PASO 4: Configurar Variables de Entorno

### Para TODOS los servicios (excepto ApiGateway)

```env
ASPNETCORE_ENVIRONMENT=Production
DATABASE_URL=${{Postgres.DATABASE_URL}}
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

### Para ApiGateway

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=${{CatalogosService.RAILWAY_PUBLIC_DOMAIN}}
HABITACIONES_SERVICE_URL=${{HabitacionesService.RAILWAY_PUBLIC_DOMAIN}}
RESERVAS_SERVICE_URL=${{ReservasService.RAILWAY_PUBLIC_DOMAIN}}
USUARIOS_PAGOS_SERVICE_URL=${{UsuariosPagosService.RAILWAY_PUBLIC_DOMAIN}}
```

> ?? Railway tiene variables internas como `${{ServiceName.RAILWAY_PUBLIC_DOMAIN}}` que se resuelven automáticamente

---

## ?? PASO 5: Generar Dominios Públicos

Para cada servicio:

1. Click en el servicio
2. **Settings** ? **Networking**
3. **Generate Domain**

---

## ? Ventajas de Docker en Railway

1. **Build más rápido** - Railway cachea las capas de Docker
2. **Reproducible** - Mismo entorno siempre
3. **Multi-stage builds** - Imágenes más pequeñas
4. **Fácil de escalar** - Railway puede escalar contenedores

---

## ?? Actualizar el Código

Cada vez que hagas cambios:

```bash
git add .
git commit -m "Descripción de cambios"
git push
```

Railway detectará el push y redesplegará automáticamente.

---

## ?? Comparación: Docker vs Sin Docker

| Aspecto | Sin Docker | Con Docker |
|---------|-----------|------------|
| **Complejidad** | ?? Más simple | ??? Medio |
| **Velocidad de deploy** | ? Rápido | ?? Muy rápido |
| **Portabilidad** | ?? Limitada | ????? Total |
| **Reproducibilidad** | ?? Media | ????? Perfecta |
| **Escalabilidad** | ??? Buena | ????? Excelente |
| **Debug local** | ??? Fácil | ?? Requiere Docker |

---

## ?? Recomendación

- **Para aprender/prototipar**: Sin Docker
- **Para producción real**: Con Docker

---

## ?? Troubleshooting Docker

### Error: "Cannot connect to Docker daemon"

```bash
# Asegúrate de que Docker Desktop esté corriendo
```

### Error: "Build failed"

```bash
# Limpia y reconstruye
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

### Error: "Port already in use"

```bash
# Detén los servicios locales primero
# O cambia los puertos en docker-compose.yml
```

---

## ?? Checklist Docker

- [ ] Docker Desktop instalado
- [ ] Dockerfiles verificados
- [ ] docker-compose.yml probado localmente
- [ ] Código en GitHub
- [ ] Servicios creados en Railway (con Dockerfile detection)
- [ ] PostgreSQL agregado
- [ ] Variables de entorno configuradas
- [ ] Dominios públicos generados
- [ ] Swagger accesible

---

¡Listo! Tu arquitectura de microservicios está dockerizada y lista para producción. ??
