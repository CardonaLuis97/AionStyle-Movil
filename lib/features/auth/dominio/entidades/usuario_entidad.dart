import 'package:equatable/equatable.dart';

/// Entidad pura de dominio — sin dependencias de Dart/Flutter externas.
class UsuarioEntidad extends Equatable {
  const UsuarioEntidad({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    this.rol = RolUsuario.cliente,
  });

  final String id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final RolUsuario rol;

  bool get esBarbero => rol == RolUsuario.barbero;
  bool get esPropietario => rol == RolUsuario.propietario;
  bool get esAdmin => rol == RolUsuario.admin;

  @override
  List<Object?> get props => [id, nombre, email, telefono, fotoPerfil, rol];
}

enum RolUsuario { cliente, barbero, propietario, admin }
