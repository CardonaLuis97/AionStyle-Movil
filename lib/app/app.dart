import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: ThemeMode.system,
      routerConfig: enrutador,
    );
  }
}
