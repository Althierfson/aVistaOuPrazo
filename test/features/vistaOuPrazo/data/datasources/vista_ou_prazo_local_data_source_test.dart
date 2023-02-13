import 'dart:convert';

import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source_impl.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'vista_ou_prazo_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  MockSharedPreferences sharedPreferences = MockSharedPreferences();
  VistaOuPrazoLocalDataSourceImpl localDataSourceImpl =
      VistaOuPrazoLocalDataSourceImpl(sharedPreferences);

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSourceImpl = VistaOuPrazoLocalDataSourceImpl(sharedPreferences);
  });

  TaxasModel tTaxasModel = const TaxasModel(cdi: 13.75, selic: 13.75);

  group("getCachedTaxas", () {
    test("Deve retornar um [TaxasModel] quando a função for chamada", () async {
      when(sharedPreferences.getString(any))
          .thenReturn(jsonEncode(tTaxasModel.toJson()));

      final result = localDataSourceImpl.getCachedTaxas();

      expect(result, tTaxasModel);
    });

    test("Deve retornar um [CachedFalha] quando o acesso local falhar", () {
      when(sharedPreferences.getString(any)).thenReturn(null);

      final func = localDataSourceImpl.getCachedTaxas;

      expect(func, throwsA(isA<CachedFalha>()));
    });
  });
  group("cacheTaxas", () {
    test("Deve retornar um [true] quando a função for chamada", () async {
      when(sharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final result = await localDataSourceImpl.cacheTaxas(tTaxasModel);

      expect(result, true);
    });

    test("Deve retornar um [false] quando o acesso local falhar", () async {
      when(sharedPreferences.setString(any, any))
          .thenAnswer((_) async => false);

      final result = await localDataSourceImpl.cacheTaxas(tTaxasModel);

      expect(result, false);
    });
  });
  group("cacheIsvalido", () {
    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimePass = dateTimeNow.subtract(const Duration(days: 31));
    test("Deve retornar um [true] se as taxas forem validas", () {
      when(sharedPreferences.getString(any))
          .thenReturn(dateTimeNow.toIso8601String());

      final result = localDataSourceImpl.cacheIsvalido();

      expect(result, true);
    });

    test("Deve retornar um [false] se as taxas forem invalidas", () {
      when(sharedPreferences.getString(any))
          .thenReturn(dateTimePass.toIso8601String());

      final result = localDataSourceImpl.cacheIsvalido();

      expect(result, false);
    });
  });
}
