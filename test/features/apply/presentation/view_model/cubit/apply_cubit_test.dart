import 'package:flutter_test/flutter_test.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_countries_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_vehicles_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_countries_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_vehicles_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/apply_repository.dart';

class FakeGetCountriesUseCase implements GetCountriesUseCase {
  Result<List<CountryEntity>>? _response;
  int callCount = 0;

  void setResponse(Result<List<CountryEntity>> response) {
    _response = response;
  }

  @override
  Future<Result<List<CountryEntity>>> call() async {
    callCount++;
    return _response!;
  }

  @override
  GetCountriesRepository get getCountriesRepository =>
      throw UnimplementedError();
}

class FakeGetVehiclesUseCase implements GetVehiclesUseCase {
  Result<VehiclesListEntity>? _response;
  int callCount = 0;

  void setResponse(Result<VehiclesListEntity> response) {
    _response = response;
  }

  @override
  Future<Result<VehiclesListEntity>> call() async {
    callCount++;
    return _response!;
  }

  @override
  GetVehiclesRepository get repository => throw UnimplementedError();
}

class FakeApplyUseCase implements ApplyUseCase {
  Result<ApplyResponse>? _response;
  ApplyRequest? lastRequest;
  int callCount = 0;

  void setResponse(Result<ApplyResponse> response) {
    _response = response;
  }

  @override
  Future<Result<ApplyResponse>> call({required ApplyRequest request}) async {
    callCount++;
    lastRequest = request;
    return _response!;
  }

  @override
  ApplyRepository get repository => throw UnimplementedError();
}

void main() {
  late FakeApplyUseCase fakeApply;
  late FakeGetCountriesUseCase fakeCountries;
  late FakeGetVehiclesUseCase fakeVehicles;
  late ApplyCubit cubit;

  setUp(() {
    fakeApply = FakeApplyUseCase();
    fakeCountries = FakeGetCountriesUseCase();
    fakeVehicles = FakeGetVehiclesUseCase();
    cubit = ApplyCubit(fakeApply, fakeCountries, fakeVehicles);
  });

  test(
    'getCountries emits success state when use case returns success',
    () async {
      final country = const CountryEntity(
        name: 'TestLand',
        phoneCode: '12',
        flag: 'f',
      );
      fakeCountries.setResponse(Success(data: [country]));

      await cubit.doIntent(GetCountriesEvent());

      expect(cubit.state.countryState.state, StateType.success);
      expect((cubit.state.countryState.data ?? []).length, 1);
      expect(cubit.state.countryState.data?.first.name, 'TestLand');
      expect(fakeCountries.callCount, 1);
    },
  );

  test(
    'getVehicles emits success state when use case returns success',
    () async {
      final vehicle = const VehicleEntity(id: 'v1', type: 'car', image: 'img');
      fakeVehicles.setResponse(
        Success(data: VehiclesListEntity(vehicles: [vehicle])),
      );

      await cubit.doIntent(GetVehiclesEvent());

      expect(cubit.state.vehicleState.state, StateType.success);
      expect(cubit.state.vehicleState.data?.vehicles.length, 1);
      expect(cubit.state.vehicleState.data?.vehicles.first.id, 'v1');
      expect(fakeVehicles.callCount, 1);
    },
  );

  test('apply emits success when apply use case returns success', () async {
    // prepare selected country and vehicle
    cubit.doIntent(
      SelectCountryEvent(
        country: const CountryEntity(name: 'C', phoneCode: '9', flag: 'f'),
      ),
    );
    cubit.doIntent(
      SelectVehicleEvent(
        vehicle: const VehicleEntity(id: 'vid', type: 't', image: 'i'),
      ),
    );

    final response = ApplyResponse(message: 'ok');
    fakeApply.setResponse(Success(data: response));

    await cubit.doIntent(ApplySubmitEvent(request: ApplyRequest()));

    expect(cubit.state.applyState.state, StateType.success);
    expect(cubit.state.applyState.data?.message, 'ok');
    expect(fakeApply.lastRequest, isNotNull);
  });

  test('apply emits error when apply use case returns error', () async {
    cubit.doIntent(
      SelectCountryEvent(
        country: const CountryEntity(name: 'C', phoneCode: '9', flag: 'f'),
      ),
    );
    cubit.doIntent(
      SelectVehicleEvent(
        vehicle: const VehicleEntity(id: 'vid', type: 't', image: 'i'),
      ),
    );

    final exception = Exception('fail');
    fakeApply.setResponse(Error(exception: exception));

    await cubit.doIntent(ApplySubmitEvent(request: ApplyRequest()));

    expect(cubit.state.applyState.state, StateType.error);
    expect(cubit.state.errorMessage, isNotEmpty);
  });
}
