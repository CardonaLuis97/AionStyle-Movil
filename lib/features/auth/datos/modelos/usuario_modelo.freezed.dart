// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario_modelo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsuarioModelo _$UsuarioModeloFromJson(Map<String, dynamic> json) {
  return _$$UsuarioModeloImplFromJson(json);
}

/// @nodoc
mixin _$UsuarioModelo {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nombre_completo')
  String get nombreCompleto => throw _privateConstructorUsedError;
  String get correo => throw _privateConstructorUsedError;
  String? get telefono => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipo_documento')
  String get tipoDocumento => throw _privateConstructorUsedError;
  @JsonKey(name: 'numero_documento')
  String get numeroDocumento => throw _privateConstructorUsedError;
  @JsonKey(name: 'imagen_perfil')
  String? get imagenPerfil => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'proveedor_autenticacion')
  String get proveedorAutenticacion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsuarioModeloCopyWith<UsuarioModelo> get copyWith =>
      throw _privateConstructorUsedError;
}

abstract class $UsuarioModeloCopyWith<$Res> {
  factory $UsuarioModeloCopyWith(
          UsuarioModelo value, $Res Function(UsuarioModelo) then) =
      _$UsuarioModeloCopyWithImpl<$Res, UsuarioModelo>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'nombre_completo') String nombreCompleto,
    String correo,
    String? telefono,
    @JsonKey(name: 'tipo_documento') String tipoDocumento,
    @JsonKey(name: 'numero_documento') String numeroDocumento,
    @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
    List<String> roles,
    @JsonKey(name: 'proveedor_autenticacion') String proveedorAutenticacion,
  });
}

class _$UsuarioModeloCopyWithImpl<$Res, $Val extends UsuarioModelo>
    implements $UsuarioModeloCopyWith<$Res> {
  _$UsuarioModeloCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? correo = null,
    Object? telefono = freezed,
    Object? tipoDocumento = null,
    Object? numeroDocumento = null,
    Object? imagenPerfil = freezed,
    Object? roles = null,
    Object? proveedorAutenticacion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      nombreCompleto: null == nombreCompleto ? _value.nombreCompleto : nombreCompleto as String,
      correo: null == correo ? _value.correo : correo as String,
      telefono: freezed == telefono ? _value.telefono : telefono as String?,
      tipoDocumento: null == tipoDocumento ? _value.tipoDocumento : tipoDocumento as String,
      numeroDocumento: null == numeroDocumento ? _value.numeroDocumento : numeroDocumento as String,
      imagenPerfil: freezed == imagenPerfil ? _value.imagenPerfil : imagenPerfil as String?,
      roles: null == roles ? _value.roles : roles as List<String>,
      proveedorAutenticacion: null == proveedorAutenticacion
          ? _value.proveedorAutenticacion
          : proveedorAutenticacion as String,
    ) as $Val);
  }
}

abstract class _$$UsuarioModeloImplCopyWith<$Res>
    implements $UsuarioModeloCopyWith<$Res> {
  factory _$$UsuarioModeloImplCopyWith(
          _$UsuarioModeloImpl value, $Res Function(_$UsuarioModeloImpl) then) =
      __$$UsuarioModeloImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'nombre_completo') String nombreCompleto,
    String correo,
    String? telefono,
    @JsonKey(name: 'tipo_documento') String tipoDocumento,
    @JsonKey(name: 'numero_documento') String numeroDocumento,
    @JsonKey(name: 'imagen_perfil') String? imagenPerfil,
    List<String> roles,
    @JsonKey(name: 'proveedor_autenticacion') String proveedorAutenticacion,
  });
}

class __$$UsuarioModeloImplCopyWithImpl<$Res>
    extends _$UsuarioModeloCopyWithImpl<$Res, _$UsuarioModeloImpl>
    implements _$$UsuarioModeloImplCopyWith<$Res> {
  __$$UsuarioModeloImplCopyWithImpl(
      _$UsuarioModeloImpl _value, $Res Function(_$UsuarioModeloImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? correo = null,
    Object? telefono = freezed,
    Object? tipoDocumento = null,
    Object? numeroDocumento = null,
    Object? imagenPerfil = freezed,
    Object? roles = null,
    Object? proveedorAutenticacion = null,
  }) {
    return _then(_$UsuarioModeloImpl(
      id: null == id ? _value.id : id as String,
      nombreCompleto: null == nombreCompleto ? _value.nombreCompleto : nombreCompleto as String,
      correo: null == correo ? _value.correo : correo as String,
      telefono: freezed == telefono ? _value.telefono : telefono as String?,
      tipoDocumento: null == tipoDocumento ? _value.tipoDocumento : tipoDocumento as String,
      numeroDocumento: null == numeroDocumento ? _value.numeroDocumento : numeroDocumento as String,
      imagenPerfil: freezed == imagenPerfil ? _value.imagenPerfil : imagenPerfil as String?,
      roles: null == roles ? _value._roles : roles as List<String>,
      proveedorAutenticacion: null == proveedorAutenticacion
          ? _value.proveedorAutenticacion
          : proveedorAutenticacion as String,
    ));
  }
}

