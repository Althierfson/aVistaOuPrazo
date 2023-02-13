import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/util/convert_to_string_real.dart';
import 'package:avistaouaprazo/core/util/tipo_de_taxa.dart';
import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/taxas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/repositories/vista_ou_prazo_repository.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_valor.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calcular_valor_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VistaOuPrazoRepository>()])
void main() {
  MockVistaOuPrazoRepository repository = MockVistaOuPrazoRepository();
  ConvertTo convert = ConvertTo();
  CalcularValor usecase =
      CalcularValor(repository: repository, convertTo: convert);

  setUp(() {
    repository = MockVistaOuPrazoRepository();
    convert = ConvertTo();
    usecase =
        CalcularValor(repository: repository, convertTo: convert);
  });

  test("Deve retornar uma falha quando o repositorio retornar um falha",
      () async {
    when(repository.getTaxas()).thenAnswer((_) async => Left(AcessoAPIFalha()));

    final result = await usecase(CalcularValorParametro(
        parcelas: 10,
        valorDaCompra: "100.00",
        valorVista: "100.00",
        tipoDeTaxa: TiposDeTaxas.selic));

    result.fold((l) {
      expect(l, isA<AcessoAPIFalha>());
    }, (r) {
      expect(1, 2);
    });
  });

  group("Teste dos Calculos", () {
    void runTestCalculo(
        CalcularValorParametro parametro, Resultado resultado) async {
      Taxas tTaxas = const Taxas(cdi: 13.75, selic: 13.75);
      when(repository.getTaxas()).thenAnswer((_) async => Right(tTaxas));

      final result = await usecase(parametro);

      result.fold((l) {
        expect(1, 2);
      }, (r) {
        expect(r, resultado);
      });
    }

    /// Entrada:
    /// valor da compra: R$ 199,88
    /// Valor da compra a vista: R$ 179,88
    /// Numero de parcelas: 3
    ///
    /// Saida:
    /// Tipo de resultado: A vista
    /// produtoMaisLucroAVista: R$ 20,55
    /// produtoMaisLucroAPrazo: R$ 3,57
    /// valor a vista: R$ 179,88
    /// Historico a vista: [R$ 20,18, R$ 20,36, R$ 20,55]
    /// valor a prazo: R$ 199,88
    /// historico a prazo: [R$ 135,02, R$ 69,58, R$ 3,57]
    test("Teste de entrada 1", () async {
      Resultado tResultado = Resultado(
          qualMelhor: TiposDeResultados.aVista,
          produtoMaisLucroAVista: "R\$ 20.54",
          produtoMaisLucroAPrazo: "R\$ 3.58",
          parcelas: "3",
          valorAVista: "R\$ 179.88",
          valorAPrazo: "R\$ 199.88",
          historicoAvista: const [20.18, 20.36, 20.54],
          historicoAPrazo: const [135.02, 69.59, 3.58]);

      CalcularValorParametro tParametro = CalcularValorParametro(
          valorDaCompra: "199.88",
          valorVista: "179.88",
          parcelas: 3,
          tipoDeTaxa: TiposDeTaxas.cdi);

      runTestCalculo(tParametro, tResultado);
    });

    /// Entrada:
    /// valor da compra: R$ 2.470,58
    /// Valor da compra a vista: R$ 2.099,99
    /// Numero de parcelas: 10
    ///
    /// Saida:
    /// Tipo de resultado: A vista
    /// produtoMaisLucroAVista: R$ 405,28
    /// produtoMaisLucroAPrazo: R$ 126,31
    /// parcelas: 10
    /// valor a vista: R$ 2.099,99
    /// Historico a vista: [R$ 373,96, R$ 377,32, R$ 380,71, R$ 384,12, R$ 387,57, R$ 391,05, R$ 394,56, R$ 398,10, R$ 401,67, R$ 405,28]
    /// valor a prazo: R$ 2.470,58
    /// historico a prazo: [R$ 2.245,30, R$ 2.018,04, R$ 1.788,78, R$ 1.557,49, R$ 1.324,16, R$ 1.088,78, R$ 851,32, R$ 611,77, R$ 370,10 R$ 126,31]
    test("Teste de entrada 2", () async {
      Resultado tResultado = Resultado(
          qualMelhor: TiposDeResultados.aVista,
          produtoMaisLucroAVista: "R\$ 406.01",
          produtoMaisLucroAPrazo: "R\$ 131.6",
          parcelas: "10",
          valorAVista: "R\$ 2099.99",
          valorAPrazo: "R\$ 2470.58",
          historicoAvista: const [
            373.99,
            377.42,
            380.88,
            384.37,
            387.89,
            391.45,
            395.04,
            398.66,
            402.32,
            406.01
          ],
          historicoAPrazo: const [
            2246.17,
            2019.7,
            1791.15,
            1560.51,
            1327.75,
            1092.87,
            855.83,
            616.62,
            375.22,
            131.6
          ]);

      CalcularValorParametro tParamentro = CalcularValorParametro(
          parcelas: 10,
          valorDaCompra: "2470.58",
          valorVista: "2099.99",
          tipoDeTaxa: TiposDeTaxas.cdi);

      runTestCalculo(tParamentro, tResultado);
    });

    /// Entrada:
    /// valor da compra: R$ 2.470,58
    /// Valor da compra a vista: R$ 2.370,58
    /// Numero de parcelas: 10
    ///
    /// Saida:
    /// Tipo de resultado: A prazo
    /// produtoMaisLucroAVista: R$ 109,36
    /// produtoMaisLucroAPrazo: R$ 126,31
    /// parcelas: 10
    /// valor a vista: R$ 2.370,58
    /// Historico a vista: [R$ 100,91, R$ 101,82, R$ 102,73, R$ 103,65, R$ 104,58, R$ 105,52, R$ 106,47, R$ 107,42, R$ 108,39, R$ 109,36]
    /// valor a prazo: R$ 2.470,58
    /// historico a prazo: [R$ 2.245,30, R$ 2.018,04, R$ 1.788,78, R$ 1.557,49, R$ 1.324,16, R$ 1.088,78, R$ 851,32, R$ 611,77, R$ 370,10, R$ 126,31]
    test("Teste de entrada 3", () async {
      Resultado tResultado = Resultado(
          qualMelhor: TiposDeResultados.aPrazo,
          produtoMaisLucroAVista: "R\$ 109.56",
          produtoMaisLucroAPrazo: "R\$ 131.6",
          parcelas: "10",
          valorAVista: "R\$ 2370.58",
          valorAPrazo: "R\$ 2470.58",
          historicoAvista: const [
            100.92,
            101.85,
            102.79,
            103.73,
            104.68,
            105.64,
            106.61,
            107.59,
            108.57,
            109.56
          ],
          historicoAPrazo: const [
            2246.17,
            2019.7,
            1791.15,
            1560.51,
            1327.75,
            1092.87,
            855.83,
            616.62,
            375.22,
            131.6
          ]);

      CalcularValorParametro tParamentro = CalcularValorParametro(
          parcelas: 10,
          valorDaCompra: "2470.58",
          valorVista: "2370.58",
          tipoDeTaxa: TiposDeTaxas.cdi);

      runTestCalculo(tParamentro, tResultado);
    });
  });
}
