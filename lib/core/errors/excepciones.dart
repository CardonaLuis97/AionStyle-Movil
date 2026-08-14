/// Excepciones de capa de datos. Son atrapadas y convertidas a [Fallo].
class ExcepcionServidor implements Exception {
  const ExcepcionServidor({this.mensaje = 'Error del servidor', this.codigo});
  final String mensaje;
  final int? codigo;
  @override
  String toString() => 'ExcepcionServidor($codigo): $mensaje';
}

class ExcepcionSinConexion implements Exception {
  const ExcepcionSinConexion();
  @override
  String toString() => 'ExcepcionSinConexion: Sin conexión a internet';
}

class ExcepcionNoAutorizado implements Exception {
  const ExcepcionNoAutorizado();
  @override
  String toString() => 'ExcepcionNoAutorizado: Token inválido o expirado';
}

class ExcepcionNoEncontrado implements Exception {
  const ExcepcionNoEncontrado([this.recurso = 'Recurso']);
  final String recurso;
  @override
  String toString() => 'ExcepcionNoEncontrado: $recurso no encontrado';
}

class ExcepcionAlmacenamiento implements Exception {
  const ExcepcionAlmacenamiento([this.mensaje = 'Error de almacenamiento']);
  final String mensaje;
  @override
  String toString() => 'ExcepcionAlmacenamiento: $mensaje';
}

class ExcepcionPago implements Exception {
  const ExcepcionPago([this.mensaje = 'Error al procesar el pago']);
  final String mensaje;
  @override
  String toString() => 'ExcepcionPago: $mensaje';
}
