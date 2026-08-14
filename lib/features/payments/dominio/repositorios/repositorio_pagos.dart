import '../../../../core/utils/resultado.dart';
import '../entidades/pago_entidad.dart';

abstract class RepositorioPagos {
  Future<Resultado<String>> crearIntentoPago(String citaId, double monto);
  Future<Resultado<PagoEntidad>> confirmarPago(String pagoId);
  Future<Resultado<List<PagoEntidad>>> obtenerHistorialPagos(String usuarioId);
}
