import '../../../../core/utils/resultado.dart';
import '../entidades/negocio_entidad.dart';
import '../repositorios/repositorio_negocios.dart';

class CasoUsoObtenerNegocios {
  const CasoUsoObtenerNegocios(this._repositorio);
  final RepositorioNegocios _repositorio;

  Future<Resultado<List<NegocioEntidad>>> ejecutar() {
    return _repositorio.obtenerNegocios();
  }
}
