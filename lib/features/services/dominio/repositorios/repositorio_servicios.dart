import '../../../../core/utils/resultado.dart';
import '../entidades/servicio_entidad.dart';

abstract class RepositorioServicios {
  Future<Resultado<List<ServicioEntidad>>> obtenerServiciosPorNegocio(String negocioId);
}
