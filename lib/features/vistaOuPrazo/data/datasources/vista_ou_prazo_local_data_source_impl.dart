import 'dart:convert';

import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Chaves SharedPreferences
const dataKey = "dataKey";
const taxasKey = "taxasKey";

class VistaOuPrazoLocalDataSourceImpl extends VistaOuPrazoLocalDataSource {
  final SharedPreferences sharedPreferences;

  VistaOuPrazoLocalDataSourceImpl(this.sharedPreferences);

  @override
  bool cacheIsvalido() {
    String? valor = sharedPreferences.getString(dataKey);
    if (valor != null) {
      DateTime dateTimePass = DateTime.parse(valor);
      DateTime dateTimeNow = DateTime.now();

      if (dateTimeNow.difference(dateTimePass).inDays < 30) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<bool> cacheTaxas(TaxasModel taxasModel) async {
    await sharedPreferences.setString(
        dataKey, DateTime.now().toIso8601String());
    return await sharedPreferences.setString(
        taxasKey, jsonEncode(taxasModel.toJson()));
  }

  @override
  TaxasModel getCachedTaxas() {
    String? valor = sharedPreferences.getString(taxasKey);

    if (valor != null) {
      Map<String, dynamic> json = jsonDecode(valor);
      return TaxasModel.fromJson(json);
    } else {
      throw CachedFalha();
    }
  }
}
