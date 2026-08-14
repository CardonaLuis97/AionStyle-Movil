import 'package:dio/dio.dart';
import '../../errors/excepciones.dart';

/// Convierte respuestas HTTP con error a [ExcepcionServidor] tipada.
class InterceptorErrores extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const ExcepcionSinConexion();

      case DioExceptionType.badResponse:
        final codigo = err.response?.statusCode ?? 0;
        final mensaje = err.response?.data?['mensaje'] as String? ?? 'Error del servidor';
        if (codigo == 401) throw const ExcepcionNoAutorizado();
        if (codigo == 404) throw const ExcepcionNoEncontrado();
        throw ExcepcionServidor(mensaje: mensaje, codigo: codigo);

      case DioExceptionType.unknown:
        if (err.message?.contains('SocketException') ?? false) {
          throw const ExcepcionSinConexion();
        }
        throw ExcepcionServidor(mensaje: err.message ?? 'Error desconocido');

      default:
        handler.next(err);
    }
  }
}
