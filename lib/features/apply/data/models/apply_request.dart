// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elevate_tracking_app/core/utils/enums/gender.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';

class ApplyRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  VehicleEntity? vehicleType;
  String? vehicleNumber;
  String? NID;
  Gender gender;
  String? password;
  String? rePassword;
  CountryEntity? country;
  File? licenseImage;
  File? NIDImage;

  ApplyRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.vehicleType,
    this.vehicleNumber,
    this.NID,
    this.NIDImage,
    this.gender = Gender.male,
    this.password,
    this.rePassword,
    this.country,
    this.licenseImage,
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
      'vehicleType': vehicleType?.id,
      'vehicleNumber': vehicleNumber,
      'NID': NID,
      'phone': phone,
      'country': country?.name,
      'gender': gender.label,
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
