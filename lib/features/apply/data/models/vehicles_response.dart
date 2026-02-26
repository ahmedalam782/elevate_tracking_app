import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vehicles_response.g.dart';

@JsonSerializable()
class VehiclesResponse {
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'metadata')
  Metadata? metadata;
  @JsonKey(name: 'vehicles')
  List<Vehicles>? vehicles;

  VehiclesResponse({this.message, this.metadata, this.vehicles});

  factory VehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$VehiclesResponseFromJson(json);

  static List<VehiclesResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(VehiclesResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$VehiclesResponseToJson(this);
}

@JsonSerializable()
class Vehicles {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'updatedAt')
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Vehicles({
    this.id,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Vehicles.fromJson(Map<String, dynamic> json) =>
      _$VehiclesFromJson(json);

  static List<Vehicles> fromList(List<Map<String, dynamic>> list) {
    return list.map(Vehicles.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$VehiclesToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: 'currentPage')
  int? currentPage;
  @JsonKey(name: 'totalPages')
  int? totalPages;
  @JsonKey(name: 'limit')
  int? limit;
  @JsonKey(name: 'totalItems')
  int? totalItems;
  @JsonKey(name: 'nextPage')
  int? nextPage;

  Metadata({
    this.currentPage,
    this.totalPages,
    this.limit,
    this.totalItems,
    this.nextPage,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  static List<Metadata> fromList(List<Map<String, dynamic>> list) {
    return list.map(Metadata.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

extension VehiclesResponseMapper on VehiclesResponse {
  VehiclesListEntity toEntity() {
    return VehiclesListEntity(
      vehicles: (vehicles ?? []).map((e) => e.toEntity()).toList(),
    );
  }
}

extension VehiclesMapper on Vehicles {
  VehicleEntity toEntity() {
    return VehicleEntity(id: id ?? "", type: type ?? "", image: image ?? "");
  }
}
