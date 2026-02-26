import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/apply_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/apply_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ApplyRepository)
class ApplyRepositoryImpl implements ApplyRepository {
  final ApplyRemoteDataSourceContract applyRemoteDataSourceContract;
  ApplyRepositoryImpl({required this.applyRemoteDataSourceContract});

  @override
  Future<Result<ApplyResponse>> apply({required ApplyRequest request}) async {
    final result = await applyRemoteDataSourceContract.apply(request: request);
    return result.when(
      success: (data) {
        return Success(data: data);
      },
      error: (exception) {
        return Error(exception: exception);
      },
    );
  }
}
