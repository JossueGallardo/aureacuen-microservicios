# ? CHECKLIST DE DESPLIEGUE - Railway

Marca cada paso a medida que lo completas.

---

## ?? FASE 1: PREPARACIÓN LOCAL

- [ ] Tengo .NET 8 SDK instalado
- [ ] Tengo Git instalado
- [ ] Tengo cuenta de GitHub
- [ ] He revisado que mi código compila localmente (`dotnet build`)
- [ ] He creado el repositorio en GitHub (https://github.com/new)
- [ ] Copié la URL del repositorio

---

## ?? FASE 2: SUBIR A GITHUB

- [ ] Abrí PowerShell en la carpeta del proyecto
- [ ] Ejecuté: `.\init-github.ps1 -RepoUrl "TU_URL_AQUI"`
- [ ] El código se subió correctamente a GitHub
- [ ] Verifiqué el repositorio en GitHub (está todo el código)

---

## ?? FASE 3: CONFIGURAR RAILWAY

- [ ] Creé cuenta en Railway.app
- [ ] Me autentiqué con GitHub
- [ ] Creé un nuevo proyecto
- [ ] Seleccioné "Deploy from GitHub repo"
- [ ] Elegí mi repositorio `hotel-microservices`

---

## ?? FASE 4: CREAR SERVICIOS (5 en total)

### ApiGateway
- [ ] New ? GitHub Repo ? Mi repositorio
- [ ] Settings ? Root Directory ? `ApiGateway`
- [ ] Esperé a que se despliegue
- [ ] Settings ? Networking ? Generate Domain
- [ ] Copié la URL: `https://____________________________`

### CatalogosService
- [ ] New ? GitHub Repo ? Mi repositorio
- [ ] Settings ? Root Directory ? `CatalogosService`
- [ ] Esperé a que se despliegue
- [ ] Settings ? Networking ? Generate Domain
- [ ] Copié la URL: `https://____________________________`

### HabitacionesService
- [ ] New ? GitHub Repo ? Mi repositorio
- [ ] Settings ? Root Directory ? `HabitacionesService`
- [ ] Esperé a que se despliegue
- [ ] Settings ? Networking ? Generate Domain
- [ ] Copié la URL: `https://____________________________`

### ReservasService
- [ ] New ? GitHub Repo ? Mi repositorio
- [ ] Settings ? Root Directory ? `ReservasService`
- [ ] Esperé a que se despliegue
- [ ] Settings ? Networking ? Generate Domain
- [ ] Copié la URL: `https://____________________________`

### UsuariosPagosService
- [ ] New ? GitHub Repo ? Mi repositorio
- [ ] Settings ? Root Directory ? `UsuariosPagosService`
- [ ] Esperé a que se despliegue
- [ ] Settings ? Networking ? Generate Domain
- [ ] Copié la URL: `https://____________________________`

---

## ?? FASE 5: BASE DE DATOS

- [ ] New ? Database ? PostgreSQL
- [ ] Esperé a que se cree
- [ ] PostgreSQL ? Variables ? Copié `DATABASE_URL`
- [ ] DATABASE_URL: `________________________________________________`

---

## ?? FASE 6: VARIABLES DE ENTORNO

### Para CatalogosService
- [ ] Variables ? Add Variable
- [ ] `ASPNETCORE_ENVIRONMENT` = `Production`
- [ ] `DATABASE_URL` = (pegar valor copiado)
- [ ] `JWT_SECRET_KEY` = `HotelMicroservicesSecretKey2024!@#$%^&*()_+`
- [ ] `RABBITMQ_URL` = (dejar vacío)

### Para HabitacionesService
- [ ] Variables ? Add Variable
- [ ] `ASPNETCORE_ENVIRONMENT` = `Production`
- [ ] `DATABASE_URL` = (pegar valor copiado)
- [ ] `JWT_SECRET_KEY` = `HotelMicroservicesSecretKey2024!@#$%^&*()_+`
- [ ] `RABBITMQ_URL` = (dejar vacío)

### Para ReservasService
- [ ] Variables ? Add Variable
- [ ] `ASPNETCORE_ENVIRONMENT` = `Production`
- [ ] `DATABASE_URL` = (pegar valor copiado)
- [ ] `JWT_SECRET_KEY` = `HotelMicroservicesSecretKey2024!@#$%^&*()_+`
- [ ] `RABBITMQ_URL` = (dejar vacío)

### Para UsuariosPagosService
- [ ] Variables ? Add Variable
- [ ] `ASPNETCORE_ENVIRONMENT` = `Production`
- [ ] `DATABASE_URL` = (pegar valor copiado)
- [ ] `JWT_SECRET_KEY` = `HotelMicroservicesSecretKey2024!@#$%^&*()_+`
- [ ] `RABBITMQ_URL` = (dejar vacío)
- [ ] `RESERVAS_SERVICE_URL` = (URL de ReservasService copiada arriba)

### Para ApiGateway
- [ ] Variables ? Add Variable
- [ ] `ASPNETCORE_ENVIRONMENT` = `Production`
- [ ] `JWT_SECRET_KEY` = `HotelMicroservicesSecretKey2024!@#$%^&*()_+`
- [ ] `CATALOGOS_SERVICE_URL` = (URL de CatalogosService)
- [ ] `HABITACIONES_SERVICE_URL` = (URL de HabitacionesService)
- [ ] `RESERVAS_SERVICE_URL` = (URL de ReservasService)
- [ ] `USUARIOS_PAGOS_SERVICE_URL` = (URL de UsuariosPagosService)

---

## ?? FASE 7: REDESPLIEGUE

- [ ] Voy a ApiGateway
- [ ] Deployments ? Click en el último deploy
- [ ] Click en "..." ? Redeploy
- [ ] Esperé a que termine

---

## ?? FASE 8: VERIFICACIÓN

- [ ] Abrí: `https://mi-apigateway.up.railway.app/swagger`
- [ ] Swagger UI se muestra correctamente
- [ ] Los endpoints están disponibles
- [ ] Probé: `GET /api/catalogos/ciudades` (debe retornar datos o error de BD)

---

## ?? FASE 9: CONECTAR CON ANGULAR

- [ ] Actualicé `environment.prod.ts`:
  ```typescript
  export const environment = {
    production: true,
    apiUrl: 'https://mi-apigateway.up.railway.app'
  };
  ```
- [ ] Actualicé mis servicios en Angular
- [ ] Probé la conexión desde Angular
- [ ] ¡Funciona! ??

---

## ?? FASE 10: MIGRAR BASE DE DATOS (IMPORTANTE)

?? **Tu código usa SQL Server, pero Railway usa PostgreSQL**

### Opción A: Migrar a PostgreSQL (Recomendada)

- [ ] Instalar Npgsql: `dotnet add package Npgsql`
- [ ] Actualizar connection strings en Shared.Data
- [ ] Adaptar consultas SQL si es necesario
- [ ] Redesplegar servicios

### Opción B: Usar Azure SQL Server

- [ ] Crear Azure SQL Database
- [ ] Copiar connection string
- [ ] Actualizar variable `DATABASE_URL` en cada servicio
- [ ] Redesplegar servicios

---

## ?? ESTADO FINAL

- [ ] ? Todos los servicios están "deployed" (verde)
- [ ] ? ApiGateway responde correctamente
- [ ] ? Swagger UI funciona
- [ ] ? Base de datos conectada
- [ ] ? Angular conectado
- [ ] ? URLs documentadas

---

## ?? NOTAS

**URL del ApiGateway (principal):**
```
https://_______________________________________________
```

**URLs de servicios individuales:**
```
CatalogosService:     https://_______________________________________________
HabitacionesService:  https://_______________________________________________
ReservasService:      https://_______________________________________________
UsuariosPagosService: https://_______________________________________________
```

**DATABASE_URL:**
```
_______________________________________________
```

---

## ?? ¡DESPLIEGUE COMPLETADO!

Cuando todos los checkboxes estén marcados, tu sistema de microservicios estará 100% operativo en Railway.

**Tiempo estimado:** 20-30 minutos

**Costo:** $0 USD/mes (con crédito gratuito de Railway)

---

## ?? SI ALGO FALLA

1. **Revisar logs**: Railway ? Servicio ? Deployments ? View Logs
2. **Verificar variables**: Railway ? Servicio ? Variables
3. **Comprobar dominios**: Railway ? Servicio ? Settings ? Networking
4. **Leer documentación**: `README_DEPLOYMENT.md`

---

## ?? RECURSOS

- Railway Docs: https://docs.railway.app
- .NET 8 Docs: https://docs.microsoft.com/dotnet
- PostgreSQL Docs: https://www.postgresql.org/docs/

---

? **¡Buena suerte con tu despliegue!** ?
