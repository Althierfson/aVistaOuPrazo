import 'package:avistaouaprazo/features/vistaOuPrazo/data/models/taxas_model.dart';

abstract class VistaOuPrazoLocalDataSource {
  TaxasModel getCachedTaxas();
  Future<bool> cacheTaxas(TaxasModel taxasModel);
  bool cacheIsvalido();
}
