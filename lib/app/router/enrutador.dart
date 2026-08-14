import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentacion/paginas/pagina_login.dart';
import '../../features/auth/presentacion/paginas/pagina_registro.dart';
import '../../features/auth/presentacion/paginas/pagina_completar_perfil.dart';
import '../../features/home/presentacion/paginas/pagina_inicio.dart';
import '../../features/appointments/presentacion/paginas/pagina_citas.dart';
import '../../features/appointments/presentacion/paginas/pagina_agendar_cita.dart';
import '../../features/appointments/presentacion/paginas/pagina_confirmacion_cita.dart';
import '../../features/profile/presentacion/paginas/pagina_perfil.dart';
import '../../features/barbers/presentacion/paginas/pagina_barberos.dart';
import '../../features/businesses/presentacion/paginas/pagina_negocios.dart';
import '../../features/businesses/presentacion/paginas/pagina_detalle_negocio.dart';
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
  static const completarPerfil = '/completar-perfil';
  static const inicio = '/inicio';
  static const citas = '/citas';
  static const agendarCita = '/agendar-cita';
  static const confirmacionCita = '/confirmacion-cita';
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
      GoRoute(
        path: Rutas.completarPerfil,
        builder: (context, state) => const PaginaCompletarPerfil(),
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
            builder: (context, state) {
              final p = state.uri.queryParameters;
              return PaginaCitas(
                negocioNombre: p['negocio'],
                barberoNombre: p['barbero'],
                corte: p['corte'],
                precio: double.tryParse(p['precio'] ?? ''),
                fecha: p['fecha'],
                hora: p['hora'],
                metodoPago: p['pago'],
                codigoQr: p['qr'],
              );
            },
          ),
          GoRoute(
            path: Rutas.agendarCita,
            builder: (context, state) {
              final negocio = state.uri.queryParameters['negocio'] ?? 'Negocio';
              final barbero = state.uri.queryParameters['barbero'] ?? 'Barbero';
              final especialidadesCadena =
                  state.uri.queryParameters['especialidades'] ?? '';
              final especialidades = especialidadesCadena.isEmpty
                  ? <String>[]
                  : especialidadesCadena.split('|');
              return PaginaAgendarCita(
                negocioNombre: negocio,
                barberoNombre: barbero,
                especialidades: especialidades,
              );
            },
          ),
          GoRoute(
            path: Rutas.confirmacionCita,
            builder: (context, state) {
              final p = state.uri.queryParameters;
              final precio = double.tryParse(p['precio'] ?? '') ?? 0;
              return PaginaConfirmacionCita(
                negocioNombre: p['negocio'] ?? 'Negocio',
                barberoNombre: p['barbero'] ?? 'Barbero',
                corte: p['corte'] ?? 'Corte',
                precio: precio,
                fecha: p['fecha'] ?? 'Sin fecha',
                hora: p['hora'] ?? 'Sin hora',
                metodoPago: p['pago'] ?? 'Efectivo',
                codigoQr: p['qr'] ?? 'AIONSTYLE|SIN_QR',
              );
            },
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
            path: '${Rutas.negocios}/:id',
            builder: (context, state) => PaginaDetalleNegocio(
              negocioId: state.pathParameters['id'] ?? '',
            ),
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
