import 'package:flutter/material.dart';
import 'colores.dart';

final _esquemaClaro = ColorScheme.fromSeed(
  seedColor: ColoresApp.primario,
  brightness: Brightness.light,
).copyWith(
  primary: ColoresApp.primario,
  onPrimary: ColoresApp.secundario,
  surface: ColoresApp.secundario,
  onSurface: ColoresApp.texto,
  onSurfaceVariant: ColoresApp.textoClaro,
  error: ColoresApp.error,
);

final _esquemaOscuro = ColorScheme.fromSeed(
  seedColor: ColoresApp.primario,
  brightness: Brightness.dark,
).copyWith(
  primary: ColoresApp.secundario,
  onPrimary: ColoresApp.primario,
  surface: ColoresApp.primario,
  onSurface: ColoresApp.secundario,
  onSurfaceVariant: ColoresApp.terceario,
  error: ColoresApp.error,
  onError: ColoresApp.secundario,
);

TextTheme _construirTemaTexto(Color principal, Color secundario) {
  return const TextTheme().copyWith(
    titleLarge: TextStyle(color: principal),
    titleMedium: TextStyle(color: principal),
    bodyLarge: TextStyle(color: principal),
    bodyMedium: TextStyle(color: principal),
    labelLarge: TextStyle(color: principal),
    bodySmall: TextStyle(color: secundario),
    labelSmall: TextStyle(color: secundario),
  );
}

final temaClaro = ThemeData(
  useMaterial3: true,
  colorScheme: _esquemaClaro,
  scaffoldBackgroundColor: ColoresApp.fondo,
  canvasColor: ColoresApp.fondo,
  cardColor: ColoresApp.secundario,
  fontFamily: 'Poppins',
  textTheme: _construirTemaTexto(ColoresApp.texto, ColoresApp.textoClaro),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: ColoresApp.secundario,
    foregroundColor: ColoresApp.primario,
  ),
  cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  listTileTheme: const ListTileThemeData(
    textColor: ColoresApp.texto,
    iconColor: ColoresApp.textoClaro,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    filled: true,
    fillColor: ColoresApp.secundario,
    hintStyle: const TextStyle(color: ColoresApp.textoClaro),
    labelStyle: const TextStyle(color: ColoresApp.texto),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.terceario),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.primario),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.error),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColoresApp.primario,
      foregroundColor: ColoresApp.secundario,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColoresApp.primario,
      side: const BorderSide(color: ColoresApp.primario),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ColoresApp.primario,
    ),
  ),
);

final temaOscuro = ThemeData(
  useMaterial3: true,
  colorScheme: _esquemaOscuro,
  scaffoldBackgroundColor: ColoresApp.primario,
  canvasColor: ColoresApp.primario,
  cardColor: ColoresApp.primario,
  fontFamily: 'Poppins',
  textTheme: _construirTemaTexto(ColoresApp.secundario, ColoresApp.terceario),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: ColoresApp.primario,
    foregroundColor: ColoresApp.secundario,
  ),
  cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  listTileTheme: const ListTileThemeData(
    textColor: ColoresApp.secundario,
    iconColor: ColoresApp.terceario,
  ),
  iconTheme: const IconThemeData(color: ColoresApp.secundario),
  primaryIconTheme: const IconThemeData(color: ColoresApp.secundario),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    filled: true,
    fillColor: ColoresApp.primario,
    hintStyle: const TextStyle(color: ColoresApp.terceario),
    labelStyle: const TextStyle(color: ColoresApp.secundario),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.terceario),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.secundario),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColoresApp.error),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColoresApp.secundario,
      foregroundColor: ColoresApp.primario,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColoresApp.secundario,
      side: const BorderSide(color: ColoresApp.terceario),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ColoresApp.secundario,
    ),
  ),
);
