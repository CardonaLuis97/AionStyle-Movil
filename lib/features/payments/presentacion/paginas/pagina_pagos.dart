import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';

class PaginaPagos extends ConsumerWidget {
  const PaginaPagos({super.key});

  void _mostrarAccion(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarjetas = [
      ('Visa', '**** **** **** 4242', '12/29'),
      ('Mastercard', null, null),
      ('American Express', null, null),
    ];

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Metodos de pago'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tarjetas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tarjeta = tarjetas[index];
          final tieneDatos = tarjeta.$2 != null && tarjeta.$3 != null;
          return Card(
            elevation: 2,
            color: ColoresApp.terceario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side:
                  BorderSide(color: ColoresApp.dorado.withValues(alpha: 0.55)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: ColoresApp.primario,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.credit_card,
                          color: ColoresApp.secundario,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tarjeta.$1,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: ColoresApp.primario,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              tieneDatos
                                  ? '${tarjeta.$2}  ·  Vence ${tarjeta.$3}'
                                  : 'Sin datos guardados',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColoresApp.primario
                                        .withValues(alpha: 0.74),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (tieneDatos)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _mostrarAccion(
                              context,
                              'Editar tarjeta ${tarjeta.$2} (demo).',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ColoresApp.primario,
                              side:
                                  const BorderSide(color: ColoresApp.primario),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _mostrarAccion(
                              context,
                              'Eliminar tarjeta ${tarjeta.$2} (demo).',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.error,
                              foregroundColor: ColoresApp.secundario,
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _mostrarAccion(
                          context,
                          'Anadir nueva tarjeta a ${tarjeta.$1} (demo).',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.primario,
                          foregroundColor: ColoresApp.secundario,
                        ),
                        child: const Text('Anadir'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
