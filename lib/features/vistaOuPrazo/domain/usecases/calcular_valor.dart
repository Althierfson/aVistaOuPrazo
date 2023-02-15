import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/util/calcular_rendimento.dart';
import 'package:avistaouaprazo/core/util/tipo_de_taxa.dart';
import 'package:avistaouaprazo/core/util/use_case.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/taxas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/repositories/vista_ou_prazo_repository.dart';
import 'package:dartz/dartz.dart';


class CalcularValor extends UseCase<Resultado, CalcularValorParametro> {
  final VistaOuPrazoRepository repository;
  final CalcularRendimento calcularRendimento;

  CalcularValor(
      {required this.repository,
      required this.calcularRendimento});

  @override
  Future<Either<Falha, Resultado>> call(
      CalcularValorParametro parametro) async {
    late Taxas taxas;
    try {
      await repository.getTaxas().then((value) => value.fold((l) {
            throw l;
          }, (r) {
            taxas = r;
          }));

      double taxa = getTaxaEscolhida(taxas, parametro.tipoDeTaxa);

      return calcularRendimento(
          parametro: CalcularRendimentoParametro(
              valorDaCompra: parametro.valorDaCompra,
              valorVista: parametro.valorVista,
              parcelas: parametro.parcelas),
          taxa: taxa);
    } on Falha catch (falha) {
      return Left(falha);
    }
  }

  double getTaxaEscolhida(Taxas taxas, TipoDeTaxa tipoDeTaxa) {
    if (tipoDeTaxa == TiposDeTaxas.cdi) {
      return taxas.cdi;
    } else if (tipoDeTaxa == TiposDeTaxas.selic) {
      return taxas.selic;
    } else {
      throw CachedFalha();
    }
  }
}

class CalcularValorParametro {
  final String valorDaCompra;
  final String valorVista;
  final int parcelas;
  final TipoDeTaxa tipoDeTaxa;

  CalcularValorParametro(
      {required this.valorDaCompra,
      required this.valorVista,
      required this.parcelas,
      required this.tipoDeTaxa});
}
