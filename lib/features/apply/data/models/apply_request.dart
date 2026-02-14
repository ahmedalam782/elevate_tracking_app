// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';

class ApplyRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? NID;
  final String? gender;
  final String? password;
  final String? rePassword;
  final String? country;
  final File? licenseImage;
  final File? NIDImage;

  ApplyRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.NID,
    required this.NIDImage,
    required this.gender,
    required this.password,
    required this.rePassword,
    required this.country,
    required this.licenseImage,
  });
}

extension UserRegistrationRequestExtension on ApplyRequest {
  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'rePassword': rePassword,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'NID': NID,
      'phone': phone,
      'country': country,
      'gender': gender,
    };

    if (NIDImage != null) {
      map['NIDImg'] = await MultipartFile.fromFile(
        NIDImage!.path,
        filename: NIDImage!.path.split('/').last,
      );
    }

    if (licenseImage != null) {
      map['vehicleLicense'] = await MultipartFile.fromFile(
        licenseImage!.path,
        filename: licenseImage!.path.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}
