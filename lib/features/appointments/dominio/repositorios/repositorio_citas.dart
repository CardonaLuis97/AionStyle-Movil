import '../../../../core/utils/resultado.dart';
import '../entidades/cita_entidad.dart';

abstract class RepositorioCitas {
  Future<Resultado<List<CitaEntidad>>> obtenerCitasDelUsuario(String usuarioId);
  Future<Resultado<CitaEntidad>> crearCita(CitaEntidad cita);
  Future<ResultadoVacio> cancelarCita(String citaId);
  Future<Resultado<CitaEntidad>> obtenerCitaPorId(String id);
}
