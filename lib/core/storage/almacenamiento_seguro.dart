import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/excepciones.dart';

/// Wrapper tipado sobre [FlutterSecureStorage].
class AlmacenamientoSeguro {
  AlmacenamientoSeguro(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> guardar(String clave, String valor) async {
    try {
      await _storage.write(key: clave, value: valor);
    } catch (_) {
      throw const ExcepcionAlmacenamiento('No se pudo guardar el valor');
    }
  }

  Future<String?> leer(String clave) async {
    try {
      return await _storage.read(key: clave);
    } catch (_) {
      throw const ExcepcionAlmacenamiento('No se pudo leer el valor');
    }
  }

  Future<void> eliminar(String clave) async {
    try {
      await _storage.delete(key: clave);
    } catch (_) {
      throw const ExcepcionAlmacenamiento('No se pudo eliminar el valor');
    }
  }

  Future<void> limpiarTodo() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      throw const ExcepcionAlmacenamiento('No se pudo limpiar el almacenamiento');
    }
  }
}
