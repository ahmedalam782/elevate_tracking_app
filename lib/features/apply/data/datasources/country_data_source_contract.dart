import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/models/country_model.dart';

abstract class CountryDataSourceContract {
  Future<Result<List<Country>>> loadCountries();
}