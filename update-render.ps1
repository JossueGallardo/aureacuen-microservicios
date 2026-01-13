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
$mensaje = "feat: Migrar CancelarReserva de .NET Framework a .NET 8"
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
Write-Host "🔍 Servicios que se redespliegan:" -ForegroundColor White
Write-Host "   - ApiGateway" -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 Cambios aplicados:" -ForegroundColor White
Write-Host "   ✅ Migrado CancelarReserva de .NET Framework a .NET 8" -ForegroundColor Green
Write-Host "   ✅ Comportamiento idéntico al API anterior" -ForegroundColor Green
Write-Host "   ✅ Siempre retorna 200 OK (excepto errores graves)" -ForegroundColor Green
Write-Host "   ✅ Deserializa respuesta de RECA correctamente" -ForegroundColor Green
Write-Host "   ✅ Manejo graceful de errores de conexión" -ForegroundColor Green
Write-Host ""
Write-Host "🧪 Después del redespliegue prueba:" -ForegroundColor White
Write-Host ""
Write-Host "   # Sin idReserva" -ForegroundColor Gray
Write-Host "   DELETE /api/integracion/reservas/cancelar" -ForegroundColor Cyan
Write-Host "   → 200 OK { success: false, montoPagado: 0, mensaje: 'Debe enviar idReserva.' }" -ForegroundColor Gray
Write-Host ""
Write-Host "   # Reserva no activa" -ForegroundColor Gray
Write-Host "   DELETE /api/integracion/reservas/cancelar?idReserva=310" -ForegroundColor Cyan
Write-Host "   → 200 OK { success: false, montoPagado: 0, mensaje: 'La reserva ya no se encuentra activa.' }" -ForegroundColor Gray
Write-Host ""
Write-Host "   # Cancelación exitosa" -ForegroundColor Gray
Write-Host "   DELETE /api/integracion/reservas/cancelar?idReserva=151" -ForegroundColor Cyan
Write-Host "   → 200 OK { success: true, montoPagado: 150.50, mensaje: '' }" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentación completa:" -ForegroundColor White
Write-Host "   - MIGRACION_CANCELAR_RESERVA.md" -ForegroundColor Cyan
Write-Host "   - ACTUALIZACION_CANCELAR_RESERVA.md" -ForegroundColor Cyan
Write-Host "   - FIX_FECHAS_OCUPADAS_DUPLICADAS.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ✅ ACTUALIZACIÓN COMPLETA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
