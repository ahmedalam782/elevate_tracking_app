// ignore_for_file: file_names

import 'dart:developer';

import 'package:elevate_tracking_app/core/config/api/api_executer.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/forget_password/api/api_client/forget_password_api_client.dart';
import 'package:elevate_tracking_app/features/forget_password/data/datasources/forget_password_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/forget_password/data/models/forget_password_response/forget_password_response.dart';
import 'package:elevate_tracking_app/features/forget_password/data/models/reset_password_dto/reset_password_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRemoteDataSourceContract)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSourceContract {
  final ForgetPasswordApiClient forgetPasswordApiClient;

  ForgetPasswordRemoteDataSourceImpl({required this.forgetPasswordApiClient});

  @override
  Future<Result<ForgetPasswordResponse>> sendOtpToEmail(String email) async {
    return await executeApi<ForgetPasswordResponse>(() async {
      final body = {"email": email};
      final response = await forgetPasswordApiClient.sendOtpToEmail(body);
      log("THIS IS EMAIL $body");
      return response;
    });
  }

  @override
  Future<Result<void>> verifyCode(String code) async {
    return await executeApi<void>(() async {
      final body = {"resetCode": code};
      final response = await forgetPasswordApiClient.verifyCode(body);
      return response;
    });
  }

  @override
  Future<Result<void>> resetPassword(ResetPasswordDTo resetPasswordDto) async {
    return await executeApi<void>(() async {
      final response = await forgetPasswordApiClient.resetPassword(
        resetPasswordDto,
      );
      return response;
    });
  }
}
