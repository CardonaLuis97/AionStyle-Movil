import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final _log = Logger();

/// Registra en consola las peticiones y respuestas (solo en debug).
class InterceptorLogs extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d('[→] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.d('[←] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e('[✗] ${err.response?.statusCode} ${err.requestOptions.uri}\n${err.message}');
    handler.next(err);
  }
}
