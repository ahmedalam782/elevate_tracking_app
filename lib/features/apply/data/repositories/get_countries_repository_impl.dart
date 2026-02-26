import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/country_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/country_model.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_countries_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GetCountriesRepository)
class GetCountriesRepositoryImpl implements GetCountriesRepository {
  final CountryDataSourceContract countryDataSource;
  GetCountriesRepositoryImpl(this.countryDataSource);
  @override
  Future<Result<List<CountryEntity>>> getCountries() async {
    final result = await countryDataSource.loadCountries();
    return result.when(
      success: (countries) => Success<List<CountryEntity>>(
        data: (countries ?? []).map((e) => e.toEntity()).toList(),
      ),
      error: (exception) => Error<List<CountryEntity>>(exception: exception),
    );
  }
}
