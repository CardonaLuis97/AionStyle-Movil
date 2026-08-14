import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaModoPropietario extends ConsumerWidget {
  const PaginaModoPropietario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Propietario')),
      body: const Center(child: Text('Panel del propietario — en construcción')),
    );
  }
}
