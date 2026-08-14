import 'package:equatable/equatable.dart';

class ServicioEntidad extends Equatable {
  const ServicioEntidad({
    required this.id,
    required this.nombre,
    required this.precioBase,
    required this.duracionMinutos,
    this.descripcion,
    this.categoria,
  });

  final String id;
  final String nombre;
  final double precioBase;
  final int duracionMinutos;
  final String? descripcion;
  final String? categoria;

  @override
  List<Object?> get props => [id, nombre, precioBase];
}
