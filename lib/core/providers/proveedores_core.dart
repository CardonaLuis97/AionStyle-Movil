import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../storage/almacenamiento_seguro.dart';
import '../network/cliente_dio.dart';
import '../network/interceptores/interceptor_auth.dart';

// Almacenamiento seguro
final almacenamientoSeguroProvider = Provider<AlmacenamientoSeguro>((ref) {
  return AlmacenamientoSeguro(const FlutterSecureStorage());
});

// Interceptor de autenticación
final interceptorAuthProvider = Provider<InterceptorAuth>((ref) {
  return InterceptorAuth(ref.watch(almacenamientoSeguroProvider));
});

// Cliente Dio
final dioProvider = Provider<Dio>((ref) {
  return ClienteDio.crear(
    interceptorAuth: ref.watch(interceptorAuthProvider),
  );
});
