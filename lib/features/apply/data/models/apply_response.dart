
import 'package:json_annotation/json_annotation.dart';
part 'apply_response.g.dart';

@JsonSerializable()
class ApplyResponse {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'driver')
  Driver? driver;
  @JsonKey(name: 'token')
  String? token;

  ApplyResponse({this.message, this.driver, this.token});

  factory ApplyResponse.fromJson(Map<String, dynamic> json) => _$ApplyResponseFromJson(json);

  static List<ApplyResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ApplyResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$ApplyResponseToJson(this);
}

@JsonSerializable()
class Driver {
  @JsonKey(name: 'country')
  String? country;
  @JsonKey(name: 'firstName')
  String? firstName;
  @JsonKey(name: 'lastName')
  String? lastName;
  @JsonKey(name: 'vehicleType')
  String? vehicleType;
  @JsonKey(name: 'vehicleNumber')
  String? vehicleNumber;
  @JsonKey(name: 'vehicleLicense')
  String? vehicleLicense;
  @JsonKey(name: 'NID')
  String? nid;
  @JsonKey(name: 'NIDImg')
  String? nidImg;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'gender')
  String? gender;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'photo')
  String? photo;
  @JsonKey(name: 'role')
  String? role;
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'createdAt')
  String? createdAt;

  Driver({this.country, this.firstName, this.lastName, this.vehicleType, this.vehicleNumber, this.vehicleLicense, this.nid, this.nidImg, this.email, this.gender, this.phone, this.photo, this.role, this.id, this.createdAt});

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  static List<Driver> fromList(List<Map<String, dynamic>> list) {
    return list.map(Driver.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}