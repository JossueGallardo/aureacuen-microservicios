# Script para actualizar el código en GitHub y triggear redespliegue en Render

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ACTUALIZANDO CÓDIGO EN GITHUB" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Agregar todos los cambios
Write-Host "[1/4] Agregando cambios..." -ForegroundColor Yellow
git add .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al agregar archivos" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Cambios agregados" -ForegroundColor Green
Write-Host ""

# 2. Commit
Write-Host "[2/4] Creando commit..." -ForegroundColor Yellow
$mensaje = "Fix: Agregar using Shared.EventBus en ReservasService y JWT fallback"
git commit -m $mensaje

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  No hay cambios para commit o error" -ForegroundColor Yellow
} else {
    Write-Host "✅ Commit creado: $mensaje" -ForegroundColor Green
}

Write-Host ""

# 3. Push
Write-Host "[3/4] Subiendo a GitHub..." -ForegroundColor Yellow
git push

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al subir a GitHub" -ForegroundColor Red
    Write-Host "Verifica tu conexión y autenticación" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Código subido a GitHub" -ForegroundColor Green
Write-Host ""

# 4. Información
Write-Host "[4/4] Siguiente paso" -ForegroundColor Yellow
Write-Host ""
Write-Host "✨ Render detectará el cambio automáticamente" -ForegroundColor Cyan
Write-Host "⏳ Espera 5-7 minutos mientras redesplega" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Monitorea el progreso en:" -ForegroundColor White
Write-Host "   https://dashboard.render.com" -ForegroundColor Blue
Write-Host ""
Write-Host "🔍 Servicio crítico que se redesplegará:" -ForegroundColor White
Write-Host "   - ReservasService (gRPC)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 Cambios aplicados:" -ForegroundColor White
Write-Host "   ✅ Agregado using Shared.EventBus" -ForegroundColor Green
Write-Host "   ✅ Configurado EventBus con fallback" -ForegroundColor Green
Write-Host "   ✅ Agregado fallback JWT_SECRET_KEY" -ForegroundColor Green
Write-Host "   ✅ Habilitado gRPC-Web" -ForegroundColor Green
Write-Host ""
Write-Host "🧪 Después del redespliegue:" -ForegroundColor White
Write-Host "   1. Verifica logs de ReservasService" -ForegroundColor Cyan
Write-Host "   2. Busca: 'Now listening on'" -ForegroundColor Cyan
Write-Host "   3. Prueba: https://reservas-service.onrender.com/health" -ForegroundColor Cyan
Write-Host "   4. Prueba gRPC desde ApiGateway" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ✅ ACTUALIZACIÓN COMPLETA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
