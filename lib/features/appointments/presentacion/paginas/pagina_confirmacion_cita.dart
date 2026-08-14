import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';

class PaginaConfirmacionCita extends StatefulWidget {
  const PaginaConfirmacionCita({
    super.key,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.corte,
    required this.precio,
    required this.fecha,
    required this.hora,
    required this.metodoPago,
  });

  final String negocioNombre;
  final String barberoNombre;
  final String corte;
  final double precio;
  final String fecha;
  final String hora;
  final String metodoPago;

  @override
  State<PaginaConfirmacionCita> createState() => _PaginaConfirmacionCitaState();
}

class _PaginaConfirmacionCitaState extends State<PaginaConfirmacionCita> {
  Timer? _temporizador;
  int _segundos = 6;

  String get _codigoQr {
    final marca = DateTime.now().millisecondsSinceEpoch.toString();
    return 'AIONSTYLE|$marca|${widget.negocioNombre}|${widget.barberoNombre}|${widget.corte}|${widget.fecha}|${widget.hora}|${widget.precio.toStringAsFixed(2)}';
  }

  @override
  void initState() {
    super.initState();
    _temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_segundos <= 1) {
        timer.cancel();
        context.go(Rutas.citas);
        return;
      }
      setState(() {
        _segundos -= 1;
      });
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cita confirmada')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColoresApp.secundario,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen de tu cita',
                  style: tema.textTheme.titleSmall?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _linea('Negocio', widget.negocioNombre),
                _linea('Barbero', widget.barberoNombre),
                _linea('Corte', widget.corte),
                _linea('Precio', 'USD ${widget.precio.toStringAsFixed(2)}'),
                _linea('Fecha', widget.fecha),
                _linea('Hora', widget.hora),
                _linea('Pago', widget.metodoPago),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColoresApp.secundario,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'Codigo QR de la cita',
                  style: tema.textTheme.titleSmall?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                QrImageView(
                  data: _codigoQr,
                  size: 220,
                  eyeStyle: const QrEyeStyle(
                    color: ColoresApp.primario,
                    eyeShape: QrEyeShape.square,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: ColoresApp.primario,
                    dataModuleShape: QrDataModuleShape.square,
                  ),
                  backgroundColor: ColoresApp.secundario,
                ),
                const SizedBox(height: 10),
                Text(
                  'Seras redirigido a Mis Citas en $_segundos s',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.textoClaro,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(Rutas.citas),
                  child: const Text('Ir ahora'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linea(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColoresApp.texto,
                fontSize: 11,
              ),
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}
