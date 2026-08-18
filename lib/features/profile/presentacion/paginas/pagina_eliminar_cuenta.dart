import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/colores.dart';

class PaginaEliminarCuenta extends ConsumerStatefulWidget {
  const PaginaEliminarCuenta({super.key});

  @override
  ConsumerState<PaginaEliminarCuenta> createState() =>
      _PaginaEliminarCuentaState();
}

class _PaginaEliminarCuentaState extends ConsumerState<PaginaEliminarCuenta> {
  final _nombreCtrl = TextEditingController(text: 'Luis Garcia');
  final _documentoCtrl = TextEditingController(text: '78451236');
  final _telefonoCtrl = TextEditingController(text: '+51 987 654 321');
  final _correoCtrl = TextEditingController(text: 'cliente@aionstyle.com');

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _documentoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmarEliminacion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _DialogoConfirmarEliminacion(),
    );

    if (confirmar == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud de eliminacion enviada (demo).'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Eliminar cuenta'),
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
            child: Card(
              elevation: 2,
              color: ColoresApp.terceario,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side:
                    BorderSide(color: ColoresApp.dorado.withValues(alpha: 0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Confirma tus datos antes de eliminar tu cuenta',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColoresApp.primario,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _nombreCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _documentoCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Numero de documento',
                        prefixIcon: Icon(
                          Icons.numbers_outlined,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Numero de celular',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _correoCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Correo electronico',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ColoresApp.primario,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _confirmarEliminacion(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Solicitar eliminacion de cuenta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.error,
                        foregroundColor: ColoresApp.secundario,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogoConfirmarEliminacion extends StatefulWidget {
  const _DialogoConfirmarEliminacion();

  @override
  State<_DialogoConfirmarEliminacion> createState() =>
      _DialogoConfirmarEliminacionState();
}

class _DialogoConfirmarEliminacionState
    extends State<_DialogoConfirmarEliminacion> {
  static const int _tiempoEspera = 20;
  late int _segundosRestantes;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = _tiempoEspera;
    _temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_segundosRestantes == 0) {
        timer.cancel();
        return;
      }
      setState(() => _segundosRestantes--);
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloqueoActivo = _segundosRestantes > 0;
    return AlertDialog(
      backgroundColor: ColoresApp.terceario,
      title: const Text('Eliminar cuenta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estas seguro de eliminar la cuenta?\n\n'
            'Esta accion deshabilitara tu cuenta por 30 dias. Durante este plazo '
            'puedes ingresar para reactivarla. Despues de ese plazo, tus datos '
            'se eliminaran completamente.',
          ),
          const SizedBox(height: 12),
          Text(
            bloqueoActivo
                ? 'Podras confirmar en $_segundosRestantes s'
                : 'Ya puedes confirmar la eliminacion.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColoresApp.error,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: ColoresApp.primario),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed:
              bloqueoActivo ? null : () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoresApp.error,
            foregroundColor: ColoresApp.secundario,
          ),
          child: Text(
            bloqueoActivo ? 'Confirmar ($_segundosRestantes)' : 'Confirmar',
          ),
        ),
      ],
    );
  }
}
