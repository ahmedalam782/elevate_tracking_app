import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';


abstract class ProfileRepository {
  Future<Result<DriverEntity>> getProfileData();
}