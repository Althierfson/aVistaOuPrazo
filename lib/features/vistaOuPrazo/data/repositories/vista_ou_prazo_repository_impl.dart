import 'package:avistaouaprazo/core/network/network_info.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/taxas.dart';
import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/repositories/vista_ou_prazo_repository.dart';
import 'package:dartz/dartz.dart';

class VistaOuPrazoRepositoryImpl implements VistaOuPrazoRepository {
  final VistaOuPrazoRemoteDataSource remoteDataSource;
  final VistaOuPrazoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VistaOuPrazoRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Falha, Taxas>> getTaxas() async {
    if (await networkInfo.isConnected) {
      final cacheResult = getCache();

      return cacheResult.fold((l) async {
        try {
          final result = await remoteDataSource.getRemoteTaxas();
          localDataSource.cacheTaxas(result);
          return Right(result);
        } on Falha catch (falha) {
          return Left(falha);
        }
      }, (r) {
        return Right(r);
      });
    } else {
      return getCache();
    }
  }

  Either<Falha, Taxas> getCache() {
    if (localDataSource.cacheIsvalido()) {
      try {
        return Right(localDataSource.getCachedTaxas());
      } on Falha catch (falha) {
        return Left(falha);
      }
    } else {
      return Left(ImpossivelBuscarTaxasFalha());
    }
  }
}
