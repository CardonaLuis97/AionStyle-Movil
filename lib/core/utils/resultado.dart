import 'package:dartz/dartz.dart';
import '../errors/fallos.dart';

/// Alias semántico para operaciones que pueden fallar.
/// [L] = Fallo, [R] = resultado exitoso.
typedef Resultado<T> = Either<Fallo, T>;

/// Alias para casos de uso sin retorno de datos.
typedef ResultadoVacio = Either<Fallo, void>;
