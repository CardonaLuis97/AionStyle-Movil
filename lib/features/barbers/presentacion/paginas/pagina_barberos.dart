import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginaBarberos extends ConsumerWidget {
  const PaginaBarberos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barberos')),
      body: const Center(child: Text('Listado de barberos — en construcción')),
    );
  }
}
