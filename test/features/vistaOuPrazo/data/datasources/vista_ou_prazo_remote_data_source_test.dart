import 'dart:convert';
import 'dart:io';

import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/environment.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source_impl.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixtures.dart';
import 'vista_ou_prazo_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  group("getRemoteTaxas", () {
    MockClient client = MockClient();
    Environment testEnvironment = Environment("chave");
    VistaOuPrazoRemoteDataSourceImpl dataSourceImpl =
        VistaOuPrazoRemoteDataSourceImpl(
            client: client, environment: testEnvironment);

    setUp(() {
      client = MockClient();
      dataSourceImpl = VistaOuPrazoRemoteDataSourceImpl(
          client: client, environment: testEnvironment);
    });

    http.Response tResponse =
        http.Response.bytes(utf8.encode(fixture("taxas_response.json")), 200);

    TaxasModel tTaxasModel = const TaxasModel(cdi: 13.65, selic: 13.65);

    test("Deve retornar um [TaxaModel] quando a função for chamada", () async {
      when(client.get(any)).thenAnswer((_) async => tResponse);

      final result = await dataSourceImpl.getRemoteTaxas();

      expect(result, tTaxasModel);
    });

    test(
        "Deve jogar uma [AcessoAPIFalha] quando não form possivel acesso a API",
        () async {
      tResponse =
          http.Response.bytes(utf8.encode(fixture("taxas_response.json")), 400);
      when(client.get(any)).thenAnswer((_) async => tResponse);

      final func = dataSourceImpl.getRemoteTaxas;

      expect(func(), throwsA(isA<AcessoAPIFalha>()));
    });

    test("Deve retornar um [AcessoAPIFalha] quando houver um exception",
        () async {
      tResponse =
          http.Response.bytes(utf8.encode(fixture("taxas_response.json")), 400);
      when(client.get(any)).thenThrow(const SocketException("falha"));

      final func = dataSourceImpl.getRemoteTaxas;

      expect(func(), throwsA(isA<AcessoAPIFalha>()));
    });
  });
}
