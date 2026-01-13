using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace ApiGateway.Controllers.Integracion;

[ApiController]
[Route("api/integracion/reservas")]
public class IntegracionCancelarReservaController : ControllerBase
{
    private readonly HttpClient _http;
    private readonly ILogger<IntegracionCancelarReservaController> _logger;

    public IntegracionCancelarReservaController(
        IHttpClientFactory factory,
        ILogger<IntegracionCancelarReservaController> logger)
    {
        _http = factory.CreateClient("RecaApi");
        _logger = logger;
    }

    /// <summary>
    /// Cancela una reserva y retorna el monto pagado a reembolsar.
    /// Siempre retorna 200 OK con un objeto JSON que indica el resultado.
    /// </summary>
    /// <param name="idReserva">ID de la reserva a cancelar</param>
    /// <returns>
    /// {
    ///   "success": true/false,
    ///   "montoPagado": 150.50,
    ///   "mensaje": "Reserva cancelada exitosamente" | "Error message"
    /// }
    /// </returns>
    [HttpDelete("cancelar")]
    public async Task<IActionResult> CancelarReserva([FromQuery] int? idReserva)
    {
        // Validación: idReserva es obligatorio
        if (!idReserva.HasValue)
        {
            _logger.LogWarning("Intento de cancelación sin idReserva");
            return Ok(new CancelarReservaResponse
            {
                Success = false,
                MontoPagado = 0,
                Mensaje = "Debe enviar idReserva."
            });
        }

        try
        {
            _logger.LogInformation("Cancelando reserva {IdReserva} en RECA API", idReserva.Value);
            
            // Llamar a RECA API (tu API anterior)
            // GET http://aureacuenrest.runasp.net/api/v1/hoteles/cancel?idReserva=310
            var response = await _http.DeleteAsync(
                $"/api/v1/hoteles/cancel?idReserva={idReserva.Value}"
            );

            var content = await response.Content.ReadAsStringAsync();
            
            _logger.LogInformation("RECA API response status: {StatusCode}, content: {Content}", 
                response.StatusCode, content);

            // RECA siempre retorna 200 OK, incluso en errores de negocio
            // Deserializar la respuesta
            CancelarReservaResponse? result = null;
            
            try
            {
                result = JsonSerializer.Deserialize<CancelarReservaResponse>(content, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "Error al deserializar respuesta de RECA: {Content}", content);
            }

            // Si no se pudo deserializar o es null
            if (result == null)
            {
                _logger.LogWarning("Failed to deserialize RECA response: {Content}", content);
                
                // Si RECA retornó error HTTP (500, etc.)
                if (!response.IsSuccessStatusCode)
                {
                    return Ok(new CancelarReservaResponse
                    {
                        Success = false,
                        MontoPagado = 0,
                        Mensaje = "No se pudo procesar la cancelacion."
                    });
                }
                
                // Intentar retornar el contenido tal cual si es JSON válido
                return Ok(content);
            }

            _logger.LogInformation("Reserva {IdReserva} procesada. Success: {Success}, Monto: {Monto}, Mensaje: {Mensaje}", 
                idReserva.Value, result.Success, result.MontoPagado, result.Mensaje);

            // 🔔 Opcional: publicar evento RabbitMQ
            // if (result.Success)
            // {
            //     await _eventBus.PublishAsync(new ReservaCanceladaEvent
            //     {
            //         IdReserva = idReserva.Value,
            //         MontoPagado = result.MontoPagado,
            //         FechaCancelacion = DateTime.UtcNow
            //     });
            // }

            // Siempre retornar 200 OK con el resultado
            return Ok(result);
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "Error de conexión al cancelar reserva {IdReserva}", idReserva.Value);
            
            // Retornar 200 OK con error (como lo hacía tu API anterior)
            return Ok(new CancelarReservaResponse
            {
                Success = false,
                MontoPagado = 0,
                Mensaje = "Error de conexión con el servicio de reservas"
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error inesperado al cancelar reserva {IdReserva}", idReserva.Value);
            
            // Retornar 500 solo en errores graves (como tu API anterior con InternalServerError)
            return StatusCode(500, new
            {
                message = ex.Message,
                type = ex.GetType().Name
            });
        }
    }
}

/// <summary>
/// Respuesta de la API RECA para cancelación de reserva.
/// Coincide con la estructura de tu API anterior en .NET Framework.
/// </summary>
public class CancelarReservaResponse
{
    /// <summary>
    /// Indica si la cancelación fue exitosa
    /// </summary>
    public bool Success { get; set; }
    
    /// <summary>
    /// Monto que fue pagado y será reembolsado (viene del stored procedure)
    /// </summary>
    public decimal MontoPagado { get; set; }
    
    /// <summary>
    /// Mensaje descriptivo del resultado (del stored procedure)
    /// </summary>
    public string Mensaje { get; set; } = string.Empty;
}
