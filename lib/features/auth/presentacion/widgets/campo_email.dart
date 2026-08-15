import 'package:flutter/material.dart';
import '../../../../core/extensions/extensiones.dart';

class CampoEmail extends StatelessWidget {
  const CampoEmail({
    super.key,
    required this.controlador,
    this.mostrarIcono = true,
  });
  final TextEditingController controlador;
  final bool mostrarIcono;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: mostrarIcono ? const Icon(Icons.email_outlined) : null,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa tu correo';
        if (!v.esEmailValido) return 'Correo inválido';
        return null;
      },
    );
  }
}
