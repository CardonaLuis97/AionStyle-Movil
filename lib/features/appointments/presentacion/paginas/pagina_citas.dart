import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';
import '../widgets/factura_cita_widget.dart';

enum FiltroCitas { pendientes, historial }

class PaginaCitas extends ConsumerStatefulWidget {
  const PaginaCitas({
    super.key,
    this.negocioNombre,
    this.barberoNombre,
    this.corte,
    this.precio,
    this.fecha,
    this.hora,
    this.metodoPago,
    this.codigoQr,
  });

  final String? negocioNombre;
  final String? barberoNombre;
  final String? corte;
  final double? precio;
  final String? fecha;
  final String? hora;
  final String? metodoPago;
  final String? codigoQr;

  @override
  ConsumerState<PaginaCitas> createState() => _PaginaCitasState();
}

class _PaginaCitasState extends ConsumerState<PaginaCitas> {
  FiltroCitas _filtro = FiltroCitas.pendientes;

  bool get _tieneFactura {
    return widget.negocioNombre != null &&
        widget.barberoNombre != null &&
        widget.corte != null &&
        widget.precio != null &&
        widget.fecha != null &&
        widget.hora != null &&
        widget.metodoPago != null &&
        widget.codigoQr != null;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Citas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Pendientes',
                  activo: _filtro == FiltroCitas.pendientes,
                  onTap: () => setState(() => _filtro = FiltroCitas.pendientes),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BotonFiltro(
                  titulo: 'Historial',
                  activo: _filtro == FiltroCitas.historial,
                  onTap: () => setState(() => _filtro = FiltroCitas.historial),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!_tieneFactura)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColoresApp.secundario,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
              ),
              child: Text(
                _filtro == FiltroCitas.pendientes
                    ? 'No tienes citas pendientes por ahora.'
                    : 'Aun no hay citas en historial.',
                style: tema.textTheme.bodyMedium?.copyWith(color: ColoresApp.textoClaro),
              ),
            )
          else
            FacturaCitaWidget(
              negocioNombre: widget.negocioNombre!,
              barberoNombre: widget.barberoNombre!,
              corte: widget.corte!,
              precio: widget.precio!,
              fecha: widget.fecha!,
              hora: widget.hora!,
              metodoPago: widget.metodoPago!,
              codigoQr: widget.codigoQr!,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nueva cita'),
      ),
    );
  }
}

class _BotonFiltro extends StatelessWidget {
  const _BotonFiltro({
    required this.titulo,
    required this.activo,
    required this.onTap,
  });

  final String titulo;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Material(
      color: activo ? ColoresApp.primario : ColoresApp.secundario,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              titulo,
              style: tema.textTheme.labelLarge?.copyWith(
                color: activo ? ColoresApp.secundario : ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
