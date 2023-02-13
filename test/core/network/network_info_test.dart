import 'package:avistaouaprazo/core/network/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
void main() {
  MockDataConnectionChecker connectionChecker = MockDataConnectionChecker();
  NetworkInfoImpl networkInfoimpl = NetworkInfoImpl(connectionChecker);

  setUp(() {
    connectionChecker = MockDataConnectionChecker();
    networkInfoimpl = NetworkInfoImpl(connectionChecker);
  });

  test("isConnect deve ser [false] quando não houver conexão com a internet",
      () async {
    when(connectionChecker.hasConnection).thenAnswer((_) async => false);

    final result = await networkInfoimpl.isConnected;

    expect(result, false);
  });

  test("isConnect deve ser [true] quando houver conexão com a internet",
      () async {
    when(connectionChecker.hasConnection).thenAnswer((_) async => true);

    final result = await networkInfoimpl.isConnected;

    expect(result, true);
  });
}
