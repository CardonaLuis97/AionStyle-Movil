import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
                border: Border.all(color: Colors.white, width: 3),
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
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
