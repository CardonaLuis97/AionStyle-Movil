import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/colores.dart';

class LogoAionStyle extends StatelessWidget {
  const LogoAionStyle({
    super.key,
    this.ancho,
    this.alto,
    this.ajuste = BoxFit.contain,
    this.borde,
  });

  final double? ancho;
  final double? alto;
  final BoxFit ajuste;
  final BorderRadius? borde;

  static const _rutaLogo = 'assets/images/logo.png';
  static final Future<bool> _disponibilidadLogo = _verificarLogo();

  static Future<bool> _verificarLogo() async {
    try {
      final manifiesto = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifiesto.listAssets().contains(_rutaLogo);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _disponibilidadLogo,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          final imagen = Image.asset(
            _rutaLogo,
            width: ancho,
            height: alto,
            fit: ajuste,
          );

          if (borde == null) return imagen;
          return ClipRRect(
            borderRadius: borde!,
            child: imagen,
          );
        }

        return _fallback(context);
      },
    );
  }

  Widget _fallback(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      width: ancho,
      height: alto,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: borde ?? BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final espacioReducido = constraints.maxWidth < 92;

          if (espacioReducido) {
            return const Center(
              child: Icon(Icons.content_cut, color: ColoresApp.dorado, size: 14),
            );
          }

          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.content_cut, color: ColoresApp.dorado, size: 14),
                const SizedBox(width: 6),
                Text(
                  'AionStyle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.labelSmall?.copyWith(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}