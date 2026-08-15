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
              final esUsuarioDemoCliente =
                  usuario.correo.trim().toLowerCase() ==
                      'usuarioa@aionstyle.com';
              final rolPrincipal = esUsuarioDemoCliente
                  ? 'CLIENTE'
                  : (usuario.roles.isNotEmpty
                      ? usuario.roles.first.nombre
                      : 'CLIENTE');

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ColoresApp.fondo,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: ColoresApp.acento.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ColoresApp.acento.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        color: ColoresApp.acento,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario.correo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: ColoresApp.texto,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            usuario.nombreCompleto,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColoresApp.textoClaro,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresApp.primario,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        rolPrincipal,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: ColoresApp.secundario,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ),
                  ],
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
