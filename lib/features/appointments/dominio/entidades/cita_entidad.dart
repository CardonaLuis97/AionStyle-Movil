import 'package:equatable/equatable.dart';

enum EstadoCita { pendiente, confirmada, enCurso, completada, cancelada }

class CitaEntidad extends Equatable {
  const CitaEntidad({
    required this.id,
    required this.usuarioId,
    required this.barberoId,
    required this.negocioId,
    required this.servicioId,
    required this.fechaHora,
    required this.estado,
    this.precio,
    this.notas,
  });

  final String id;
  final String usuarioId;
  final String barberoId;
  final String negocioId;
  final String servicioId;
  final DateTime fechaHora;
  final EstadoCita estado;
  final double? precio;
  final String? notas;

  bool get esCancelable =>
      estado == EstadoCita.pendiente || estado == EstadoCita.confirmada;

  @override
  List<Object?> get props => [id, usuarioId, barberoId, fechaHora, estado];
}
