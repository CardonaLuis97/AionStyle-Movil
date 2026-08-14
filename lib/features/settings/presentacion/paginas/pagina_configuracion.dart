import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaConfiguracion extends ConsumerWidget {
  const PaginaConfiguracion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.notifications_outlined), title: Text('Notificaciones')),
          ListTile(leading: Icon(Icons.lock_outline), title: Text('Privacidad')),
          ListTile(leading: Icon(Icons.language), title: Text('Idioma')),
          ListTile(leading: Icon(Icons.dark_mode_outlined), title: Text('Tema')),
          Divider(),
          ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Cerrar sesión', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
