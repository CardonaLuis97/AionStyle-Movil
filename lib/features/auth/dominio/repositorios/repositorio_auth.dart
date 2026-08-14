import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';

/// Contrato de repositorio — solo interfaz, sin implementación.
abstract class RepositorioAuth {
  Future<Resultado<UsuarioEntidad>> iniciarSesion({
    required String email,
    required String contrasena,
  });

  Future<Resultado<UsuarioEntidad>> iniciarSesionGoogle();

  Future<Resultado<UsuarioEntidad>> registrarse({
    required String nombre,
    required String email,
    required String contrasena,
  });

  Future<ResultadoVacio> cerrarSesion();

  Future<Resultado<UsuarioEntidad?>> obtenerUsuarioActual();
}
