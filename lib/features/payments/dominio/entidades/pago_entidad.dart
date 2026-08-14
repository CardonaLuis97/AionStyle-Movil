import 'package:equatable/equatable.dart';

enum EstadoPago { pendiente, procesando, completado, fallido, reembolsado }

class PagoEntidad extends Equatable {
  const PagoEntidad({
    required this.id,
    required this.citaId,
    required this.monto,
    required this.estado,
    this.metodoPago,
    this.fechaPago,
    this.stripePaymentIntentId,
  });

  final String id;
  final String citaId;
  final double monto;
  final EstadoPago estado;
  final String? metodoPago;
  final DateTime? fechaPago;
  final String? stripePaymentIntentId;

  @override
  List<Object?> get props => [id, citaId, monto, estado];
}
