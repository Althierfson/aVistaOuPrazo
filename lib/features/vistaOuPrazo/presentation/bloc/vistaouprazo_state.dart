part of 'vistaouprazo_bloc.dart';

abstract class VistaOuPrazoState extends Equatable {
  const VistaOuPrazoState();

  @override
  List<Object> get props => [];
}

class VistaOuPrazoInitial extends VistaOuPrazoState {}

class FazendoCalculoState extends VistaOuPrazoState {}

class CalculoConcluidoState extends VistaOuPrazoState {
  final Resultado resultado;

  const CalculoConcluidoState(this.resultado);

  @override
  List<Object> get props => [resultado];
}

class FalhaNoCalculoState extends VistaOuPrazoState {
  final String falhaMensagem;

  const FalhaNoCalculoState(this.falhaMensagem);

  @override
  List<Object> get props => [falhaMensagem];
}
