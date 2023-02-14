import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/network/network_info.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/repositories/vista_ou_prazo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'vista_ou_prazo_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VistaOuPrazoRemoteDataSource>(),
  MockSpec<VistaOuPrazoLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  MockVistaOuPrazoRemoteDataSource remoteDataSource =
      MockVistaOuPrazoRemoteDataSource();
  MockVistaOuPrazoLocalDataSource localDataSource =
      MockVistaOuPrazoLocalDataSource();
  MockNetworkInfo networkInfo = MockNetworkInfo();
  VistaOuPrazoRepositoryImpl repositoryImpl = VistaOuPrazoRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo);

  setUp(() {
    remoteDataSource = MockVistaOuPrazoRemoteDataSource();
    localDataSource = MockVistaOuPrazoLocalDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = VistaOuPrazoRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo);
  });

  TaxasModel tTaxasModel = const TaxasModel(cdi: 13.75, selic: 13.75);

  group("getTaxas", () {
    group("Sem conexão com a internt", () {
      test("Deve retornar um [Taxas] se não ouver conexão com a internt",
          () async {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
        when(localDataSource.cacheIsvalido()).thenReturn(true);
        when(localDataSource.getCachedTaxas()).thenReturn(tTaxasModel);

        final result = await repositoryImpl.getTaxas();

        result.fold((l) {
          expect(l, 2);
        }, (r) {
          expect(r, tTaxasModel);
        });

        verifyNever(remoteDataSource.getRemoteTaxas());
      });

      test(
          "Deve retornar um [ImpossivelBuscarTaxasFalha] se não ouver taxas armazenadas localmente",
          () async {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
        when(localDataSource.cacheIsvalido()).thenReturn(false);

        final result = await repositoryImpl.getTaxas();

        result.fold((l) {
          expect(l, isA<ImpossivelBuscarTaxasFalha>());
        }, (r) {
          expect(1, 2);
        });

        verifyNever(remoteDataSource.getRemoteTaxas());
        verifyNever(localDataSource.getCachedTaxas());
      });

      test(
          "Deve retornar um [CachedFalha] se não for possivel acessar os dados na locais",
          () async {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
        when(localDataSource.cacheIsvalido()).thenReturn(true);
        when(localDataSource.getCachedTaxas()).thenThrow(CachedFalha());

        final result = await repositoryImpl.getTaxas();

        result.fold((l) {
          expect(l, isA<CachedFalha>());
        }, (r) {
          expect(1, 2);
        });

        verifyNever(remoteDataSource.getRemoteTaxas());
      });
    });

    group("Com conexão com internt", () {
      group("Sucessos", () {
        test(
            "Deve retornar um [Taxas] vindo de localDataSouce se a cache for valida",
            () async {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          when(localDataSource.cacheIsvalido()).thenReturn(true);
          when(localDataSource.getCachedTaxas()).thenReturn(tTaxasModel);

          final result = await repositoryImpl.getTaxas();

          result.fold((l) {
            expect(1, 2);
          }, (r) {
            expect(r, tTaxasModel);
          });

          verifyNever(remoteDataSource.getRemoteTaxas());
        });

        test(
            "Deve retornar um [Taxas] vindo de remoteDataSouce se a cache for invalida",
            () async {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          when(localDataSource.cacheIsvalido()).thenReturn(false);
          when(remoteDataSource.getRemoteTaxas())
              .thenAnswer((_) async => tTaxasModel);

          final result = await repositoryImpl.getTaxas();

          result.fold((l) {
            expect(1, 2);
          }, (r) {
            expect(r, tTaxasModel);
          });

          verifyNever(localDataSource.getCachedTaxas());
          verify(localDataSource.cacheTaxas(tTaxasModel)).called(1);
        });

        test(
            "Deve retornar um [Taxas] caso não seja possivel acessa a cache mas houver internt",
            () async {
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          when(localDataSource.cacheIsvalido()).thenReturn(true);
          when(localDataSource.getCachedTaxas()).thenThrow(CachedFalha());
          when(remoteDataSource.getRemoteTaxas())
              .thenAnswer((_) async => tTaxasModel);

          final result = await repositoryImpl.getTaxas();

          result.fold((l) {
            expect(l, 2);
          }, (r) {
            expect(r, tTaxasModel);
          });
        });
      });
    });

    group("Falhas", () {
      test(
          "Deve retornar um [AcessoAPIFalha] se não for possivel acessa API e não houver dados locais",
          () async {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
        when(localDataSource.cacheIsvalido()).thenReturn(false);
        when(remoteDataSource.getRemoteTaxas()).thenThrow(AcessoAPIFalha());

        final result = await repositoryImpl.getTaxas();

        result.fold((l) {
          expect(l, isA<AcessoAPIFalha>());
        }, (r) {
          expect(r, tTaxasModel);
        });

        verifyNever(localDataSource.getCachedTaxas());
      });
    });
  });
}
