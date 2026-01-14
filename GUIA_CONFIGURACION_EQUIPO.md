# 🔧 GUÍA DE CONFIGURACIÓN - MICROSERVICIOS HOTEL

## 📋 INTRODUCCIÓN

Este documento te muestra **exactamente** dónde y qué debes modificar para conectar los microservicios con **TUS URLs de Render** y **TU base de datos**.

---

## 🎯 ¿QUÉ VAS A CONFIGURAR?

1. ✅ **Base de datos SQL Server** (cadena de conexión)
2. ✅ **URL de tu API REST externa** (RECA API - aureacuen)
3. ✅ **URLs de los microservicios en Render**
4. ✅ **Configuración de JWT** (autenticación)
5. ✅ **RabbitMQ** (opcional - Event Bus)

---

## 📁 ESTRUCTURA DE ARCHIVOS DE CONFIGURACIÓN

```
Microservicios/
├── Shared.Data/
│   └── DatabaseConfig.cs                    ⚠️ MODIFICAR AQUÍ LA BASE DE DATOS
│
├── ApiGateway/
│   ├── appsettings.json                     ⚠️ MODIFICAR URLs DE MICROSERVICIOS
│   └── appsettings.Development.json         (solo para local)
│
├── CatalogosService/
│   ├── appsettings.json                     ⚠️ MODIFICAR JWT
│   └── appsettings.Development.json         (solo para local)
│
├── HabitacionesService/
│   ├── appsettings.json                     ⚠️ MODIFICAR JWT
│   └── appsettings.Development.json         (solo para local)
│
├── ReservasService/
│   ├── appsettings.json                     ⚠️ MODIFICAR JWT
│   └── appsettings.Development.json         (solo para local)
│
└── UsuariosPagosService/
    ├── appsettings.json                     ⚠️ MODIFICAR JWT + gRPC URL
    └── appsettings.Development.json         (solo para local)
```

---

## 🗄️ 1. CONFIGURAR BASE DE DATOS SQL SERVER

### 📍 **Archivo:** `Shared.Data/DatabaseConfig.cs`

```csharp
namespace Shared.Data;

public static class DatabaseConfig
{
    // ⚠️ MODIFICAR ESTA LÍNEA CON TU CADENA DE CONEXIÓN
    public const string ConnectionString = "Server=TU_SERVIDOR;Database=TU_BASE_DATOS;User Id=TU_USUARIO;Password=TU_PASSWORD;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;";
}
```

### 📝 **¿Qué debo poner?**

**Ejemplo actual (base de datos del proyecto):**
```
Server=db31651.public.databaseasp.net;Database=db31651;User Id=db31651;Password=prueba2020d;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;
```

**Ejemplo con tu propia base de datos:**
```
Server=MI_SERVIDOR.database.windows.net;Database=HotelDB;User Id=admin;Password=MiPassword123!;Encrypt=True;TrustServerCertificate=True;MultipleActiveResultSets=True;
```

### ✅ **Servicios que usan esta configuración:**
- ✅ CatalogosService
- ✅ HabitacionesService
- ✅ ReservasService
- ✅ UsuariosPagosService

---

## 🌐 2. CONFIGURAR API REST EXTERNA (RECA API)

### 📍 **Archivo:** `ApiGateway/appsettings.json`

```json
{
  "Integrations": {
    "RecaApi": {
      "BaseUrl": "http://aureacuenrest.runasp.net/"   // ⚠️ MODIFICAR AQUÍ
    }
  }
}
```

### 📝 **¿Qué es RECA API?**

Es tu **API REST de .NET Framework** que está desplegada en RUNasp.net. El ApiGateway la usa para:
- Crear pre-reservas (holds)
- Confirmar reservas
- Cancelar reservas
- Emitir facturas

### 📝 **¿Dónde está desplegada?**

**URL actual:** `http://aureacuenrest.runasp.net/`

