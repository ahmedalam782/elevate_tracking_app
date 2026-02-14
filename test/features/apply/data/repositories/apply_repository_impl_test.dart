import 'package:flutter_test/flutter_test.dart';
// Using a simple fake instead of Mockito to avoid matcher issues
import 'package:elevate_tracking_app/features/apply/data/repositories/apply_repository_impl.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/apply_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';

class FakeApplyRemoteDataSourceContract
    implements ApplyRemoteDataSourceContract {
  Result<ApplyResponse>? _response;
  int callCount = 0;

  void setResponse(Result<ApplyResponse> response) {
    _response = response;
  }

  @override
  Future<Result<ApplyResponse>> apply({required ApplyRequest request}) async {
    callCount++;
    return _response!;
  }
}

void main() {
  late FakeApplyRemoteDataSourceContract mockRemote;
  late ApplyRepositoryImpl repository;

  setUp(() {
    mockRemote = FakeApplyRemoteDataSourceContract();
    repository = ApplyRepositoryImpl(applyRemoteDataSourceContract: mockRemote);
  });

  test('apply returns Success when remote returns Success', () async {
    final request = ApplyRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '123456',
      vehicleType: 'car',
      vehicleNumber: 'ABC123',
      NID: 'NID123',
      NIDImage: null,
      gender: 'M',
      password: 'pass',
      rePassword: 'pass',
      country: 'Country',
      licenseImage: null,
    );

    final response = ApplyResponse(
      message: 'ok',
      driver: Driver(firstName: 'John'),
      token: 'token',
    );

    mockRemote.setResponse(Success(data: response));

    final result = await repository.apply(request: request);

    expect(mockRemote.callCount, 1);

    result.when(
      success: (data) {
        expect(data, isNotNull);
        expect(data?.message, 'ok');
        expect(data?.token, 'token');
      },
      error: (exception) => fail('Expected success but got error'),
    );

    // call count asserted above
  });

  test('apply returns Error when remote returns Error', () async {
    final request = ApplyRequest(
      firstName: 'Jane',
      lastName: 'Roe',
      email: 'jane@example.com',
      phone: '654321',
      vehicleType: 'bike',
      vehicleNumber: 'XYZ789',
      NID: 'NID789',
      NIDImage: null,
      gender: 'F',
      password: 'pass',
      rePassword: 'pass',
      country: 'Country',
      licenseImage: null,
    );

    final exception = Exception('Network failure');

    mockRemote.setResponse(Error(exception: exception));

    final result = await repository.apply(request: request);

    expect(mockRemote.callCount, 1);

    result.when(
      success: (data) => fail('Expected error but got success'),
      error: (ex) {
        expect(ex, isNotNull);
        expect(ex.toString(), contains('Network failure'));
      },
    );

    // call count asserted above
  });
}
