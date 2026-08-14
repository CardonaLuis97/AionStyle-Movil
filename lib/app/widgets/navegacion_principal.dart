import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/enrutador.dart';

class NavegacionPrincipal extends StatelessWidget {
  const NavegacionPrincipal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual(context),
        onDestinationSelected: (index) => _navegar(context, index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Citas'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), selectedIcon: Icon(Icons.qr_code_scanner), label: 'QR'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  int _indiceActual(BuildContext context) {
    final ubicacion = GoRouterState.of(context).uri.path;
    if (ubicacion.startsWith(Rutas.citas)) return 1;
    if (ubicacion.startsWith(Rutas.qr)) return 2;
    if (ubicacion.startsWith(Rutas.perfil)) return 3;
    return 0;
  }

  void _navegar(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(Rutas.inicio);
      case 1: context.go(Rutas.citas);
      case 2: context.go(Rutas.qr);
      case 3: context.go(Rutas.perfil);
    }
  }
}
