import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoRegistrarse {
  const CasoUsoRegistrarse(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<Resultado<UsuarioEntidad>> ejecutar({
    required String nombre,
    required String email,
    required String contrasena,
  }) {
    return _repositorio.registrarse(
      nombre: nombre,
      email: email,
      contrasena: contrasena,
    );
  }
}
