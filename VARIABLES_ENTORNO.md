# ?? VARIABLES DE ENTORNO - RAILWAY

Este archivo contiene todas las variables que necesitas configurar en Railway.

---

## ?? VARIABLES GLOBALES (Mismas para todos)

Estas variables son **iguales** en todos los servicios:

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
```

> ?? **IMPORTANTE**: Cambia `JWT_SECRET_KEY` por un valor más seguro en producción.
> Genera uno aquí: https://randomkeygen.com/

---

## ??? SQL SERVER (Base de datos ya existente en Somee.com)

Tu base de datos **ya está funcionando** en SQL Server (Somee.com).

**NO necesitas crear PostgreSQL en Railway.**

La connection string ya está configurada en el código:

```bash
Server=db31651.public.databaseasp.net;Database=db31651;User Id=db31651;Password=prueba2020d;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;
```

> ? **Ventaja**: Todos los microservicios compartirán la misma base de datos SQL Server.

---

## ?? RABBITMQ (Opcional)

Si no usas RabbitMQ, déjalo vacío:

```bash
RABBITMQ_URL=
```

Si usas CloudAMQP (gratis):
```bash
RABBITMQ_URL=amqp://username:password@pelican.rmq.cloudamqp.com/vhost
```

---

## ?? CONFIGURACIÓN POR SERVICIO

### 1?? CatalogosService

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

> ?? **NOTA**: NO necesitas configurar `ConnectionStrings__DefaultConnection` porque ya está en el código.

---

### 2?? HabitacionesService

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

---

### 3?? ReservasService

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
```

---

### 4?? UsuariosPagosService

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
RABBITMQ_URL=
RESERVAS_SERVICE_URL=<url_de_reservas_service>
```

> ?? **Nota**: `RESERVAS_SERVICE_URL` debe ser la URL pública generada en Railway para ReservasService.

**Ejemplo:**
```bash
RESERVAS_SERVICE_URL=https://reservas-service-production.up.railway.app
```

---

### 5?? ApiGateway

```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=<url_de_catalogos_service>
HABITACIONES_SERVICE_URL=<url_de_habitaciones_service>
RESERVAS_SERVICE_URL=<url_de_reservas_service>
USUARIOS_PAGOS_SERVICE_URL=<url_de_usuarios_pagos_service>
```

**Ejemplo completo:**
```bash
ASPNETCORE_ENVIRONMENT=Production
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
CATALOGOS_SERVICE_URL=https://catalogos-service-production.up.railway.app
HABITACIONES_SERVICE_URL=https://habitaciones-service-production.up.railway.app
RESERVAS_SERVICE_URL=https://reservas-service-production.up.railway.app
USUARIOS_PAGOS_SERVICE_URL=https://usuarios-pagos-service-production.up.railway.app
```

---

## ?? VARIABLES INTERNAS DE RAILWAY

Railway también ofrece variables automáticas que puedes usar:

```bash
# URL pública del servicio
${{RAILWAY_PUBLIC_DOMAIN}}

# URL interna del servicio
${{RAILWAY_PRIVATE_DOMAIN}}

# Nombre del servicio
${{RAILWAY_SERVICE_NAME}}
```

### Ejemplo usando variables de Railway:

**En ApiGateway, en lugar de escribir las URLs manualmente:**

```bash
CATALOGOS_SERVICE_URL=https://${{CatalogosService.RAILWAY_PUBLIC_DOMAIN}}
HABITACIONES_SERVICE_URL=https://${{HabitacionesService.RAILWAY_PUBLIC_DOMAIN}}
RESERVAS_SERVICE_URL=https://${{ReservasService.RAILWAY_PUBLIC_DOMAIN}}
USUARIOS_PAGOS_SERVICE_URL=https://${{UsuariosPagosService.RAILWAY_PUBLIC_DOMAIN}}
```

> ?? **Ventaja**: Las URLs se actualizan automáticamente si cambias los dominios.

---

## ?? VARIABLES DE ENTORNO EN LOCAL (para desarrollo)

Si trabajas localmente, crea un archivo `appsettings.Development.json` en cada proyecto:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=db31651.public.databaseasp.net;Database=db31651;User Id=db31651;Password=prueba2020d;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;"
  },
  "Jwt": {
    "Key": "HotelMicroservicesSecretKey2024!@#$%^&*()_+",
    "Issuer": "HotelMicroservices",
    "Audience": "HotelMicroservicesClients"
  },
  "RabbitMQ": {
    "Host": ""
  }
}
```

