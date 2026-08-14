import 'package:flutter/material.dart';

class CampoContrasena extends StatefulWidget {
  const CampoContrasena({super.key, required this.controlador, this.etiqueta = 'Contraseña'});
  final TextEditingController controlador;
  final String etiqueta;

  @override
  State<CampoContrasena> createState() => _CampoContrasenaState();
}

class _CampoContrasenaState extends State<CampoContrasena> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      obscureText: _oculto,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_oculto ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _oculto = !_oculto),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
        if (v.length < 8) return 'Mínimo 8 caracteres';
        return null;
      },
    );
  }
}
