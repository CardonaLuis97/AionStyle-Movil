import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';

class PaginaFavoritos extends ConsumerWidget {
  const PaginaFavoritos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritos = [
      (
        id: 'neg_001',
        nombre: 'Barberia Alpha',
        descripcion: 'Corte clasico y barba premium',
      ),
      (
        id: 'neg_002',
        nombre: 'Barberia Black',
        descripcion: 'Corte moderno y diseno de barba',
      ),
      (
        id: 'neg_003',
        nombre: 'Barberia Classic',
        descripcion: 'Corte ejecutivo y perfilado de barba',
      ),
    ];

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favoritos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final favorito = favoritos[index];
          return Card(
            elevation: 2,
            color: ColoresApp.terceario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: ColoresApp.dorado.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      decoration: const BoxDecoration(
                        color: ColoresApp.acento,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.favorite,
                        color: ColoresApp.dorado,
                      ),
                    ),
                    title: Text(
                      favorito.nombre,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: ColoresApp.primario,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    subtitle: Text(
                      favorito.descripcion,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColoresApp.texto,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed(
                          Rutas.nombreDetalleNegocio,
                          pathParameters: {'id': favorito.id},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.primario,
                        foregroundColor: ColoresApp.secundario,
                      ),
                      icon: const Icon(Icons.storefront_outlined),
                      label: const Text('Ver barberia'),
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
