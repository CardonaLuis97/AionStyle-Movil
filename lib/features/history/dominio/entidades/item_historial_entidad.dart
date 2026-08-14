import 'package:equatable/equatable.dart';
import '../../../appointments/dominio/entidades/cita_entidad.dart';

class ItemHistorialEntidad extends Equatable {
  const ItemHistorialEntidad({
    required this.cita,
    this.calificacion,
    this.comentario,
  });

  final CitaEntidad cita;
  final double? calificacion;
  final String? comentario;

  @override
  List<Object?> get props => [cita.id];
}
