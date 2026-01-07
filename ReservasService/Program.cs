using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.IdentityModel.Tokens;
using ReservasService.Services;
using Shared.Data;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

//
// =======================
// Kestrel – gRPC HTTP/2
// =======================
// OBLIGATORIO para gRPC en Docker
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(8080, listenOptions =>
    {
        listenOptions.Protocols = HttpProtocols.Http2;
    });
});

//
// =======================
// gRPC
// =======================
builder.Services.AddGrpc();

//
// =======================
// JWT Authentication
// =======================
var jwtKey = builder.Configuration["Jwt:Key"]
             ?? "HotelMicroservicesSecretKey2024!@#$%^&*()_+";
var jwtIssuer = builder.Configuration["Jwt:Issuer"]
                ?? "HotelMicroservices";
var jwtAudience = builder.Configuration["Jwt:Audience"]
                  ?? "HotelMicroservicesClients";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey =
                new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

builder.Services.AddAuthorization();

//
// =======================
// Repositorios
// =======================
builder.Services.AddScoped<ReservaRepository>();
builder.Services.AddScoped<HabxResRepository>();
builder.Services.AddScoped<DesxHabxResRepository>();
builder.Services.AddScoped<HoldRepository>();

//
// =======================
// HealthCheck (recomendado)
// =======================
builder.Services.AddHealthChecks();

var app = builder.Build();

//
// =======================
// Middleware
// =======================
app.UseAuthentication();
app.UseAuthorization();

//
// =======================
// Endpoints
// =======================
app.MapGrpcService<ReservasGrpcService>();

app.MapHealthChecks("/health");

app.MapGet("/", () =>
    "gRPC Reservas Service is running. Use a gRPC client.");

app.Run();
