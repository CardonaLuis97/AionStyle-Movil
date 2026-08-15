import 'package:flutter/material.dart';

import '../../../../app/theme/colores.dart';

class BotonGoogle extends StatelessWidget {
  const BotonGoogle({super.key, this.onPresionado});
  final VoidCallback? onPresionado;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPresionado,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        side: const BorderSide(color: ColoresApp.primario, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        'Continuar con Google',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: ColoresApp.primario,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
