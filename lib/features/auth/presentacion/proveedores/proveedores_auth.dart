import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/providers/proveedores_core.dart';
import '../../datos/fuentes_de_datos/fuente_auth_remota.dart';
import '../../datos/repositorios/repositorio_auth_impl.dart';
import '../../dominio/repositorios/repositorio_auth.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_iniciar_sesion_google.dart';
import '../../dominio/casos_de_uso/caso_uso_cerrar_sesion.dart';
import '../../dominio/casos_de_uso/caso_uso_registrarse.dart';
import '../modelos_vista/estado_auth.dart';
import '../modelos_vista/viewmodel_auth.dart';

// Fuente de datos
final fuenteAuthRemotaProvider = Provider<FuenteDatosAuthRemota>((ref) {
  return FuenteDatosAuthRemotaImpl(ref.watch(dioProvider));
});

// Repositorio
final repositorioAuthProvider = Provider<RepositorioAuth>((ref) {
  return RepositorioAuthImpl(
    fuenteRemota: ref.watch(fuenteAuthRemotaProvider),
    almacenamiento: ref.watch(almacenamientoSeguroProvider),
    googleSignIn: GoogleSignIn(),
  );
});

// Casos de uso
final casoUsoIniciarSesionProvider = Provider((ref) {
  return CasoUsoIniciarSesion(ref.watch(repositorioAuthProvider));
});
final casoUsoGoogleProvider = Provider((ref) {
  return CasoUsoIniciarSesionGoogle(ref.watch(repositorioAuthProvider));
});
final casoUsoCerrarSesionProvider = Provider((ref) {
  return CasoUsoCerrarSesion(ref.watch(repositorioAuthProvider));
});
final casoUsoRegistrarseProvider = Provider((ref) {
  return CasoUsoRegistrarse(ref.watch(repositorioAuthProvider));
});

// ViewModel
final viewModelAuthProvider =
    StateNotifierProvider<ViewModelAuth, EstadoAuth>((ref) {
  return ViewModelAuth(
    casoUsoIniciarSesion: ref.watch(casoUsoIniciarSesionProvider),
    casoUsoGoogle: ref.watch(casoUsoGoogleProvider),
    casoUsoCerrarSesion: ref.watch(casoUsoCerrarSesionProvider),
    casoUsoRegistrarse: ref.watch(casoUsoRegistrarseProvider),
  );
});
