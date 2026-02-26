import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';

abstract class GetCountriesRepository {
  Future<Result<List<CountryEntity>>> getCountries();
}