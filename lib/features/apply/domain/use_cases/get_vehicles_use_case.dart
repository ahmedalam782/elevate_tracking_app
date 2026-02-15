import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_vehicles_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetVehiclesUseCase {
  final GetVehiclesRepository repository;
  GetVehiclesUseCase(this.repository);

  Future<Result<VehiclesListEntity>> call() => repository.getVehicles();

}