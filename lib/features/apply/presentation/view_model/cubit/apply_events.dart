import 'package:elevate_tracking_app/core/utils/enums/gender.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';

class ApplyEvents {}

class GetVehiclesEvent extends ApplyEvents {}

class GetCountriesEvent extends ApplyEvents {}

class SelectCountryEvent extends ApplyEvents {
  final CountryEntity country;
  SelectCountryEvent({required this.country});
}

class SelectVehicleEvent extends ApplyEvents {
  final VehicleEntity vehicle;
  SelectVehicleEvent({required this.vehicle});
}

class SelectGenderEvent extends ApplyEvents {
  final Gender gender;
  SelectGenderEvent({required this.gender});
}

class ApplySubmitEvent extends ApplyEvents {
  ApplySubmitEvent();
}
