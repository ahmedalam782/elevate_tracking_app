import 'package:flutter_test/flutter_test.dart';
import 'package:elevate_tracking_app/features/apply/data/repositories/get_countries_repository_impl.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/country_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/country_model.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';

class FakeCountryDataSource implements CountryDataSourceContract {
  Result<List<Country>>? _response;
  int callCount = 0;

  void setResponse(Result<List<Country>> response) {
    _response = response;
  }

  @override
  Future<Result<List<Country>>> loadCountries() async {
    callCount++;
    return _response!;
  }
}

void main() {
  late FakeCountryDataSource fakeDataSource;
  late GetCountriesRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeCountryDataSource();
    repository = GetCountriesRepositoryImpl(fakeDataSource);
  });

  test('getCountries returns mapped CountryEntity list on Success', () async {
    final country = Country(
      isoCode: 'US',
      name: 'United States',
      phoneCode: '+1',
      flag: 'flag_url',
    );
    fakeDataSource.setResponse(Success(data: [country]));

    final result = await repository.getCountries();

    result.when(
      success: (data) {
        expect(data, isNotNull);
        expect(data, isA<List<CountryEntity>>());
        expect(data!.length, 1);
        expect(data.first.name, 'United States');
        expect(data.first.phoneCode, '+1');
      },
      error: (ex) => fail('Expected success but got error'),
    );

    expect(fakeDataSource.callCount, 1);
  });

  test('getCountries returns Error when data source returns Error', () async {
    final exception = Exception('Load failed');
    fakeDataSource.setResponse(Error(exception: exception));

    final result = await repository.getCountries();

    result.when(
      success: (data) => fail('Expected error but got success'),
      error: (ex) {
        expect(ex, isNotNull);
        expect(ex.toString(), contains('Load failed'));
      },
    );

    expect(fakeDataSource.callCount, 1);
  });
}
