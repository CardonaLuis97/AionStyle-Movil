import '../../../../core/utils/resultado.dart';
import '../entidades/barbero_entidad.dart';

abstract class RepositorioBarberos {
  Future<Resultado<List<BarberoEntidad>>> obtenerBarberosPorNegocio(String negocioId);
  Future<Resultado<BarberoEntidad>> obtenerBarberoPorId(String id);
}
