import 'package:json_annotation/json_annotation.dart';

part 'profile_data_model.g.dart';

@JsonSerializable()
class ProfileDataModel {
  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;
  final String role;
  final String? country;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;
  @JsonKey(name: 'NID')
  final String? nid;
  @JsonKey(name: 'NIDImg')
  final String? nidImg;
  final String createdAt;

  ProfileDataModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.role,
    this.country,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    required this.createdAt,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataModelToJson(this);
}