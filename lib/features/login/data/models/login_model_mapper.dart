import '../../domain/entities/login_response_entity.dart';
import 'login_response_model.dart';

extension LoginResponseModelMapper on LoginResponseModel {
  /// Convert Model to Entity
  LoginResponseEntity toEntity() {
    return LoginResponseEntity(message: message, token: token);
  }
}
