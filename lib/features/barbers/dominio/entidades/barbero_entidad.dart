import 'package:equatable/equatable.dart';

class BarberoEntidad extends Equatable {
  const BarberoEntidad({
    required this.id,
    required this.nombre,
    required this.negocioId,
    this.especialidad,
    this.fotoPerfil,
    this.calificacion = 0.0,
  });

  final String id;
  final String nombre;
  final String negocioId;
  final String? especialidad;
  final String? fotoPerfil;
  final double calificacion;

  @override
  List<Object?> get props => [id, nombre, negocioId];
}
