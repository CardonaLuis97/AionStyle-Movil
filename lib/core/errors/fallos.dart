import 'package:equatable/equatable.dart';

/// Fallos de capa de dominio. Expuestos a la UI como estados de error.
abstract class Fallo extends Equatable {
  const Fallo([this.mensaje = 'Ocurrió un error inesperado']);
  final String mensaje;
  @override
  List<Object?> get props => [mensaje];
}

class FalloServidor extends Fallo {
  const FalloServidor([super.mensaje = 'Error del servidor']);
}

class FalloSinConexion extends Fallo {
  const FalloSinConexion() : super('Sin conexión a internet');
}

class FalloNoAutorizado extends Fallo {
  const FalloNoAutorizado() : super('Sesión expirada, inicia sesión nuevamente');
}

class FalloNoEncontrado extends Fallo {
  const FalloNoEncontrado([super.mensaje = 'El recurso no fue encontrado']);
}

class FalloAlmacenamiento extends Fallo {
  const FalloAlmacenamiento([super.mensaje = 'Error al acceder al almacenamiento']);
}

class FalloPago extends Fallo {
  const FalloPago([super.mensaje = 'Error al procesar el pago']);
}

class FalloValidacion extends Fallo {
  const FalloValidacion([super.mensaje = 'Datos inválidos']);
}
