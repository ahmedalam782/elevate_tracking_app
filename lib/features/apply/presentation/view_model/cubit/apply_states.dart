import 'dart:io';

import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/utils/enums/gender.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:equatable/equatable.dart';

class ApplyStates extends Equatable {
  final BaseState<List<CountryEntity>> countryState;
  final BaseState<VehiclesListEntity> vehicleState;
  final BaseState<ApplyResponse> applyState;
  final String errorMessage;
  // ignore: non_constant_identifier_names
  final File? NIDImage;
  final File? licenseImage;
  final CountryEntity? selectedCountry;
  final VehicleEntity? selectedVehicle;
  final Gender selectedGender;

  const ApplyStates({
    this.applyState = const BaseState.initial(),
    this.countryState = const BaseState.initial(),
    this.vehicleState = const BaseState.initial(),
    this.selectedCountry,
    this.selectedVehicle,
    this.selectedGender = Gender.male,
    // ignore: non_constant_identifier_names
    this.errorMessage = '',  this.NIDImage,  this.licenseImage,
  });

  ApplyStates copyWith({
    BaseState<List<CountryEntity>>? countryState,
    BaseState<VehiclesListEntity>? vehicleState,
    BaseState<ApplyResponse>? applyState,
    CountryEntity? selectedCountry,
    VehicleEntity? selectedVehicle,
    Gender? selectedGender,
    String? errorMessage,
    // ignore: non_constant_identifier_names
    File? NIDImage,
    File? licenseImage
  }) => ApplyStates(
    countryState: countryState ?? this.countryState,
    vehicleState: vehicleState ?? this.vehicleState,
    applyState: applyState ?? this.applyState,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    selectedGender: selectedGender ?? this.selectedGender,
    errorMessage: errorMessage ?? this.errorMessage,
    NIDImage: NIDImage ?? this.NIDImage,
    licenseImage: licenseImage ?? this.licenseImage
  );

  @override
  List<Object?> get props => [
    countryState,
    vehicleState,
    applyState,
    selectedCountry,
    selectedVehicle,
    selectedGender,
    errorMessage,
    NIDImage,
    licenseImage
  ];
}
