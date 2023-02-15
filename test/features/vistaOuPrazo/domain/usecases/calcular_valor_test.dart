import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/util/calcular_rendimento.dart';
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
  CalcularRendimento calcularRendimento =
      CalcularRendimentoImpl(convertTo: convert);
  CalcularValor usecase = CalcularValor(
      repository: repository, calcularRendimento: calcularRendimento);

  setUp(() {
    repository = MockVistaOuPrazoRepository();
    convert = ConvertTo();
    calcularRendimento = CalcularRendimentoImpl(convertTo: convert);
    usecase = CalcularValor(
        repository: repository, calcularRendimento: calcularRendimento);
  });

  group("Falhas", () {
    test("Deve retornar uma falha quando o repositorio retornar um falha",
        () async {
      when(repository.getTaxas())
          .thenAnswer((_) async => Left(AcessoAPIFalha()));

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
  });

  group("Sucesso", () {
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
  });
}
