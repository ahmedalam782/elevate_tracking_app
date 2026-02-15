
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';

abstract class ApplyRepository {
  Future<Result<ApplyResponse>> apply({required ApplyRequest request});

}
