import 'package:flutter/material.dart';
import '../../app/theme/colores.dart';

/// Vista de error reutilizable con botón de reintento.
class VistaError extends StatelessWidget {
  const VistaError({super.key, required this.mensaje, this.onReintentar});
  final String mensaje;
  final VoidCallback? onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: ColoresApp.error),
            const SizedBox(height: 16),
            Text(
              mensaje,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onReintentar != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
