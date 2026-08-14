import 'package:flutter/material.dart';

class BotonGoogle extends StatelessWidget {
  const BotonGoogle({super.key, this.onPresionado});
  final VoidCallback? onPresionado;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPresionado,
      icon: Image.asset('assets/icons/google.png', height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata)),
      label: const Text('Continuar con Google'),
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
    );
  }
}
