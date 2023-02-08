import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vistaouprazo_event.dart';
part 'vistaouprazo_state.dart';

class VistaouprazoBloc extends Bloc<VistaouprazoEvent, VistaouprazoState> {
  VistaouprazoBloc() : super(VistaouprazoInitial()) {
    on<VistaouprazoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
