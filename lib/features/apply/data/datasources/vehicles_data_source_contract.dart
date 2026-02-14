import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/models/vehicles_response.dart';

abstract class VehiclesDataSourceContract {
  Future<Result<VehiclesResponse>> getVehicles();
}