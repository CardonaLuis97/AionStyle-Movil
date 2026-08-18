import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../../core/utils/ubicacion_obligatoria.dart';
import '../../dominio/entidades/tipo_documento.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';

class PaginaCompletarPerfil extends ConsumerStatefulWidget {
  const PaginaCompletarPerfil({super.key});

  @override
  ConsumerState<PaginaCompletarPerfil> createState() =>
      _PaginaCompletarPerfilState();
}

class _PaginaCompletarPerfilState
    extends ConsumerState<PaginaCompletarPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  TipoDocumento _tipoDocumento = TipoDocumento.dni;
  bool _redirigiendoInicio = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _documentoCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  Future<void> _completar() async {
    if (!_formKey.currentState!.validate()) return;
    final estado = ref.read(viewModelAuthProvider);
    final usuarioId = estado.maybeWhen(
      perfilIncompleto: (u) => u.id,
      orElse: () => '',
    );
    await ref.read(viewModelAuthProvider.notifier).completarPerfil(
          usuarioId: usuarioId,
          nombreCompleto: _nombreCtrl.text.trim(),
          tipoDocumento: _tipoDocumento,
          numeroDocumento: _documentoCtrl.text.trim(),
          telefono: _telefonoCtrl.text.trim(),
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
      backgroundColor: ColoresApp.secundario,
      appBar: AppBar(
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Solo necesitamos un poco más de información',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColoresApp.terceario,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: estado.maybeWhen(
                    cargando: () => null,
                    orElse: () => _completar,
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
                    orElse: () => const Text('Continuar'),
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
