import '../../../../core/utils/resultado.dart';

abstract class RepositorioQr {
  Future<ResultadoVacio> validarCodigoQr(String codigo);
}
