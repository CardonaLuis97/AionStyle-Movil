enum ProveedorAutenticacion {
  correo,
  google;

  String get nombre => switch (this) {
        ProveedorAutenticacion.correo => 'CORREO',
        ProveedorAutenticacion.google => 'GOOGLE',
      };

  static ProveedorAutenticacion desdeTexto(String texto) =>
      switch (texto.toUpperCase()) {
        'CORREO' => ProveedorAutenticacion.correo,
        'GOOGLE' => ProveedorAutenticacion.google,
        _ => throw ArgumentError('Proveedor desconocido: $texto'),
      };
}
