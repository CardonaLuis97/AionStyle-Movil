import 'package:equatable/equatable.dart';

class NegocioEntidad extends Equatable {
  const NegocioEntidad({
    required this.id,
    required this.nombre,
    required this.direccion,
    this.telefono,
    this.fotoPrincipal,
    this.calificacion = 0.0,
    this.totalResenas = 0,
  });

  final String id;
  final String nombre;
  final String direccion;
  final String? telefono;
  final String? fotoPrincipal;
  final double calificacion;
  final int totalResenas;

  @override
  List<Object?> get props => [id, nombre, direccion];
}
