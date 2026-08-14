import 'package:freezed_annotation/freezed_annotation.dart';
import '../../dominio/entidades/usuario_entidad.dart';

part 'estado_auth.freezed.dart';

@freezed
class EstadoAuth with _$EstadoAuth {
  const factory EstadoAuth.inicial() = _Inicial;
  const factory EstadoAuth.cargando() = _Cargando;
  const factory EstadoAuth.autenticado(UsuarioEntidad usuario) = _Autenticado;
  const factory EstadoAuth.noAutenticado() = _NoAutenticado;
  const factory EstadoAuth.error(String mensaje) = _Error;
}
