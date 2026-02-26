import 'package:elevate_tracking_app/core/config/api/api_executer.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/api/api_client/apply_api_client.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/vehicles_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/vehicles_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: VehiclesDataSourceContract)
class VehiclesDataSourceImpl implements VehiclesDataSourceContract {
  final ApplyApiClient applyApiClient;

  VehiclesDataSourceImpl(this.applyApiClient);
  @override
  Future<Result<VehiclesResponse>> getVehicles() async {
    return await executeApi<VehiclesResponse>(
      () async => await applyApiClient.getVehicles(),
    );
  }
}
