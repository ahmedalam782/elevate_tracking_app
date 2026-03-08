import 'package:elevate_tracking_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:elevate_tracking_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';


abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> getProfileData();
}

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _apiClient;

  const ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileResponseModel> getProfileData() async {
    try {
      return await _apiClient.getProfileData();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}