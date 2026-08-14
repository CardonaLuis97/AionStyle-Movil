import '../../../../core/utils/resultado.dart';
import '../entidades/negocio_entidad.dart';

abstract class RepositorioNegocios {
  Future<Resultado<List<NegocioEntidad>>> obtenerNegocios();
  Future<Resultado<NegocioEntidad>> obtenerNegocioPorId(String id);
}
