import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../../core/utils/ubicacion_obligatoria.dart';
import '../../dominio/entidades/tipo_documento.dart';
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
  final _documentoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  TipoDocumento _tipoDocumento = TipoDocumento.dni;
  bool _redirigiendoInicio = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _documentoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).registrar(
          nombreCompleto: _nombreCtrl.text.trim(),
          tipoDocumento: _tipoDocumento,
          numeroDocumento: _documentoCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim(),
          correo: _correoCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (_) async {
          if (_redirigiendoInicio) return;
          _redirigiendoInicio = true;
          final permitido = await exigirUbicacionAntesDeInicio(context);
          if (!mounted) return;
          if (permitido) {
            context.go(Rutas.inicio);
          }
          _redirigiendoInicio = false;
        },
        error: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
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
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre completo' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoDocumento>(
                  value: _tipoDocumento,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de documento',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: TipoDocumento.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.etiqueta),
                          ))
                      .toList(),
                  onChanged: (valor) {
                    if (valor != null) setState(() => _tipoDocumento = valor);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _documentoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Número de documento',
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu número de documento' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefonoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Número de celular',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu número de celular' : null,
                ),
                const SizedBox(height: 16),
                CampoEmail(controlador: _correoCtrl),
                const SizedBox(height: 16),
                CampoContrasena(controlador: _contrasenaCtrl),
                const SizedBox(height: 16),
                CampoContrasena(
                  controlador: _confirmarCtrl,
                  etiqueta: 'Confirmar contraseña',
                  validador: (v) => v != _contrasenaCtrl.text
                      ? 'Las contraseñas no coinciden'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: estado.maybeWhen(
                    cargando: () => null,
                    orElse: () => _registrar,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.primario,
                    foregroundColor: ColoresApp.secundario,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: estado.maybeWhen(
                    cargando: () => const CircularProgressIndicator(
                      color: ColoresApp.secundario,
                    ),
                    orElse: () => const Text('Crear cuenta'),
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
