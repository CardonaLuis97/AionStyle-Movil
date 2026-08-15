import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/colores.dart';
import '../../../auth/presentacion/proveedores/proveedores_auth.dart';

class PaginaQr extends ConsumerStatefulWidget {
  const PaginaQr({super.key});

  @override
  ConsumerState<PaginaQr> createState() => _PaginaQrState();
}

class _PaginaQrState extends ConsumerState<PaginaQr> {
  final MobileScannerController _controlador = MobileScannerController();
  bool _escaneado = false;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _onDeteccion(BarcodeCapture captura) {
    if (_escaneado) return;
    final codigo = captura.barcodes.firstOrNull?.rawValue;
    if (codigo == null) return;
    _escaneado = true;
    // TODO: enviar código a ViewModel para validación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR detectado: $codigo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final estadoAuth = ref.watch(viewModelAuthProvider);

    final usuario = estadoAuth.maybeWhen(
      autenticado: (usuario) => usuario,
      perfilIncompleto: (usuario) => usuario,
      orElse: () => null,
    );

    final correo = usuario?.correo.trim().toLowerCase() ?? '';
    final usuarioBloqueado = correo == 'usuarioa@aionstyle.com';
    final rolEscaner = (usuario?.esBarbero ?? false) || (usuario?.esDueno ?? false);
    final puedeEscanear = usuario != null && rolEscaner && !usuarioBloqueado;

    if (!puedeEscanear) {
      return Scaffold(
        appBar: AppBar(title: const Text('Escanear QR')),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: esquema.onSurfaceVariant.withValues(alpha: 0.35)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 42, color: esquema.onSurface),
                const SizedBox(height: 12),
                Text(
                  'No tienes permisos para escanear codigos QR.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  usuarioBloqueado
                      ? 'La cuenta usuarioa@aionstyle.com solo puede usar funciones de cliente.'
                      : 'Esta accion esta disponible para roles BARBERO o DUEÑO.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: esquema.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: _controlador.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: _controlador.switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controlador, onDetect: _onDeteccion),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: esquema.onSurface, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Apunta al código QR de la cita',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: esquema.onSurface,
                    fontSize: 16,
                  ) ??
                  const TextStyle(
                    color: ColoresApp.secundario,
                    fontSize: 16,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
