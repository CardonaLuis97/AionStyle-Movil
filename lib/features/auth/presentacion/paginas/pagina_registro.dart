import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';
import '../widgets/campo_email.dart';
import '../widgets/campo_contrasena.dart';

class PaginaRegistro extends ConsumerStatefulWidget {
  const PaginaRegistro({super.key});

  @override
  ConsumerState<PaginaRegistro> createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends ConsumerState<PaginaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrarse() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).registrarse(
          nombre: _nombreCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (_) => context.go(Rutas.inicio),
        error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                CampoEmail(controlador: _emailCtrl),
                const SizedBox(height: 16),
                CampoContrasena(controlador: _contrasenaCtrl),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: estado.maybeWhen(cargando: () => null, orElse: () => _registrarse),
                  child: estado.maybeWhen(
                    cargando: () => const CircularProgressIndicator(),
                    orElse: () => const Text('Registrarse'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
