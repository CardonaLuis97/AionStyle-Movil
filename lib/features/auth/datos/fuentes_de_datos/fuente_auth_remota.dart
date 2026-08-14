import 'package:dio/dio.dart';
import '../../../../core/constants/constantes_api.dart';
import '../../../../core/errors/excepciones.dart';
import '../modelos/usuario_modelo.dart';

abstract class FuenteDatosAuthRemota {
  Future<UsuarioModelo> iniciarSesion({
    required String email,
    required String contrasena,
  });

  Future<UsuarioModelo> iniciarSesionGoogle(String idTokenGoogle);

  Future<UsuarioModelo> registrarse({
    required String nombre,
    required String email,
    required String contrasena,
  });

  Future<void> cerrarSesion();
}

class FuenteDatosAuthRemotaImpl implements FuenteDatosAuthRemota {
  const FuenteDatosAuthRemotaImpl(this._dio);

  final Dio _dio;

  @override
  Future<UsuarioModelo> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.login,
        data: {'email': email, 'contrasena': contrasena},
      );
      return UsuarioModelo.fromJson(respuesta.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error al iniciar sesión',
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UsuarioModelo> iniciarSesionGoogle(String idTokenGoogle) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.loginGoogle,
        data: {'id_token': idTokenGoogle},
      );
      return UsuarioModelo.fromJson(respuesta.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error con Google Sign-In',
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UsuarioModelo> registrarse({
    required String nombre,
    required String email,
    required String contrasena,
  }) async {
    try {
      final respuesta = await _dio.post(
        ConstantesApi.registro,
        data: {'nombre': nombre, 'email': email, 'contrasena': contrasena},
      );
      return UsuarioModelo.fromJson(respuesta.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error al registrarse',
        codigo: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      await _dio.post(ConstantesApi.cerrarSesion);
    } on DioException catch (e) {
      throw ExcepcionServidor(
        mensaje: e.response?.data?['mensaje'] as String? ?? 'Error al cerrar sesión',
        codigo: e.response?.statusCode,
      );
    }
  }
}
