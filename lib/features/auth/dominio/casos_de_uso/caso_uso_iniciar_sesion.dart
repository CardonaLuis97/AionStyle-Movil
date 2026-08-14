import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoIniciarSesion {
  const CasoUsoIniciarSesion(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<Resultado<UsuarioEntidad>> ejecutar({
    required String email,
    required String contrasena,
  }) {
    return _repositorio.iniciarSesion(email: email, contrasena: contrasena);
  }
}
