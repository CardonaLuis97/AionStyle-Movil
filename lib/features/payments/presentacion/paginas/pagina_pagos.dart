import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaPagos extends ConsumerWidget {
  const PaginaPagos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagos')),
      body: const Center(child: Text('Historial de pagos — en construcción')),
    );
  }
}
