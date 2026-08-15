import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

class PaginaPerfil extends ConsumerWidget {
  const PaginaPerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Center(
                child: Text('Perfil de usuario — en construcción'),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(viewModelAuthProvider.notifier).cerrarSesion();
                if (context.mounted) {
                  context.go(Rutas.login);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: esquema.error,
                foregroundColor: esquema.onError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
