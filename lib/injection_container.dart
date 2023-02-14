import 'package:avistaouaprazo/core/network/network_info.dart';
import 'package:avistaouaprazo/core/util/convert_to_string_real.dart';
import 'package:avistaouaprazo/environment.dart';
import 'package:avistaouaprazo/environment/hgbrasil_environment.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/injection_vista_ou_prazo.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupContainer() async {
  // Dependencias Externas
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ConvertTo>(() => ConvertTo());

  // Environment
  sl.registerLazySingleton<Environment>(() => hgBrasilEnvironment);

  // Feature
  featureVistaOuPrazo(sl);
}
