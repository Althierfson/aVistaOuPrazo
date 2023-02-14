import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';

abstract class VistaOuPrazoRemoteDataSource {
  Future<TaxasModel> getRemoteTaxas();
}

