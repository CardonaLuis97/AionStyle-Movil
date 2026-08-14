import 'package:equatable/equatable.dart';
import '../../../businesses/dominio/entidades/negocio_entidad.dart';
import '../../../appointments/dominio/entidades/cita_entidad.dart';

class ResumenPropietarioEntidad extends Equatable {
  const ResumenPropietarioEntidad({
    required this.negocio,
    required this.citasHoy,
    required this.ingresosHoy,
    required this.ingresosMes,
    required this.totalBarberos,
  });

  final NegocioEntidad negocio;
  final List<CitaEntidad> citasHoy;
  final double ingresosHoy;
  final double ingresosMes;
  final int totalBarberos;

  @override
  List<Object?> get props => [negocio.id];
}
