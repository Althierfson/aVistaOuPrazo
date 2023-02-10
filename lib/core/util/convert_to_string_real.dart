import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';

class ConvertToStringReal {
  Either<Falha, String> fromDecimalToStringReal(Decimal valor) {
    try {
      String valorString = valor.toString();
      return Right("R\$ $valorString");
    } on Exception {
      return Left(ConvertFalha());
    }
  }

  Either<Falha, Decimal> fromDoubleToDecimal(double valor) {
    try {
      double valorRound = double.parse(valor.toStringAsFixed(2));
      return Right(Decimal.parse(valorRound.toString()));
    } on Exception {
      return Left(ConvertFalha());
    }
  }

  Either<Falha, Decimal> fromStringToDecimal(String valor) {
    try {
      Decimal valorDecimal = Decimal.parse(valor);
      return Right(valorDecimal);
    } on Exception {
      return Left(ConvertFalha());
    }
  }

  Either<Falha, double> fromDecimalToDouble(Decimal valor) {
    try {
      double valorDouble = valor.toDouble();
      return Right(valorDouble);
    } on Exception {
      return Left(ConvertFalha());
    }
  }
}
