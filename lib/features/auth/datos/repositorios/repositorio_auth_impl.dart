import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/constantes_app.dart';
import '../../../../core/errors/excepciones.dart';
import '../../../../core/errors/fallos.dart';
import '../../../../core/storage/almacenamiento_seguro.dart';
import '../../../../core/utils/resultado.dart';
import '../../dominio/entidades/usuario_entidad.dart';
import '../../dominio/repositorios/repositorio_auth.dart';
import '../fuentes_de_datos/fuente_auth_remota.dart';

class RepositorioAuthImpl implements RepositorioAuth {
  const RepositorioAuthImpl({
    required this.fuenteRemota,
    required this.almacenamiento,
    required this.googleSignIn,
  });

  final FuenteDatosAuthRemota fuenteRemota;
  final AlmacenamientoSeguro almacenamiento;
  final GoogleSignIn googleSignIn;

  @override
  Future<Resultado<UsuarioEntidad>> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    try {
      final modelo = await fuenteRemota.iniciarSesion(
        email: email,
        contrasena: contrasena,
      );
      return Right(modelo.aEntidad());
    } on ExcepcionNoAutorizado {
      return const Left(FalloNoAutorizado());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad>> iniciarSesionGoogle() async {
    try {
      final cuenta = await googleSignIn.signIn();
      if (cuenta == null) return const Left(FalloServidor('Inicio cancelado'));

      final autenticacion = await cuenta.authentication;
      final idToken = autenticacion.idToken;
      if (idToken == null) return const Left(FalloServidor('No se obtuvo token de Google'));

      final modelo = await fuenteRemota.iniciarSesionGoogle(idToken);
      return Right(modelo.aEntidad());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad>> registrarse({
    required String nombre,
    required String email,
    required String contrasena,
  }) async {
    try {
      final modelo = await fuenteRemota.registrarse(
        nombre: nombre,
        email: email,
        contrasena: contrasena,
      );
      return Right(modelo.aEntidad());
    } on ExcepcionSinConexion {
      return const Left(FalloSinConexion());
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<ResultadoVacio> cerrarSesion() async {
    try {
      await fuenteRemota.cerrarSesion();
      await almacenamiento.eliminar(ConstantesApp.claveTokenAcceso);
      await almacenamiento.eliminar(ConstantesApp.claveTokenRefresco);
      await googleSignIn.signOut();
      return const Right(null);
    } on ExcepcionServidor catch (e) {
      return Left(FalloServidor(e.mensaje));
    }
  }

  @override
  Future<Resultado<UsuarioEntidad?>> obtenerUsuarioActual() async {
    final token = await almacenamiento.leer(ConstantesApp.claveTokenAcceso);
    if (token == null) return const Right(null);
    // TODO: decodificar JWT o hacer llamada a /perfil
    return const Right(null);
  }
}
