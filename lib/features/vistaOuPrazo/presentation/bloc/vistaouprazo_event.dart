part of 'vistaouprazo_bloc.dart';

abstract class VistaOuPrazoEvent extends Equatable {
  const VistaOuPrazoEvent();

  @override
  List<Object> get props => [];
}

class CalcularComTaxaPadraoEvent extends VistaOuPrazoEvent {
  final CalcularValorParametro parametro;

  const CalcularComTaxaPadraoEvent(this.parametro);

  @override
  List<Object> get props => [parametro];
}

class CalcularComTaxaPersonalizadaEvent extends VistaOuPrazoEvent {
  final CalcularComTaxaPersonalizadaParametro parametro;

  const CalcularComTaxaPersonalizadaEvent(this.parametro);

  @override
  List<Object> get props => [parametro];
}

class DadosInvalidosEvent extends VistaOuPrazoEvent {}
