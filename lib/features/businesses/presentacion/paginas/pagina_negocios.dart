import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaNegocios extends ConsumerWidget {
  const PaginaNegocios({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negocios')),
      body: const Center(child: Text('Listado de negocios — en construcción')),
    );
  }
}
