import '../../../../core/utils/resultado.dart';
import '../entidades/usuario_entidad.dart';
import '../entidades/tipo_documento.dart';
import '../repositorios/repositorio_auth.dart';

class CasoUsoCompletarPerfil {
  const CasoUsoCompletarPerfil(this._repositorio);
  final RepositorioAuth _repositorio;

  Future<Resultado<UsuarioEntidad>> ejecutar({
    required String usuarioId,
    required String nombreCompleto,
    required TipoDocumento tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  }) {
    return _repositorio.completarPerfil(
      usuarioId: usuarioId,
      nombreCompleto: nombreCompleto,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      telefono: telefono,
    );
  }
}
