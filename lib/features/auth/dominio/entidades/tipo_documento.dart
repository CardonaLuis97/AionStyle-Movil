enum TipoDocumento {
  dni,
  certificadoNacimiento;

  String get nombre => switch (this) {
        TipoDocumento.dni => 'DNI',
        TipoDocumento.certificadoNacimiento => 'CERTIFICADO_NACIMIENTO',
      };

  String get etiqueta => switch (this) {
        TipoDocumento.dni => 'DNI',
        TipoDocumento.certificadoNacimiento => 'Certificado de nacimiento',
      };

  static TipoDocumento desdeTexto(String texto) =>
      switch (texto.toUpperCase()) {
        'DNI' => TipoDocumento.dni,
        'CERTIFICADO_NACIMIENTO' => TipoDocumento.certificadoNacimiento,
        _ => throw ArgumentError('Tipo de documento desconocido: $texto'),
      };
}
