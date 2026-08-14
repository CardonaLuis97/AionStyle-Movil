import 'package:flutter/material.dart';
import '../../../../core/extensions/extensiones.dart';

class CampoEmail extends StatelessWidget {
  const CampoEmail({super.key, required this.controlador});
  final TextEditingController controlador;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa tu correo';
        if (!v.esEmailValido) return 'Correo inválido';
        return null;
      },
    );
  }
}
