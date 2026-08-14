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

  Future<void> _loginConCorreo() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).loginConCorreo(
          correo: _emailCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (_) => context.go(Rutas.inicio),
        perfilIncompleto: (_) => context.go(Rutas.completarPerfil),
        error: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
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
                  onPressed: estado.maybeWhen(
                    cargando: () => null,
                    orElse: () => _loginConCorreo,
                  ),
                  child: estado.maybeWhen(
                    cargando: () => const CircularProgressIndicator(),
                    orElse: () => const Text('Iniciar sesión'),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('o')), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                BotonGoogle(
                  onPresionado: estado.maybeWhen(
                    cargando: () => null,
                    orElse: () => () => ref
                        .read(viewModelAuthProvider.notifier)
                        .loginConGoogle(),
                  ),
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
