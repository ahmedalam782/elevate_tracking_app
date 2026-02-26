import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';

abstract class GetVehiclesRepository {
  Future<Result<VehiclesListEntity>> getVehicles();
}