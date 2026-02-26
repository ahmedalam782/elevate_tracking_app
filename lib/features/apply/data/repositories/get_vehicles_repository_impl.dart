import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/vehicles_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/vehicles_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_vehicles_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GetVehiclesRepository)
class GetVehiclesRepositoryImpl implements GetVehiclesRepository {
  final VehiclesDataSourceContract applyRemoteDataSourceContract;

  GetVehiclesRepositoryImpl({required this.applyRemoteDataSourceContract});

  @override
  Future<Result<VehiclesListEntity>> getVehicles() async {
    final result = await applyRemoteDataSourceContract.getVehicles();
    return result.when(
      success: (data) {
        return Success<VehiclesListEntity>(
          data: (data ?? VehiclesResponse()).toEntity(),
        );
      },
      error: (exception) {
        return Error<VehiclesListEntity>(exception: exception);
      },
    );
  }
}
