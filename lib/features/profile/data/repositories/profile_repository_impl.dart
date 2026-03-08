import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/profile/api/datasources/profile_remote_data_source_impl.dart';
import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<DriverEntity>> getProfileData() async {
    try {
      final response = await _remoteDataSource.getProfileData();
      return Success(data: response.driver.toEntity());
    } on Exception catch (e) {
      return Error(exception: e);
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }
}
