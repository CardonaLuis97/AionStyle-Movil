import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';

class PaginaCambiarContrasena extends ConsumerStatefulWidget {
  const PaginaCambiarContrasena({super.key});

  @override
  ConsumerState<PaginaCambiarContrasena> createState() =>
      _PaginaCambiarContrasenaState();
}

class _PaginaCambiarContrasenaState
    extends ConsumerState<PaginaCambiarContrasena> {
  final _formularioKey = GlobalKey<FormState>();
  final _actualCtrl = TextEditingController();
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  void _actualizarContrasena() {
    if (!_formularioKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contrasena actualizada (demo).')),
    );
    Navigator.of(context).pop();
  }

  void _recordarContrasena() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColoresApp.terceario,
        title: const Text('Recuperar contrasena'),
        content: const Text(
          'Te enviaremos un correo electronico con instrucciones para '
          'restablecer tu contrasena.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoresApp.primario,
              foregroundColor: ColoresApp.secundario,
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Cambiar contrasena'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: ColoresApp.dorado.withValues(alpha: 0.24),
                hintStyle: const TextStyle(
                  color: ColoresApp.textoClaro,
                  fontSize: 12,
                ),
                labelStyle: const TextStyle(
                  color: ColoresApp.primario,
                  fontSize: 13,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: ColoresApp.primario.withValues(alpha: 0.55),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColoresApp.primario,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            child: Form(
              key: _formularioKey,
              child: Card(
                color: ColoresApp.terceario,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                      color: ColoresApp.dorado.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Actualiza tu clave para mantener tu cuenta segura.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  ColoresApp.primario.withValues(alpha: 0.74),
                            ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _actualCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Coloca la contrasena actual',
                          hintText: '********',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: ColoresApp.primario,
                          ),
                        ),
                        obscureText: true,
                        validator: (valor) => (valor == null || valor.isEmpty)
                            ? 'Coloca la contrasena actual'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nuevaCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Contrasena nueva',
                          hintText: 'Minimo 8 caracteres',
                          prefixIcon: Icon(
                            Icons.lock_reset_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        obscureText: true,
                        validator: (valor) {
                          if (valor == null || valor.length < 8) {
                            return 'La contrasena debe tener al menos 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmarCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Repetir contrasena nueva',
                          hintText: '********',
                          prefixIcon: Icon(
                            Icons.verified_user_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        obscureText: true,
                        validator: (valor) {
                          if (valor != _nuevaCtrl.text) {
                            return 'Las contrasenas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _recordarContrasena,
                          style: TextButton.styleFrom(
                            foregroundColor: ColoresApp.primario,
                          ),
                          child: const Text('No te acuerdas de tu contrasena?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _actualizarContrasena,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.primario,
                          foregroundColor: ColoresApp.secundario,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Actualizar contrasena'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
