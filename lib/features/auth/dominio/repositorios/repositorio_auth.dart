import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../entidades/tipo_documento.dart';

abstract class RepositorioAuth {
  Future<Resultado<UsuarioEntidad>> loginConCorreo({
    required String correo,
    required String contrasena,
  });

  Future<Resultado<UsuarioEntidad>> loginConGoogle();

  Future<Resultado<UsuarioEntidad>> registrar({
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  });

  /// Completa el perfil de un usuario registrado con Google
  Future<Resultado<UsuarioEntidad>> completarPerfil({
    required String usuarioId,
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  });

  Future<ResultadoVacio> cerrarSesion();

  Future<Resultado<UsuarioEntidad?>> obtenerUsuarioActual();
}
