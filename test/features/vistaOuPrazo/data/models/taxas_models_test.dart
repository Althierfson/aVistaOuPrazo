import 'dart:convert';

import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixtures.dart';

void main() {
  TaxasModel tTaxasModel = const TaxasModel(cdi: 13.65, selic: 13.65);
  Map<String, dynamic> json = jsonDecode(fixture("taxas.json"));

  test("Deve criar um instacia de [TaxasModel] atrazes de um JSON", () {
    TaxasModel result = TaxasModel.fromJson(json);

    expect(result, tTaxasModel);
  });

  test("Deve retornar um json quando a função toJson() for chamada", () {
    final result = tTaxasModel.toJson();

    expect(result, json);
  });
}
