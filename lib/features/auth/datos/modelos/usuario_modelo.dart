import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dominio/entidades/usuario_entidad.dart';

part 'usuario_modelo.freezed.dart';
part 'usuario_modelo.g.dart';

@freezed
class UsuarioModelo with _$UsuarioModelo {
  const factory UsuarioModelo({
    required String id,
    required String nombre,
    required String email,
    String? telefono,
    @JsonKey(name: 'foto_perfil') String? fotoPerfil,
    @Default('cliente') String rol,
  }) = _UsuarioModelo;

  factory UsuarioModelo.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModeloFromJson(json);
}

extension UsuarioModeloX on UsuarioModelo {
  UsuarioEntidad aEntidad() => UsuarioEntidad(
        id: id,
        nombre: nombre,
        email: email,
        telefono: telefono,
        fotoPerfil: fotoPerfil,
        rol: _rolDesdeString(rol),
      );

  RolUsuario _rolDesdeString(String valor) {
    return RolUsuario.values.firstWhere(
      (r) => r.name == valor,
      orElse: () => RolUsuario.cliente,
    );
  }
}
