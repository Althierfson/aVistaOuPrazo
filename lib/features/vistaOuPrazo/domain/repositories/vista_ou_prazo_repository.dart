import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/taxas.dart';
import 'package:dartz/dartz.dart';

abstract class VistaOuPrazoRepository {
  Future<Either<Falha, Taxas>> getTaxas();
}