@JsonSerializable()
class _$UsuarioModeloImpl implements _UsuarioModelo {
  const _$UsuarioModeloImpl({
    required this.id,
    @JsonKey(name: 'nombre_completo') required this.nombreCompleto,
    required this.correo,
    this.telefono,
    @JsonKey(name: 'tipo_documento') required this.tipoDocumento,
    @JsonKey(name: 'numero_documento') required this.numeroDocumento,
    @JsonKey(name: 'imagen_perfil') this.imagenPerfil,
    final List<String> roles = const ['CLIENTE'],
    @JsonKey(name: 'proveedor_autenticacion')
    this.proveedorAutenticacion = 'CORREO',
  }) : _roles = roles;

  factory _$UsuarioModeloImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioModeloImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'nombre_completo')
  final String nombreCompleto;
  @override
  final String correo;
  @override
  final String? telefono;
  @override
  @JsonKey(name: 'tipo_documento')
  final String tipoDocumento;
  @override
  @JsonKey(name: 'numero_documento')
  final String numeroDocumento;
  @override
  @JsonKey(name: 'imagen_perfil')
  final String? imagenPerfil;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles => List.unmodifiable(_roles);
  @override
  @JsonKey(name: 'proveedor_autenticacion')
  final String proveedorAutenticacion;

  @override
  String toString() {
    return 'UsuarioModelo(id: $id, nombreCompleto: $nombreCompleto, correo: $correo, telefono: $telefono, tipoDocumento: $tipoDocumento, numeroDocumento: $numeroDocumento, imagenPerfil: $imagenPerfil, roles: $roles, proveedorAutenticacion: $proveedorAutenticacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsuarioModeloImpl &&
            other.id == id &&
            other.nombreCompleto == nombreCompleto &&
            other.correo == correo &&
            other.telefono == telefono &&
            other.tipoDocumento == tipoDocumento &&
            other.numeroDocumento == numeroDocumento &&
            other.imagenPerfil == imagenPerfil &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            other.proveedorAutenticacion == proveedorAutenticacion);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nombreCompleto,
      correo,
      telefono,
      tipoDocumento,
      numeroDocumento,
      imagenPerfil,
      const DeepCollectionEquality().hash(_roles),
      proveedorAutenticacion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsuarioModeloImplCopyWith<_$UsuarioModeloImpl> get copyWith =>
      __$$UsuarioModeloImplCopyWithImpl<_$UsuarioModeloImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsuarioModeloImplToJson(this);
  }
}

abstract class _UsuarioModelo implements UsuarioModelo {
  const factory _UsuarioModelo({
    required final String id,
    @JsonKey(name: 'nombre_completo') required final String nombreCompleto,
    required final String correo,
    final String? telefono,
    @JsonKey(name: 'tipo_documento') required final String tipoDocumento,
    @JsonKey(name: 'numero_documento') required final String numeroDocumento,
    @JsonKey(name: 'imagen_perfil') final String? imagenPerfil,
    final List<String> roles,
    @JsonKey(name: 'proveedor_autenticacion') final String proveedorAutenticacion,
  }) = _$UsuarioModeloImpl;

  factory _UsuarioModelo.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioModeloImplFromJson(json);

  @override
  String get id;
  @override
  @JsonKey(name: 'nombre_completo')
  String get nombreCompleto;
  @override
  String get correo;
  @override
  String? get telefono;
  @override
  @JsonKey(name: 'tipo_documento')
  String get tipoDocumento;
  @override
  @JsonKey(name: 'numero_documento')
  String get numeroDocumento;
  @override
  @JsonKey(name: 'imagen_perfil')
  String? get imagenPerfil;
  @override
  List<String> get roles;
  @override
  @JsonKey(name: 'proveedor_autenticacion')
  String get proveedorAutenticacion;
  @override
  @JsonKey(ignore: true)
  _$$UsuarioModeloImplCopyWith<_$UsuarioModeloImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
