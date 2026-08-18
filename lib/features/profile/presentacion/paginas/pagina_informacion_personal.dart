import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';

class PaginaInformacionPersonal extends ConsumerStatefulWidget {
  const PaginaInformacionPersonal({super.key});

  @override
  ConsumerState<PaginaInformacionPersonal> createState() =>
      _PaginaInformacionPersonalState();
}

class _PaginaInformacionPersonalState
    extends ConsumerState<PaginaInformacionPersonal> {
  final _formularioKey = GlobalKey<FormState>();
  bool _modoEdicion = false;

  final _nombreCtrl = TextEditingController(text: 'Luis Garcia');
  final _documentoCtrl = TextEditingController(text: '78451236');
  final _telefonoCtrl = TextEditingController(text: '+51 987 654 321');
  final _correoCtrl = TextEditingController(text: 'cliente@aionstyle.com');

  String _tipoDocumento = 'DNI';

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _documentoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    if (!_formularioKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informacion personal actualizada (demo).'),
      ),
    );
    setState(() => _modoEdicion = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Informacion personal'),
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
                        'Datos del cliente',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: ColoresApp.primario,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nombreCtrl,
                        readOnly: !_modoEdicion,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: ColoresApp.primario,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Ingresa tu nombre completo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _tipoDocumento,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de documento',
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'DNI', child: Text('DNI')),
                          DropdownMenuItem(
                            value: 'Carnet',
                            child: Text('Certificado de nacimiento'),
                          ),
                        ],
                        onChanged: !_modoEdicion
                            ? null
                            : (valor) {
                                if (valor != null) {
                                  setState(() => _tipoDocumento = valor);
                                }
                              },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _documentoCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Numero de documento',
                          helperText: 'Este dato no se puede editar.',
                          prefixIcon: Icon(
                            Icons.numbers_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefonoCtrl,
                        readOnly: !_modoEdicion,
                        decoration: const InputDecoration(
                          labelText: 'Numero de celular',
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Ingresa tu numero de celular';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _correoCtrl,
                        readOnly: !_modoEdicion,
                        decoration: const InputDecoration(
                          labelText: 'Correo electronico',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: ColoresApp.primario,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (valor) {
                          if (valor == null || !valor.contains('@')) {
                            return 'Ingresa un correo valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: _modoEdicion
                            ? _guardarCambios
                            : () => setState(() => _modoEdicion = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.primario,
                          foregroundColor: ColoresApp.secundario,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            Text(_modoEdicion ? 'Guardar cambios' : 'Editar'),
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
