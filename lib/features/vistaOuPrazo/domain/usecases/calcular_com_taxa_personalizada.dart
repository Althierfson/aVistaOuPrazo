import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/util/calcular_rendimento.dart';
import 'package:avistaouaprazo/core/util/use_case.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:dartz/dartz.dart';

class CalcularComTaxaPersonalizada
    extends UseCase<Resultado, CalcularComTaxaPersonalizadaParametro> {
  final CalcularRendimento calcularRendimento;

  CalcularComTaxaPersonalizada({required this.calcularRendimento});

  @override
  Future<Either<Falha, Resultado>> call(
      CalcularComTaxaPersonalizadaParametro parametro) {
    return Future.delayed(
        const Duration(seconds: 1),
        () => calcularRendimento(
            parametro: CalcularRendimentoParametro(
                valorDaCompra: parametro.valorDaCompra,
                valorVista: parametro.valorVista,
                parcelas: parametro.parcelas),
            taxa: double.parse(parametro.taxa)));
  }
}

class CalcularComTaxaPersonalizadaParametro {
  final String valorDaCompra;
  final String valorVista;
  final int parcelas;
  final String taxa;

  CalcularComTaxaPersonalizadaParametro(
      {required this.valorDaCompra,
      required this.valorVista,
      required this.parcelas,
      required this.taxa});
}
