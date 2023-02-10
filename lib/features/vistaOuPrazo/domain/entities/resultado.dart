import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:equatable/equatable.dart';

class Resultado extends Equatable {
  final TipoResultado qualMelhor;
  final String produtoMaisLucroAVista;
  final String produtoMaisLucroAPrazo;
  final String parcelas;
  final String valorAVista;
  final String valorAPrazo;
  final List<double> historicoAvista;
  final List<double> historicoAPrazo;

  const Resultado(
      {required this.qualMelhor,
      required this.produtoMaisLucroAVista,
      required this.produtoMaisLucroAPrazo,
      required this.parcelas,
      required this.valorAVista,
      required this.valorAPrazo,
      required this.historicoAvista,
      required this.historicoAPrazo});

  @override
  List<Object?> get props => [
        qualMelhor,
        produtoMaisLucroAVista,
        produtoMaisLucroAPrazo,
        parcelas,
        valorAVista,
        valorAPrazo,
        historicoAvista,
        historicoAPrazo
      ];
}
