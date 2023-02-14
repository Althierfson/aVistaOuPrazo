import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/taxas.dart';

class TaxasModel extends Taxas {
  const TaxasModel({required super.cdi, required super.selic});

  factory TaxasModel.fromJson(Map<String, dynamic> json) {
    return TaxasModel(cdi: json['cdi_daily'], selic: json['selic_daily']);
  }

  Map<String, dynamic> toJson() => {'cdi_daily': cdi, 'selic_daily': selic};
}