**Endpoints que usa:**
- `POST /api/v1/hoteles/hold` - Crear pre-reserva
- `POST /api/v1/hoteles/booking` - Confirmar reserva
- `DELETE /api/v1/hoteles/cancel` - Cancelar reserva

### ✅ **Si tienes tu propia API REST, cambia la URL:**

```json
{
  "Integrations": {
    "RecaApi": {
      "BaseUrl": "https://MI_API.runasp.net/"
    }
  }
}
```

---

## 🔗 3. CONFIGURAR URLs DE MICROSERVICIOS EN RENDER

### 📍 **Archivo:** `ApiGateway/appsettings.json`

```json
{
  "GrpcServices": {
    "ReservasService": "https://reservas-service.onrender.com"  // ⚠️ MODIFICAR AQUÍ
  },
  "ReverseProxy": {
    "Clusters": {
      "catalogos-cluster": {
        "Destinations": {
          "catalogos-service": {
            "Address": "http://localhost:5001"  // ⚠️ CAMBIAR EN PRODUCCIÓN
          }
        }
      },
      "habitaciones-cluster": {
        "Destinations": {
          "habitaciones-service": {
            "Address": "http://localhost:5002"  // ⚠️ CAMBIAR EN PRODUCCIÓN
          }
        }
      },
      "reservas-cluster": {
        "Destinations": {
          "reservas-service": {
            "Address": "http://localhost:5003"  // ⚠️ CAMBIAR EN PRODUCCIÓN
          }
        }
      },
      "usuarios-pagos-cluster": {
        "Destinations": {
          "usuarios-pagos-service": {
            "Address": "http://localhost:5004"  // ⚠️ CAMBIAR EN PRODUCCIÓN
          }
        }
      }
    }
  }
}
```

### 📝 **¿Qué debo cambiar?**

#### **Si estás desplegando en Render:**

1. **Despliega cada microservicio** en Render y obtén sus URLs
2. **Reemplaza las URLs** en el archivo:

```json
{
  "GrpcServices": {
    "ReservasService": "https://TU_RESERVAS_SERVICE.onrender.com"
  },
  "ReverseProxy": {
    "Clusters": {
      "catalogos-cluster": {
        "Destinations": {
          "catalogos-service": {
            "Address": "https://TU_CATALOGOS_SERVICE.onrender.com"
          }
        }
      },
      "habitaciones-cluster": {
        "Destinations": {
          "habitaciones-service": {
            "Address": "https://TU_HABITACIONES_SERVICE.onrender.com"
          }
        }
      },
      "reservas-cluster": {
        "Destinations": {
          "reservas-service": {
            "Address": "https://TU_RESERVAS_SERVICE.onrender.com"
          }
        }
      },
      "usuarios-pagos-cluster": {
        "Destinations": {
          "usuarios-pagos-service": {
            "Address": "https://TU_USUARIOS_PAGOS_SERVICE.onrender.com"
          }
        }
      }
    }
  }
}
```

### ⚠️ **IMPORTANTE:**

- Las URLs de **localhost** son solo para **desarrollo local**
- Para **producción (Render)**, usa las URLs `https://TU_SERVICIO.onrender.com`

---

## 🔒 4. CONFIGURAR JWT (AUTENTICACIÓN)

### 📍 **Archivos a modificar:**

1. `ApiGateway/appsettings.json`
2. `CatalogosService/appsettings.json`
3. `HabitacionesService/appsettings.json`
4. `ReservasService/appsettings.json`
5. `UsuariosPagosService/appsettings.json`

### 📝 **Configuración actual (misma en todos los archivos):**

```json
{
  "Jwt": {
    "Key": "HotelMicroservicesSecretKey2024!@#$%^&*()_+",
    "Issuer": "HotelMicroservices",
    "Audience": "HotelMicroservicesClients",
    "ExpireMinutes": 60
  }
}
```

### 📝 **¿Debo cambiar esto?**

