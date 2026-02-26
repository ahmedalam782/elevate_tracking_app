import 'package:flutter_test/flutter_test.dart';
import 'package:elevate_tracking_app/features/apply/data/repositories/get_vehicles_repository_impl.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/vehicles_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/vehicles_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';

class FakeVehiclesDataSource implements VehiclesDataSourceContract {
  Result<VehiclesResponse>? _response;
  int callCount = 0;

  void setResponse(Result<VehiclesResponse> response) {
    _response = response;
  }

  @override
  Future<Result<VehiclesResponse>> getVehicles() async {
    callCount++;
    return _response!;
  }
}

void main() {
  late FakeVehiclesDataSource fakeDataSource;
  late GetVehiclesRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeVehiclesDataSource();
    repository = GetVehiclesRepositoryImpl(
      applyRemoteDataSourceContract: fakeDataSource,
    );
  });

  test('getVehicles returns mapped VehiclesListEntity on Success', () async {
    final vehicle = Vehicles(id: '1', type: 'car', image: 'img_url');
    final response = VehiclesResponse(message: 'ok', vehicles: [vehicle]);

    fakeDataSource.setResponse(Success(data: response));

    final result = await repository.getVehicles();

    result.when(
      success: (data) {
        expect(data, isNotNull);
        expect(data, isA<VehiclesListEntity>());
        expect(data!.vehicles.length, 1);
        expect(data.vehicles.first.id, '1');
        expect(data.vehicles.first.type, 'car');
      },
      error: (ex) => fail('Expected success but got error'),
    );

    expect(fakeDataSource.callCount, 1);
  });

  test('getVehicles returns Error when data source returns Error', () async {
    final exception = Exception('Failed to load');
    fakeDataSource.setResponse(Error(exception: exception));

    final result = await repository.getVehicles();

    result.when(
      success: (data) => fail('Expected error but got success'),
      error: (ex) {
        expect(ex, isNotNull);
        expect(ex.toString(), contains('Failed to load'));
      },
    );

    expect(fakeDataSource.callCount, 1);
  });
}
