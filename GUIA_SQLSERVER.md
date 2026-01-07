# ? GUÍA ACTUALIZADA - SQL SERVER EN SOMEE.COM

## ? CAMBIOS IMPORTANTES

Tu proyecto ahora está configurado para usar:
- ? **SQL Server en Somee.com** (tu base de datos existente)
- ? **NO necesitas PostgreSQL**
- ? **NO necesitas crear base de datos nueva**
- ? La connection string ya está en el código

---

## ??? CONFIGURACIÓN DE BASE DE DATOS

### Tu Base de Datos SQL Server:

```
Server:   db31651.public.databaseasp.net
Port:     1433
Database: db31651
Usuario:  db31651
Password: prueba2020d
```

**Connection String (ya configurada):**
```
Server=db31651.public.databaseasp.net;Database=db31651;User Id=db31651;Password=prueba2020d;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;
```

---

## ?? PASOS PARA PUBLICAR (ACTUALIZADOS)

### PASO 1: Subir a GitHub (igual que antes)

```powershell
cd "D:\Jossue\Desktop\RETO 3\BACK\V1\Microservicios"

# Crea el repositorio en GitHub primero: https://github.com/new

.\init-github.ps1 -RepoUrl "https://github.com/TU_USUARIO/hotel-microservices.git"
```

---

### PASO 2: Configurar Railway (igual que antes)

1. Ve a https://railway.app
2. New Project ? Deploy from GitHub repo
3. Selecciona tu repositorio
4. Crea **5 servicios** (uno por carpeta):
   - `ApiGateway`
   - `CatalogosService`
   - `HabitacionesService`
   - `ReservasService`
   - `UsuariosPagosService`

?? **NO agregues PostgreSQL** - ya tienes SQL Server

---

### PASO 3: Generar URLs públicas (igual que antes)

Para cada servicio:
1. Settings ? Networking ? Generate Domain
2. Copia las URLs generadas

---

### PASO 4: Configurar Variables (SIMPLIFICADO)

### Para CatalogosService:

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

### Para HabitacionesService:

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

### Para ReservasService:

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

### Para UsuariosPagosService:

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
RESERVAS_SERVICE_URL=<url_de_reservas_service>
```

### Para ApiGateway:

```env
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=<url_de_catalogos_service>
HABITACIONES_SERVICE_URL=<url_de_habitaciones_service>
RESERVAS_SERVICE_URL=<url_de_reservas_service>
USUARIOS_PAGOS_SERVICE_URL=<url_de_usuarios_pagos_service>
```

---

## ? VENTAJAS DE TU CONFIGURACIÓN

1. ? **Más simple** - No necesitas configurar base de datos
2. ? **Datos existentes** - Tu BD ya tiene datos funcionando
3. ? **Sin migración** - No necesitas mover datos
4. ? **Menos variables** - No necesitas `DATABASE_URL`
5. ? **Compartida** - Todos los microservicios usan la misma BD

---

## ?? VERIFICACIÓN

Para verificar que todo funciona:

### 1. Probar conexión SQL Server desde Railway

En los logs de cualquier servicio deberías ver:
```
Connected to SQL Server: db31651.public.databaseasp.net
```

### 2. Probar endpoint

```
https://tu-apigateway.up.railway.app/api/catalogos/ciudades
```

Deberías ver las ciudades que ya tienes en tu base de datos.

---

## ?? CONSIDERACIONES IMPORTANTES

### Firewall de Somee.com

Somee.com **permite conexiones desde cualquier IP** por defecto, así que Railway podrá conectarse sin problemas.

### Límites de Somee.com

Verifica los límites de tu plan en Somee.com:
- Conexiones simultáneas
- Ancho de banda
- Espacio en disco

Si tienes el plan gratuito de Somee.com, puede tener restricciones.

### Latencia

Como Railway está en USA/Europa y Somee.com también, la latencia debería ser aceptable (50-100ms).

---

## ?? CHECKLIST ACTUALIZADO

- [ ] Código subido a GitHub
- [ ] 5 servicios creados en Railway
- [ ] ? ~~PostgreSQL agregado~~ (NO necesario)
- [ ] Variables configuradas (SIN DATABASE_URL)
- [ ] URLs públicas generadas
- [ ] ApiGateway con URLs actualizadas
- [ ] Swagger funcionando
- [ ] Endpoints retornan datos de SQL Server

---

## ?? TROUBLESHOOTING SQL SERVER

### "Cannot connect to SQL Server"

1. Verifica que Somee.com esté activo
2. Prueba la conexión desde SSMS local
3. Revisa los logs de Railway

### "Login failed for user 'db31651'"

- Verifica usuario y contraseña en `DatabaseConfig.cs`
- Asegúrate de que la cuenta de Somee.com esté activa

### "Network-related error"

- Verifica que el servidor `db31651.public.databaseasp.net` sea accesible
- Puede ser un problema temporal de Somee.com

---

## ?? TIPS

1. **Backup tu BD** - Haz backup regular de tu SQL Server en Somee.com
2. **Monitorea conexiones** - Revisa el panel de Somee.com
3. **Usa connection pooling** - Ya está habilitado con `MultipleActiveResultSets=True`
4. **Logs** - Railway te mostrará errores de SQL Server en los logs

---

## ?? ¡LISTO!

Tu configuración es **más simple** porque no necesitas:
- ? Crear PostgreSQL
- ? Migrar datos
- ? Configurar `DATABASE_URL`
- ? Cambiar connection strings

Todo funciona con tu SQL Server existente en Somee.com.

---

## ?? SOPORTE ADICIONAL

Si tienes problemas con:
- **Somee.com**: https://somee.com/support
- **Railway**: https://railway.app/help
- **SQL Server**: Revisa los logs de Railway

---

? **¡Tu arquitectura de microservicios compartiendo una BD SQL Server!** ?