**SI quieres más seguridad:**
- Cambia el `Key` por una clave más larga y compleja
- Reduce `ExpireMinutes` (por ejemplo, 30 minutos)

**Ejemplo:**
```json
{
  "Jwt": {
    "Key": "MI_SUPER_CLAVE_SECRETA_QUE_NADIE_CONOCE_2024!!!",
    "Issuer": "MiSistemaHoteles",
    "Audience": "MisFrontendClients",
    "ExpireMinutes": 30
  }
}
```

### ⚠️ **IMPORTANTE:**

**TODOS LOS MICROSERVICIOS DEBEN TENER LA MISMA CONFIGURACIÓN JWT** para que puedan validar los tokens correctamente.

---

## 📡 5. CONFIGURAR gRPC (COMUNICACIÓN ENTRE SERVICIOS)

### 📍 **Archivo:** `UsuariosPagosService/appsettings.json`

```json
{
  "GrpcServices": {
    "ReservasService": "http://localhost:5003"  // ⚠️ MODIFICAR AQUÍ
  }
}
```

### 📝 **¿Qué es esto?**

UsuariosPagosService necesita comunicarse con ReservasService usando gRPC para validar reservas antes de procesar pagos.

### 📝 **¿Qué debo cambiar?**

#### **Para desarrollo local:**
```json
{
  "GrpcServices": {
    "ReservasService": "http://localhost:5003"
  }
}
```

#### **Para producción en Render:**
```json
{
  "GrpcServices": {
    "ReservasService": "https://TU_RESERVAS_SERVICE.onrender.com"
  }
}
```

---

## 🐰 6. CONFIGURAR RABBITMQ (OPCIONAL - EVENT BUS)

### 📝 **¿Qué es RabbitMQ?**

RabbitMQ es un sistema de mensajería que permite la **comunicación asíncrona** entre microservicios mediante eventos.

### 📝 **¿Es obligatorio configurarlo?**

**NO.** Si no configuras RabbitMQ, los servicios usarán `NullEventBus` (un bus de eventos vacío que no hace nada pero no rompe la aplicación).

### 📝 **¿Cómo lo configuro si lo necesito?**

Agrega esta sección a cada `appsettings.json`:

```json
{
  "RabbitMQ": {
    "Host": "TU_RABBITMQ_HOST"
  }
}
```

**Ejemplos:**
- Local: `"Host": "localhost"`
- CloudAMQP: `"Host": "amqp://usuario:password@servidor.cloudamqp.com"`

---

## 🚀 7. VARIABLES DE ENTORNO EN RENDER

Cuando despliegas en Render, puedes sobreescribir la configuración usando **variables de entorno**.

### 📝 **Variables recomendadas para configurar en Render:**

#### **Para ApiGateway:**
```
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://0.0.0.0:$PORT
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
Jwt__Issuer=HotelMicroservices
Jwt__Audience=HotelMicroservicesClients
RESERVAS_SERVICE_URL=https://TU_RESERVAS_SERVICE.onrender.com
RECA_API_BASE_URL=http://aureacuenrest.runasp.net/
```

#### **Para cada microservicio (CatalogosService, HabitacionesService, etc.):**
```
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://0.0.0.0:$PORT
JWT_SECRET_KEY=HotelMicroservicesSecretKey2024!@#$%^&*()_+
Jwt__Issuer=HotelMicroservices
Jwt__Audience=HotelMicroservicesClients
DATABASE_CONNECTION_STRING=Server=TU_SERVIDOR;Database=TU_BD;...
```

---

## 📊 RESUMEN DE CONFIGURACIONES POR SERVICIO