> ?? **No subas** `appsettings.Development.json` a GitHub (ya está en `.gitignore`).

---

## ?? SEGURIDAD

### ?? NO EXPONGAS

- Contraseñas de base de datos
- JWT Secret Key
- API Keys
- Tokens de acceso

### ? BUENAS PRÁCTICAS

1. **Usa variables de entorno** en Railway (nunca en el código)
2. **Cambia el JWT Secret** en producción
3. **Usa HTTPS** siempre (Railway lo hace automático)
4. **Rotar secrets** cada cierto tiempo

> ?? **NOTA**: Tu connection string de SQL Server ya está en el código porque es externa (Somee.com). Esto es seguro porque Railway no expone tu código fuente públicamente.

---

## ?? TABLA RESUMEN

| Variable | CatalogosService | HabitacionesService | ReservasService | UsuariosPagosService | ApiGateway |
|----------|------------------|---------------------|-----------------|----------------------|------------|
| `ASPNETCORE_ENVIRONMENT` | ? | ? | ? | ? | ? |
| `JWT_SECRET_KEY` | ? | ? | ? | ? | ? |
| `RABBITMQ_URL` | ? | ? | ? | ? | ? |
| `RESERVAS_SERVICE_URL` | ? | ? | ? | ? | ? |
| `CATALOGOS_SERVICE_URL` | ? | ? | ? | ? | ? |
| `HABITACIONES_SERVICE_URL` | ? | ? | ? | ? | ? |
| `USUARIOS_PAGOS_SERVICE_URL` | ? | ? | ? | ? | ? |

> ?? **CAMBIO IMPORTANTE**: NO necesitas configurar `ConnectionStrings__DefaultConnection` porque la base de datos SQL Server ya está configurada en el código.

---

## ??? CÓMO AGREGAR VARIABLES EN RAILWAY

1. Ve al servicio en Railway
2. Click en la pestaña **"Variables"**
3. Click en **"New Variable"** o **"Raw Editor"**
4. Pega las variables (formato: `NOMBRE=valor`)
5. Click en **"Save"**
6. Railway redesplegará automáticamente

---

## ?? VERIFICAR VARIABLES

Para verificar que las variables se están leyendo correctamente:

**Opción 1: Revisar logs**
```
Railway ? Servicio ? Deployments ? View Logs
```

**Opción 2: Agregar log temporal en Program.cs**
```csharp
Console.WriteLine($"JWT_SECRET_KEY: {builder.Configuration["Jwt:Key"]}");
Console.WriteLine($"SQL Server: {builder.Configuration.GetConnectionString("DefaultConnection")}");
```

---

## ?? CHECKLIST DE VARIABLES

- [ ] Configuré las mismas variables globales en todos los servicios
- [ ] Generé las URLs públicas de cada servicio
- [ ] Actualicé ApiGateway con las URLs correctas
- [ ] Redesplegué ApiGateway después de actualizar variables
- [ ] Verifiqué en los logs que las variables se leen correctamente
- [ ] ? NO necesito crear PostgreSQL (uso SQL Server existente)

---

## ?? TIPS

1. **Usa el Raw Editor** en Railway para copiar/pegar múltiples variables
2. **Documenta las URLs** en un archivo aparte
3. **Cambia el JWT_SECRET_KEY** antes de producción real
4. **No uses RabbitMQ** si no es necesario (deja vacío)
5. ? **Tu SQL Server en Somee.com seguirá funcionando** desde Railway

---

## ?? TROUBLESHOOTING

### "Variable no encontrada"

- Verifica que el nombre sea **exactamente** igual (case-sensitive)
- Asegúrate de haber guardado las variables
- Redesplega el servicio

### "Database connection failed"

- Verifica que Somee.com esté activo
- Prueba la conexión desde SSMS
- Verifica que el firewall de Somee permita conexiones desde Railway
- Revisa los logs para ver el error exacto

### "JWT validation failed"

- Verifica que `JWT_SECRET_KEY` sea **el mismo** en todos los servicios
- Debe tener al menos 32 caracteres

---

## ?? VENTAJAS DE TU CONFIGURACIÓN

? **Base de datos única** - Todos los microservicios comparten la misma BD  
? **Sin migración** - Tu base de datos ya funciona con datos reales  
? **Sin costo adicional** - Somee.com ya está pago (o gratis)  
? **Código portátil** - Funciona en local y en Railway  

---

? **¡Con estas variables tu sistema estará completamente configurado con SQL Server!** ?
