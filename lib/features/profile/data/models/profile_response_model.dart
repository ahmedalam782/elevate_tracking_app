import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  final String message;
  final DriverModel driver;

  const ProfileResponseModel({
    required this.message,
    required this.driver,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}

@JsonSerializable()
class DriverModel {
  final String role;

  @JsonKey(name: '_id')
  final String id;

  final String country;
  final String firstName;
  final String lastName;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleLicense;

  @JsonKey(name: 'NID')
  final String nid;

  @JsonKey(name: 'NIDImg')
  final String nidImg;

  final String email;
  final String gender;
  final String phone;
  final String photo;
  final String createdAt;

  const DriverModel({
    required this.role,
    required this.id,
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleLicense,
    required this.nid,
    required this.nidImg,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.createdAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  DriverEntity toEntity() => DriverEntity(
        role: role,
        id: id,
        country: country,
        firstName: firstName,
        lastName: lastName,
        vehicleType: vehicleType,
        vehicleNumber: vehicleNumber,
        vehicleLicense: vehicleLicense,
        nid: nid,
        nidImg: nidImg,
        email: email,
        gender: gender,
        phone: phone,
        photo: photo,
        createdAt: createdAt,
      );
}