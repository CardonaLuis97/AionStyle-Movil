import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentacion/paginas/pagina_login.dart';
import '../../features/auth/presentacion/paginas/pagina_registro.dart';
import '../../features/home/presentacion/paginas/pagina_inicio.dart';
import '../../features/appointments/presentacion/paginas/pagina_citas.dart';
import '../../features/profile/presentacion/paginas/pagina_perfil.dart';
import '../../features/barbers/presentacion/paginas/pagina_barberos.dart';
import '../../features/businesses/presentacion/paginas/pagina_negocios.dart';
import '../../features/payments/presentacion/paginas/pagina_pagos.dart';
import '../../features/qr/presentacion/paginas/pagina_qr.dart';
import '../../features/settings/presentacion/paginas/pagina_configuracion.dart';
import '../../features/barber_mode/presentacion/paginas/pagina_modo_barbero.dart';
import '../../features/owner_mode/presentacion/paginas/pagina_modo_propietario.dart';
import '../widgets/navegacion_principal.dart';

// Rutas nombradas
abstract class Rutas {
  static const splash = '/';
  static const login = '/login';
  static const registro = '/registro';
  static const inicio = '/inicio';
  static const citas = '/citas';
  static const perfil = '/perfil';
  static const barberos = '/barberos';
  static const negocios = '/negocios';
  static const pagos = '/pagos';
  static const qr = '/qr';
  static const configuracion = '/configuracion';
  static const modoBarbero = '/modo-barbero';
  static const modoPropietario = '/modo-propietario';
}

final enrutadorProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Rutas.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Rutas.login,
        builder: (context, state) => const PaginaLogin(),
      ),
      GoRoute(
        path: Rutas.registro,
        builder: (context, state) => const PaginaRegistro(),
      ),
      ShellRoute(
        builder: (context, state, child) => NavegacionPrincipal(child: child),
        routes: [
          GoRoute(
            path: Rutas.inicio,
            builder: (context, state) => const PaginaInicio(),
          ),
          GoRoute(
            path: Rutas.citas,
            builder: (context, state) => const PaginaCitas(),
          ),
          GoRoute(
            path: Rutas.perfil,
            builder: (context, state) => const PaginaPerfil(),
          ),
          GoRoute(
            path: Rutas.barberos,
            builder: (context, state) => const PaginaBarberos(),
          ),
          GoRoute(
            path: Rutas.negocios,
            builder: (context, state) => const PaginaNegocios(),
          ),
          GoRoute(
            path: Rutas.pagos,
            builder: (context, state) => const PaginaPagos(),
          ),
          GoRoute(
            path: Rutas.qr,
            builder: (context, state) => const PaginaQr(),
          ),
          GoRoute(
            path: Rutas.configuracion,
            builder: (context, state) => const PaginaConfiguracion(),
          ),
          GoRoute(
            path: Rutas.modoBarbero,
            builder: (context, state) => const PaginaModoBarbero(),
          ),
          GoRoute(
            path: Rutas.modoPropietario,
            builder: (context, state) => const PaginaModoPropietario(),
          ),
        ],
      ),
    ],
  );
});
