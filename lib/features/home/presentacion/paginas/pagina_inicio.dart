import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';
import '../../../businesses/presentacion/widgets/vista_negocios.dart';
import '../../../../app/theme/colores.dart';

class PaginaInicio extends ConsumerWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAuth = ref.watch(viewModelAuthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Column(
        children: [
          estadoAuth.maybeWhen(
            autenticado: (usuario) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColoresApp.secundario,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColoresApp.terceario.withValues(alpha: 0.2),
                  ),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: usuario.roles
                      .map(
                        (rol) => Chip(
                          backgroundColor: ColoresApp.primario,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: ColoresApp.secundario),
                          label: Text(rol.nombre),
                        ),
                      )
                      .toList(),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const Expanded(
            child: VistaNegocios(
              titulo: 'Descubre negocios cerca de ti',
              mostrarEncabezado: true,
            ),
          ),
        ],
      ),
    );
  }
}
