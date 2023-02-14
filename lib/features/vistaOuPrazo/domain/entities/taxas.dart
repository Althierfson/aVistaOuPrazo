import 'package:equatable/equatable.dart';

class Taxas extends Equatable {
  final double cdi;
  final double selic;

  const Taxas({required this.cdi, required this.selic});

  @override
  List<Object?> get props => [cdi, selic];
}
