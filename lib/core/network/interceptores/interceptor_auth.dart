import 'package:dio/dio.dart';
import '../../storage/almacenamiento_seguro.dart';
import '../../constants/constantes_app.dart';

/// Adjunta el Bearer token a cada petición autenticada.
class InterceptorAuth extends Interceptor {
  const InterceptorAuth(this._almacenamiento);

  final AlmacenamientoSeguro _almacenamiento;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _almacenamiento.leer(ConstantesApp.claveTokenAcceso);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
