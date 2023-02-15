import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/error/get_mensagem_falha.dart';
import 'package:avistaouaprazo/core/util/tipo_de_taxa.dart';
import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_com_taxa_personalizada.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_valor.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/bloc/vistaouprazo_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'vistaouprazo_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<CalcularValor>(), MockSpec<CalcularComTaxaPersonalizada>()])
void main() {
  MockCalcularValor calcularValor = MockCalcularValor();
  MockCalcularComTaxaPersonalizada calcularComTaxaPersonalizada =
      MockCalcularComTaxaPersonalizada();

  VistaOuPrazoBloc setBloc() => VistaOuPrazoBloc(
      calcularValor: calcularValor,
      calcularComTaxaPersonalizada: calcularComTaxaPersonalizada);

  blocTest<VistaOuPrazoBloc, VistaOuPrazoState>(
    'Deve emitir [VistaouprazoInitial] when MyEvent is added.',
    build: () => setBloc(),
    verify: (bloc) => expect(bloc.state, VistaOuPrazoInitial()),
  );

  group("CalcularVaor usecase", () {
    CalcularValorParametro tParametro = CalcularValorParametro(
        valorDaCompra: "199.99",
        valorVista: "178.88",
        parcelas: 3,
        tipoDeTaxa: TiposDeTaxas.selic);

    Resultado tResultado = Resultado(
        qualMelhor: TiposDeResultados.aVista,
        produtoMaisLucroAVista: "R\$ 15.87",
        produtoMaisLucroAPrazo: "R\$ 8.98",
        parcelas: "3",
        valorAVista: "R\$ 178.88",
        valorAPrazo: "R\$ 199.99",
        historicoAvista: const [13.87, 14.87, 15.87],
        historicoAPrazo: const [6.98, 7.98, 8.98]);

    blocTest<VistaOuPrazoBloc, VistaOuPrazoState>(
      'Deve emitir [FazendoCalculoState, CalculoConcluidoState] quando o evento [CalcularComTaxaPadraoEvent] for adicionado.',
      build: () => setBloc(),
      setUp: () {
        when(calcularValor(any)).thenAnswer((_) async => Right(tResultado));
      },
      act: (bloc) => bloc.add(CalcularComTaxaPadraoEvent(tParametro)),
      expect: () => <VistaOuPrazoState>[
        FazendoCalculoState(),
        CalculoConcluidoState(tResultado)
      ],
    );

    blocTest<VistaOuPrazoBloc, VistaOuPrazoState>(
      'Deve emitir [FazendoCalculoState, FalhaNoCalculoState] quando o evento [CalcularComTaxaPadraoEvent] for adicionado.',
      build: () => setBloc(),
      setUp: () {
        when(calcularValor(any))
            .thenAnswer((_) async => Left(AcessoAPIFalha()));
      },
      act: (bloc) => bloc.add(CalcularComTaxaPadraoEvent(tParametro)),
      expect: () => <VistaOuPrazoState>[
        FazendoCalculoState(),
        FalhaNoCalculoState(getMensagemFalha(AcessoAPIFalha()))
      ],
    );
  });

  group("CalcularComTaxaPersonalizada usecase", () {
    CalcularComTaxaPersonalizadaParametro tParametro =
        CalcularComTaxaPersonalizadaParametro(
            valorDaCompra: "199.99",
            valorVista: "178.88",
            parcelas: 3,
            taxa: "13.75");

    Resultado tResultado = Resultado(
        qualMelhor: TiposDeResultados.aVista,
        produtoMaisLucroAVista: "R\$ 15.87",
        produtoMaisLucroAPrazo: "R\$ 8.98",
        parcelas: "3",
        valorAVista: "R\$ 178.88",
        valorAPrazo: "R\$ 199.99",
        historicoAvista: const [13.87, 14.87, 15.87],
        historicoAPrazo: const [6.98, 7.98, 8.98]);

    blocTest<VistaOuPrazoBloc, VistaOuPrazoState>(
      'Deve emitir [FazendoCalculoState, CalculoConcluidoState] quando o evento [CalcularComTaxaPersonalizadaEvent] for adicionado.',
      build: () => setBloc(),
      setUp: () {
        when(calcularComTaxaPersonalizada(any))
            .thenAnswer((_) async => Right(tResultado));
      },
      act: (bloc) => bloc.add(CalcularComTaxaPersonalizadaEvent(tParametro)),
      expect: () => <VistaOuPrazoState>[
        FazendoCalculoState(),
        CalculoConcluidoState(tResultado)
      ],
    );

    blocTest<VistaOuPrazoBloc, VistaOuPrazoState>(
      'Deve emitir [FazendoCalculoState, FalhaNoCalculoState] quando o evento [CalcularComTaxaPadraoEvent] for adicionado.',
      build: () => setBloc(),
      setUp: () {
        when(calcularComTaxaPersonalizada(any))
            .thenAnswer((_) async => Left(AcessoAPIFalha()));
      },
      act: (bloc) => bloc.add(CalcularComTaxaPersonalizadaEvent(tParametro)),
      expect: () => <VistaOuPrazoState>[
        FazendoCalculoState(),
        FalhaNoCalculoState(getMensagemFalha(AcessoAPIFalha()))
      ],
    );
  });
}