| Servicio | Base de Datos | JWT | URLs | gRPC | RabbitMQ |
|----------|--------------|-----|------|------|----------|
| **ApiGateway** | ❌ No | ✅ Sí | ✅ Sí (todos) | ✅ Sí (ReservasService) | ⚠️ Opcional |
| **CatalogosService** | ✅ Sí | ✅ Sí | ❌ No | ❌ No | ⚠️ Opcional |
| **HabitacionesService** | ✅ Sí | ✅ Sí | ❌ No | ❌ No | ⚠️ Opcional |
| **ReservasService** | ✅ Sí | ✅ Sí | ❌ No | ❌ No | ⚠️ Opcional |
| **UsuariosPagosService** | ✅ Sí | ✅ Sí | ❌ No | ✅ Sí (ReservasService) | ⚠️ Opcional |

---

## 🧪 VERIFICAR CONFIGURACIÓN

### ✅ **1. Base de datos:**

```bash
# Probar conexión
curl http://localhost:5001/api/hoteles
```

Si devuelve datos, la BD está bien configurada.

### ✅ **2. JWT:**

```bash
# Obtener token
curl -X POST http://localhost:5000/api/auth/token \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

Si devuelve un token, el JWT está bien configurado.

### ✅ **3. URLs de microservicios:**

```bash
# Probar desde ApiGateway
curl http://localhost:5000/api/catalogos/hoteles
curl http://localhost:5000/graphql
curl http://localhost:5000/api/usuarios-pagos/usuarios
```

Si responden, las URLs están bien configuradas.

### ✅ **4. gRPC:**

```bash
# Probar endpoint gRPC desde ApiGateway
curl http://localhost:5000/api/reservas-grpc/reservas
```

Si devuelve datos, el gRPC está bien configurado.

---

## 🆘 PROBLEMAS COMUNES

### ❌ **Error: "Could not connect to SQL Server"**

**Causa:** Cadena de conexión incorrecta en `Shared.Data/DatabaseConfig.cs`

**Solución:**
1. Verifica el `Server`, `Database`, `User Id` y `Password`
2. Asegúrate de que el servidor permita conexiones externas
3. Verifica que el firewall permita el puerto 1433

---

### ❌ **Error: "Unauthorized" al llamar endpoints**

**Causa:** JWT mal configurado o token expirado

**Solución:**
1. Verifica que **todos** los `appsettings.json` tengan la **misma configuración JWT**
2. Genera un nuevo token con `/api/auth/token`
3. Usa el token en el header: `Authorization: Bearer TU_TOKEN`

---

### ❌ **Error: "Service Unavailable" al llamar microservicios**

**Causa:** URLs incorrectas en `ApiGateway/appsettings.json`

**Solución:**
1. Verifica que las URLs en `ReverseProxy.Clusters` sean correctas
2. Asegúrate de que los servicios estén corriendo
3. Usa URLs de Render en producción, no `localhost`

---

### ❌ **Error: "Bad gRPC response"**

**Causa:** URL de ReservasService incorrecta o servicio no disponible

**Solución:**
1. Verifica `GrpcServices.ReservasService` en `appsettings.json`
2. Asegúrate de que ReservasService esté desplegado y corriendo
3. Usa HTTPS en producción: `https://TU_RESERVAS.onrender.com`

---

## 📞 CONTACTO

Si tienes dudas sobre la configuración, contacta con el equipo de desarrollo.

---

## 📚 DOCUMENTACIÓN ADICIONAL

- **Despliegue en Render:** Ver `DEPLOY_RENDER.md` (si existe)
- **Arquitectura:** Ver `README.md`
- **API Gateway:** Ver documentación Swagger en `/swagger`

---

<div align="center">

# ✅ **CONFIGURACIÓN COMPLETA** ✅

**Recuerda:**
1. ✅ Modificar base de datos en `Shared.Data/DatabaseConfig.cs`
2. ✅ Ajustar URLs en `ApiGateway/appsettings.json`
3. ✅ Verificar JWT en todos los `appsettings.json`
4. ✅ Configurar variables de entorno en Render

**¡Listo para desplegar!** 🚀

</div>
