import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoIniciarSesionGoogle {
  const CasoUsoIniciarSesionGoogle(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<Resultado<UsuarioEntidad>> ejecutar() {
    return _repositorio.iniciarSesionGoogle();
  }
}
