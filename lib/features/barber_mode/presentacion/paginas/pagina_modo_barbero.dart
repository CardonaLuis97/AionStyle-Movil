import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaModoBarbero extends ConsumerWidget {
  const PaginaModoBarbero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Barbero')),
      body: const Center(child: Text('Panel del barbero — en construcción')),
    );
  }
}
