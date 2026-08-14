import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/enrutador.dart';
import 'theme/tema.dart';

class AionStyleApp extends ConsumerWidget {
  const AionStyleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrutador = ref.watch(enrutadorProvider);

    return MaterialApp.router(
      title: 'AionStyle',
      debugShowCheckedModeBanner: false,
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: ThemeMode.system,
      routerConfig: enrutador,
    );
  }
}
