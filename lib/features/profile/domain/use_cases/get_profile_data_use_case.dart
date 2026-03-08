import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/profile_repository.dart';

@injectable
class GetProfileDataUseCase {
  final ProfileRepository _repository;

  const GetProfileDataUseCase(this._repository);

  Future<Result<DriverEntity>> call() {
    return _repository.getProfileData();
  }
}
