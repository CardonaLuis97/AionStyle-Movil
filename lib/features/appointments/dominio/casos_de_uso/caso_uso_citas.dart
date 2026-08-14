import '../../../../core/utils/resultado.dart';
import '../entidades/cita_entidad.dart';
import '../repositorios/repositorio_citas.dart';

class CasoUsoObtenerCitas {
  const CasoUsoObtenerCitas(this._repositorio);
  final RepositorioCitas _repositorio;

  Future<Resultado<List<CitaEntidad>>> ejecutar(String usuarioId) {
    return _repositorio.obtenerCitasDelUsuario(usuarioId);
  }
}

class CasoUsoCrearCita {
  const CasoUsoCrearCita(this._repositorio);
  final RepositorioCitas _repositorio;

  Future<Resultado<CitaEntidad>> ejecutar(CitaEntidad cita) {
    return _repositorio.crearCita(cita);
  }
}

class CasoUsoCancelarCita {
  const CasoUsoCancelarCita(this._repositorio);
  final RepositorioCitas _repositorio;

  Future<ResultadoVacio> ejecutar(String citaId) {
    return _repositorio.cancelarCita(citaId);
  }
}
