import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentacion/proveedores/proveedores_auth.dart';
import '../router/enrutador.dart';

class NavegacionPrincipal extends ConsumerWidget {
  const NavegacionPrincipal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAuth = ref.watch(viewModelAuthProvider);
    final mostrarQr = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario.correo.trim().toLowerCase() != 'usuarioa@aionstyle.com',
      perfilIncompleto: (usuario) => usuario.correo.trim().toLowerCase() != 'usuarioa@aionstyle.com',
      orElse: () => true,
    );

    final destinos = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Inicio',
      ),
      const NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined),
        selectedIcon: Icon(Icons.calendar_today),
        label: 'Citas',
      ),
      if (mostrarQr)
        const NavigationDestination(
          icon: Icon(Icons.qr_code_scanner),
          selectedIcon: Icon(Icons.qr_code_scanner),
          label: 'QR',
        ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual(context, mostrarQr),
        onDestinationSelected: (index) => _navegar(context, index, mostrarQr),
        destinations: destinos,
      ),
    );
  }

  int _indiceActual(BuildContext context, bool mostrarQr) {
    final ubicacion = GoRouterState.of(context).uri.path;
    if (ubicacion.startsWith(Rutas.citas)) return 1;
    if (ubicacion.startsWith(Rutas.qr)) {
      return mostrarQr ? 2 : 0;
    }
    if (ubicacion.startsWith(Rutas.perfil)) return mostrarQr ? 3 : 2;
    return 0;
  }

  void _navegar(BuildContext context, int index, bool mostrarQr) {
    final rutas = <String>[
      Rutas.inicio,
      Rutas.citas,
      if (mostrarQr) Rutas.qr,
      Rutas.perfil,
    ];

    if (index < 0 || index >= rutas.length) {
      context.go(Rutas.inicio);
      return;
    }

    context.go(rutas[index]);
  }
}
