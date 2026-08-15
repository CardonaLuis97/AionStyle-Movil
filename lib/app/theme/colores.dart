import 'package:flutter/material.dart';

abstract class ColoresApp {
  // Paleta principal — cambiar aquí afecta toda la app
  static const primario = Color(0xFF000000); // negro
  static const secundario = Color(0xFFFFFFFF); // blanco
  static const terceario = Color(0xFFCDAD82); // dorado base

  static const acento = Color(0xFFA88E6B); // dorado variante card
  static const dorado = Color(0xFFB89B74); // dorado intermedio
  static const fondo = Color(0xFFCDAD82); // dorado de fondo
  static const fondoOscuro = Color(0xFF121212);
  static const texto = Color(0xFF111111);
  static const textoClaro = Color(0xFF5A4D3C);
  static const exito = Color(0xFF2F9E78);
  static const advertencia = Color(0xFFDFB766);
  static const error = Color(0xFFB53D3D);
}
