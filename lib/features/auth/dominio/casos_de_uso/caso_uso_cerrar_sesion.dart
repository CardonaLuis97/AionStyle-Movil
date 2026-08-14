import '../../../../core/utils/resultado.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoCerrarSesion {
  const CasoUsoCerrarSesion(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<ResultadoVacio> ejecutar() {
    return _repositorio.cerrarSesion();
  }
}
