import 'package:avistaouaprazo/core/error/get_mensagem_falha.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_valor.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vistaouprazo_event.dart';
part 'vistaouprazo_state.dart';

class VistaOuPrazoBloc extends Bloc<VistaOuPrazoEvent, VistaOuPrazoState> {
  final CalcularValor calcularValor;
  VistaOuPrazoBloc({required this.calcularValor})
      : super(VistaOuPrazoInitial()) {
    on<CalcularComTaxaPadraoEvent>((event, emit) async {
      emit(FazendoCalculoState());
      await calcularValor(event.parametro).then((valor) => valor.fold(
          (l) => emit(FalhaNoCalculoState(getMensagemFalha(l))),
          (r) => emit(CalculoConcluidoState(r))));
    });
  }
}
