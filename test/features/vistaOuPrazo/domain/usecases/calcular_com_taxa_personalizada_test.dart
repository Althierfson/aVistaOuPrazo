import 'package:avistaouaprazo/core/util/calcular_rendimento.dart';
import 'package:avistaouaprazo/core/util/convert_to_string_real.dart';
import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_com_taxa_personalizada.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ConvertTo convertTo = ConvertTo();
  CalcularRendimento calcularRendimento =
      CalcularRendimentoImpl(convertTo: convertTo);
  CalcularComTaxaPersonalizada usecase =
      CalcularComTaxaPersonalizada(calcularRendimento: calcularRendimento);

  group("calculo", () {
    void runTestCalculo(CalcularComTaxaPersonalizadaParametro parametro,
        Resultado resultado) async {
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

      CalcularComTaxaPersonalizadaParametro tParametro =
          CalcularComTaxaPersonalizadaParametro(
              valorDaCompra: "199.88",
              valorVista: "179.88",
              parcelas: 3,
              taxa: "13.75");

      runTestCalculo(tParametro, tResultado);
    });
  });
}
