import 'dart:convert';

import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/environment.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:http/http.dart' as http;

class VistaOuPrazoRemoteDataSourceImpl extends VistaOuPrazoRemoteDataSource {
  final http.Client client;
  final Environment environment;

  VistaOuPrazoRemoteDataSourceImpl(
      {required this.client, required this.environment});

  @override
  Future<TaxasModel> getRemoteTaxas() async {
    http.Response response;
    try {
      response = await client.get(Uri.parse(environment.urlFinal));
    } on Exception {
      throw AcessoAPIFalha();
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      List jsonResults = json['results'];
      return TaxasModel.fromJson(jsonResults[0]);
    } else {
      throw AcessoAPIFalha();
    }
  }
}
