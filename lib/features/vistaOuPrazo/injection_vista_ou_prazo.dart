import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_local_data_source_impl.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/datasources/vista_ou_prazo_remote_data_source_impl.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/data/repositories/vista_ou_prazo_repository_impl.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/repositories/vista_ou_prazo_repository.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_valor.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/bloc/vistaouprazo_bloc.dart';
import 'package:get_it/get_it.dart';

void featureVistaOuPrazo(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<VistaOuPrazoLocalDataSource>(
      () => VistaOuPrazoLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<VistaOuPrazoRemoteDataSource>(
      () => VistaOuPrazoRemoteDataSourceImpl(client: sl(), environment: sl()));

  // Domain
  sl.registerLazySingleton<VistaOuPrazoRepository>(() =>
      VistaOuPrazoRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // useCase
  sl.registerLazySingleton<CalcularValor>(
      () => CalcularValor(repository: sl(), convertTo: sl()));

  // Bloc
  sl.registerLazySingleton<VistaOuPrazoBloc>(
      () => VistaOuPrazoBloc(calcularValor: sl()));
}
