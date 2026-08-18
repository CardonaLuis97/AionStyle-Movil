import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';

class PaginaPoliticasCondiciones extends ConsumerWidget {
  const PaginaPoliticasCondiciones({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politicas y condiciones'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Resumen legal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColoresApp.primario,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const Text(
            '1. Uso de la app: AionStyle permite reservar servicios en barberias y salones afiliados.\n\n'
            '2. Privacidad: tus datos personales se usan solo para autenticacion, reservas y soporte.\n\n'
            '3. Pagos: los cobros pueden realizarse por tarjeta o efectivo segun disponibilidad del negocio.\n\n'
            '4. Cancelaciones: cada negocio puede definir ventanas y cargos de cancelacion.',
            style: TextStyle(height: 1.5),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrir version completa (demo).')),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ver documento completo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColoresApp.primario,
              side: const BorderSide(color: ColoresApp.primario),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
