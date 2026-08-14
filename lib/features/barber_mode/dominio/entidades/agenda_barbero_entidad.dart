import 'package:equatable/equatable.dart';
import '../../../appointments/dominio/entidades/cita_entidad.dart';

class AgendaBarberoEntidad extends Equatable {
  const AgendaBarberoEntidad({
    required this.barberoId,
    required this.citasHoy,
    required this.citasPendientes,
  });

  final String barberoId;
  final List<CitaEntidad> citasHoy;
  final List<CitaEntidad> citasPendientes;

  int get totalCitasHoy => citasHoy.length;

  @override
  List<Object?> get props => [barberoId];
}
