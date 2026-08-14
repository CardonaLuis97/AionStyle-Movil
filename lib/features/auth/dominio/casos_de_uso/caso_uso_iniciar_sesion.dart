import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoLoginCorreo {
  const CasoUsoLoginCorreo(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<Resultado<UsuarioEntidad>> ejecutar({
    required String correo,
    required String contrasena,
  }) {
    return _repositorio.loginConCorreo(correo: correo, contrasena: contrasena);
  }
}
