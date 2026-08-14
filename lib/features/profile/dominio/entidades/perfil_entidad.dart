import 'package:equatable/equatable.dart';

class PerfilEntidad extends Equatable {
  const PerfilEntidad({
    required this.usuarioId,
    required this.nombre,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    this.fechaNacimiento,
  });

  final String usuarioId;
  final String nombre;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final DateTime? fechaNacimiento;

  @override
  List<Object?> get props => [usuarioId, email];
}
