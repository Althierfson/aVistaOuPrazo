import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<R, P> {
  Future<Either<Falha, R>> call(P parametro);
}
