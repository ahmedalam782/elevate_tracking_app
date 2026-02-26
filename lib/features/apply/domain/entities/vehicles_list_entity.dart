import 'package:equatable/equatable.dart';

class VehiclesListEntity extends Equatable {
  final List<VehicleEntity> vehicles;
  const VehiclesListEntity({required this.vehicles});
  
  @override
  List<Object?> get props => [vehicles];
}

class VehicleEntity extends Equatable {
  final String type;
  final String image;
  final String id;

  const VehicleEntity({required this.type, required this.image, required this.id});
  
  @override
  List<Object?> get props => [type, image, id];
}
