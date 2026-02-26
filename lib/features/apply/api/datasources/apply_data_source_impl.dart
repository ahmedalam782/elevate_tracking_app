import 'package:elevate_tracking_app/core/config/api/api_executer.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/api/api_client/apply_api_client.dart';
import 'package:elevate_tracking_app/features/apply/data/datasources/apply_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ApplyRemoteDataSourceContract)
class ApplyDataSourceImpl implements ApplyRemoteDataSourceContract {
  final ApplyApiClient applyApiClient;

  ApplyDataSourceImpl(this.applyApiClient);

  @override
  Future<Result<ApplyResponse>> apply({required ApplyRequest request}) async {
    final formData = await request.toFormData();
    return await executeApi(() async => await applyApiClient.apply(formData));
  }
}
