import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_countries_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetCountriesUseCase {
  final GetCountriesRepository getCountriesRepository;

  GetCountriesUseCase({required this.getCountriesRepository});

  Future<Result<List<CountryEntity>>> call() => getCountriesRepository.getCountries();
}