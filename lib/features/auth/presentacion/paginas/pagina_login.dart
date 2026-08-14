import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../core/extensions/extensiones.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';
import '../widgets/campo_email.dart';
import '../widgets/campo_contrasena.dart';
import '../widgets/boton_google.dart';

class PaginaLogin extends ConsumerStatefulWidget {
  const PaginaLogin({super.key});

  @override
  ConsumerState<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends ConsumerState<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).iniciarSesion(
          email: _emailCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      if (siguiente is _Autenticado) context.go(Rutas.inicio);
      if (siguiente is _Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((siguiente as dynamic).mensaje as String)),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'AionStyle',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión en tu cuenta',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CampoEmail(controlador: _emailCtrl),
                const SizedBox(height: 16),
                CampoContrasena(controlador: _contrasenaCtrl),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: estado is _Cargando ? null : _iniciarSesion,
                  child: estado is _Cargando
                      ? const CircularProgressIndicator()
                      : const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 16),
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('o')), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                BotonGoogle(
                  onPresionado: estado is _Cargando
                      ? null
                      : () => ref.read(viewModelAuthProvider.notifier).iniciarSesionGoogle(),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => context.push(Rutas.registro),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
typedef _Autenticado = Object;
// ignore: unused_element
typedef _Cargando = Object;
// ignore: unused_element
typedef _Error = Object;
