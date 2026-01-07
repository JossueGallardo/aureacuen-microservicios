# ?? GUÍA RÁPIDA - PUBLICAR EN 5 MINUTOS

## ? Opción A: SIN DOCKER (Más Simple)

### 1?? Preparar GitHub

```powershell
# 1. Abre PowerShell en esta carpeta
cd "D:\Jossue\Desktop\RETO 3\BACK\V1\Microservicios"

# 2. Crea un repositorio en GitHub:
#    https://github.com/new
#    Nombre: hotel-microservices
#    NO marques ninguna opción

# 3. Ejecuta el script (reemplaza con TU URL):
.\init-github.ps1 -RepoUrl "https://github.com/TU_USUARIO/hotel-microservices.git"
```

### 2?? Configurar Railway

1. **Ir a Railway**: https://railway.app
2. **Login con GitHub**
3. **New Project** ? **Deploy from GitHub repo**
4. **Seleccionar** tu repositorio `hotel-microservices`

### 3?? Crear los 5 Servicios

**Por cada servicio, hacer:**

1. Click **"New"** ? **"GitHub Repo"**
2. Seleccionar tu repositorio
3. En **Settings** ? **Root Directory** ? escribir:
   - `ApiGateway`
   - `CatalogosService`
   - `HabitacionesService`
   - `ReservasService`
   - `UsuariosPagosService`

### 4?? Agregar Base de Datos

1. Click **"New"** ? **"Database"** ? **"PostgreSQL"**
2. Esperar a que se cree
3. Click en PostgreSQL ? **Variables** ? Copiar `DATABASE_URL`

### 5?? Configurar Variables

**En CADA servicio** (excepto ApiGateway):

```env
ASPNETCORE_ENVIRONMENT=Production
DATABASE_URL=<pegar_aquí_el_DATABASE_URL>
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
```

**En ApiGateway** (después de obtener las URLs):

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=https://catalogos-production.up.railway.app
HABITACIONES_SERVICE_URL=https://habitaciones-production.up.railway.app
RESERVAS_SERVICE_URL=https://reservas-production.up.railway.app
USUARIOS_PAGOS_SERVICE_URL=https://usuarios-pagos-production.up.railway.app
```

### 6?? Generar URLs Públicas

**Para CADA servicio:**

1. Click en el servicio
2. **Settings** ? **Networking** ? **Generate Domain**
3. Copiar la URL generada

### 7?? Actualizar ApiGateway

1. Ir a ApiGateway ? **Variables**
2. Actualizar las URLs con las URLs reales
3. **Deployments** ? Click en el último ? **Redeploy**

### ? LISTO

```
https://tu-apigateway.up.railway.app/swagger
```

---

## ? Opción B: CON DOCKER (Más Profesional)

### 1?? Instalar Docker Desktop

https://www.docker.com/products/docker-desktop

### 2?? Probar Localmente

```powershell
# Levantar todos los servicios
docker-compose up --build

# Probar en navegador
http://localhost:8080/swagger

# Detener
docker-compose down
```

### 3?? Subir a GitHub

```powershell
.\init-github.ps1 -RepoUrl "https://github.com/TU_USUARIO/hotel-microservices.git"
```

### 4?? Railway (igual que Opción A)

Railway detectará los Dockerfiles automáticamente.

Sigue los pasos 2-7 de la Opción A.

---

## ?? Conectar con Angular

En tu `src/environments/environment.prod.ts`:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://tu-apigateway.up.railway.app'
};
```

En tus servicios:

```typescript
constructor(private http: HttpClient) {}

getCiudades() {
  return this.http.get(`${environment.apiUrl}/api/catalogos/ciudades`);
}

buscarHabitaciones(filtros: any) {
  return this.http.get(`${environment.apiUrl}/api/integracion/habitaciones`, {
    params: filtros
  });
}
```

---

## ?? Costos

- **Railway**: $5 USD/mes GRATIS
- **Total**: $0 USD/mes con crédito gratuito

---

## ?? Problemas Comunes

### "Error al compilar"

```powershell
# Limpiar y reconstruir
dotnet clean
dotnet build --configuration Release
```

### "No se puede conectar a GitHub"

```powershell
# Configurar Git
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Generar token de acceso en GitHub:
# Settings ? Developer settings ? Personal access tokens ? Generate new token
```

### "Railway no detecta el proyecto"

1. Verificar que el código esté en GitHub
2. Verificar que `railway.json` exista en cada carpeta de servicio
3. Verificar el **Root Directory** en Railway Settings

---

## ?? Documentación Completa

- **Sin Docker**: Lee `README_DEPLOYMENT.md`
- **Con Docker**: Lee `README_DOCKER.md`

---

## ? Checklist Final

- [ ] Código en GitHub
- [ ] 5 servicios en Railway
- [ ] PostgreSQL agregado
- [ ] Variables configuradas
- [ ] URLs públicas generadas
- [ ] ApiGateway redesplegado
- [ ] Swagger funcionando
- [ ] Angular conectado

---

## ?? ¡Eso es todo!

Tu sistema de microservicios está publicado y listo para usar.

**Tiempo estimado**: 15-20 minutos

**URL principal**: `https://tu-apigateway.up.railway.app`
