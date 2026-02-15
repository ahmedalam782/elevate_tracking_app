import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/apply_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class ApplyUseCase {
  final ApplyRepository repository;
  ApplyUseCase(this.repository);
  Future<Result<ApplyResponse>> call({required ApplyRequest request}) => repository.apply(request: request);
}