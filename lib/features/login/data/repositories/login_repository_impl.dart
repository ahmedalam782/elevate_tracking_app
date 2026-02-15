import '../models/login_model_mapper.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/config/base_response/result.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_local_data_source_contract.dart';
import '../datasources/login_remote_data_source_contract.dart';
import '../models/login_request_model.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSourceContract _remoteDataSource;
  final LoginLocalDataSourceContract _localDataSource;

  LoginRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<LoginResponseEntity>> loginUser({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final request = LoginRequestModel(email: email, password: password);
    final result = await _remoteDataSource.loginUser(
      body: request,
      rememberMe: rememberMe,
    );
    return result.when(
      success: (data) async {
        if (data != null) {
          await _localDataSource.saveToken(data.token);
          await _localDataSource.saveRememberMe(rememberMe);
          final entity = data.toEntity();
          return Success<LoginResponseEntity>(data: entity);
        } else {
          return Error<LoginResponseEntity>(
            exception: Exception('Response is null'),
          );
        }
      },
      error: (exception) {
        return Error<LoginResponseEntity>(exception: exception);
      },
    );
  }
}
