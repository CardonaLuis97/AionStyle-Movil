import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/vista_negocios.dart';

class PaginaNegocios extends ConsumerWidget {
  const PaginaNegocios({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negocios')),
      body: const VistaNegocios(
        titulo: 'Negocios',
        mostrarEncabezado: true,
      ),
    );
  }
}
