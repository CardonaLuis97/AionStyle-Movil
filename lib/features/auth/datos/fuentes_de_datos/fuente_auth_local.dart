import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/errors/excepciones.dart';
import '../modelos/usuario_modelo.dart';

abstract class FuenteDatosAuthLocal {
  Future<UsuarioModelo> loginConCorreo({
    required String correo,
    required String contrasena,
  });

  Future<UsuarioModelo> loginConGoogle(String idTokenGoogle);

  Future<UsuarioModelo> registrar({
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  });

  Future<UsuarioModelo> completarPerfil({
    required String usuarioId,
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  });

  Future<void> cerrarSesion();
}

class FuenteDatosAuthLocalImpl implements FuenteDatosAuthLocal {
  Future<Map<String, dynamic>> _cargarMock(String ruta) async {
    final jsonStr = await rootBundle.loadString(ruta);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final estado = json['estado'] as String;
    if (estado != '200') {
      throw ExcepcionServidor(
        mensaje: (json['cuerpo']?['mensaje'] as String?) ?? 'Error del servidor',
        codigo: int.tryParse(estado),
      );
    }
    return json['cuerpo'] as Map<String, dynamic>;
  }

  @override
  Future<UsuarioModelo> loginConCorreo({
    required String correo,
    required String contrasena,
  }) async {
    final cuerpo = await _cargarMock('assets/mock_api/auth/login_correo_post.json');
    return UsuarioModelo.fromJson(cuerpo['usuario'] as Map<String, dynamic>);
  }

  @override
  Future<UsuarioModelo> loginConGoogle(String idTokenGoogle) async {
    final cuerpo = await _cargarMock('assets/mock_api/auth/login_google_post.json');
    return UsuarioModelo.fromJson(cuerpo['usuario'] as Map<String, dynamic>);
  }

  @override
  Future<UsuarioModelo> registrar({
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
    required String correo,
    required String contrasena,
  }) async {
    final cuerpo = await _cargarMock('assets/mock_api/auth/registro_post.json');
    return UsuarioModelo.fromJson(cuerpo['usuario'] as Map<String, dynamic>);
  }

  @override
  Future<UsuarioModelo> completarPerfil({
    required String usuarioId,
    required String nombreCompleto,
    required String tipoDocumento,
    required String numeroDocumento,
    required String telefono,
  }) async {
    final cuerpo =
        await _cargarMock('assets/mock_api/auth/completar_perfil_post.json');
    return UsuarioModelo.fromJson(cuerpo['usuario'] as Map<String, dynamic>);
  }

  @override
  Future<void> cerrarSesion() async {
    // Sin llamada real en mock
  }
}
