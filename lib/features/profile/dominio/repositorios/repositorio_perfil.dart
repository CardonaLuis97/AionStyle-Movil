import '../../../../core/utils/resultado.dart';
import '../entidades/perfil_entidad.dart';

abstract class RepositorioPerfil {
  Future<Resultado<PerfilEntidad>> obtenerPerfil(String usuarioId);
  Future<Resultado<PerfilEntidad>> actualizarPerfil(PerfilEntidad perfil);
}
