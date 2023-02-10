import 'package:equatable/equatable.dart';

class TipoResultado extends Equatable {
  final String tipo;

  const TipoResultado(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

class TiposDeResultados {
  static TipoResultado aVista = const TipoResultado("aVista");
  static TipoResultado aPrazo = const TipoResultado("aPrazo");
}
