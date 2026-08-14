import 'package:equatable/equatable.dart';

class ReciboEntidad extends Equatable {
  const ReciboEntidad({
    required this.id,
    required this.citaId,
    required this.pagoId,
    required this.total,
    required this.fechaEmision,
    this.detalles = const [],
  });

  final String id;
  final String citaId;
  final String pagoId;
  final double total;
  final DateTime fechaEmision;
  final List<String> detalles;

  @override
  List<Object?> get props => [id, citaId, pagoId];
}
