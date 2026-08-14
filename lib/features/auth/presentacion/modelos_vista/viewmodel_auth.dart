import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion_google.dart';
import '../../dominio/casos_de_uso/caso_uso_cerrar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_registrarse.dart';
import 'estado_auth.dart';

class ViewModelAuth extends StateNotifier<EstadoAuth> {
  ViewModelAuth({
    required this.casoUsoIniciarSesion,
    required this.casoUsoGoogle,
    required this.casoUsoCerrarSesion,
    required this.casoUsoRegistrarse,
  }) : super(const EstadoAuth.inicial());

  final CasoUsoIniciarSesion casoUsoIniciarSesion;
  final CasoUsoIniciarSesionGoogle casoUsoGoogle;
  final CasoUsoCerrarSesion casoUsoCerrarSesion;
  final CasoUsoRegistrarse casoUsoRegistrarse;

  Future<void> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoIniciarSesion.ejecutar(
      email: email,
      contrasena: contrasena,
    );
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> iniciarSesionGoogle() async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoGoogle.ejecutar();
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> registrarse({
    required String nombre,
    required String email,
    required String contrasena,
  }) async {
    state = const EstadoAuth.cargando();
    final resultado = await casoUsoRegistrarse.ejecutar(
      nombre: nombre,
      email: email,
      contrasena: contrasena,
    );
    resultado.fold(
      (fallo) => state = EstadoAuth.error(fallo.mensaje),
      (usuario) => state = EstadoAuth.autenticado(usuario),
    );
  }

  Future<void> cerrarSesion() async {
    await casoUsoCerrarSesion.ejecutar();
    state = const EstadoAuth.noAutenticado();
  }
}
