import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaConfiguracion extends ConsumerWidget {
  const PaginaConfiguracion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          const ListTile(leading: Icon(Icons.notifications_outlined), title: Text('Notificaciones')),
          const ListTile(leading: Icon(Icons.lock_outline), title: Text('Privacidad')),
          const ListTile(leading: Icon(Icons.language), title: Text('Idioma')),
          const ListTile(leading: Icon(Icons.dark_mode_outlined), title: Text('Tema')),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: esquema.error),
            title: Text(
              'Cerrar sesión',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: esquema.error),
            ),
          ),
        ],
      ),
    );
  }
}
