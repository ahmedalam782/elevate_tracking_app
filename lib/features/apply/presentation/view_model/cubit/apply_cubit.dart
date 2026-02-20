// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/errors/handle_errors/handle_errors.dart';
import 'package:elevate_tracking_app/core/utils/enums/gender.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_countries_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_vehicles_use_case.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApplyCubit extends Cubit<ApplyStates> {
  final ApplyUseCase applyUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final GetVehiclesUseCase getVehiclesUseCase;

  ApplyCubit(
    this.applyUseCase,
    this.getCountriesUseCase,
    this.getVehiclesUseCase,
  ) : super(const ApplyStates());

  Future<void> doIntent(ApplyEvents event) async {
    if (event is GetCountriesEvent && state.countryState.data == null) {
      await _getCountries();
    } else if (event is GetVehiclesEvent && state.vehicleState.data == null) {
      await _getVehicles();
    } else if (event is SelectCountryEvent) {
      await _selectCountry(event.country);
    } else if (event is SelectVehicleEvent) {
      await _selectVehicle(event.vehicle);
    } else if (event is SelectGenderEvent) {
      await _selectGender(event.gender);
    } else if (event is ApplySubmitEvent) {
      await apply(request: event.request);
    } else if (event is UploadLicenseEvent) {
      _uploadLicense(license: event.image);
    } else if (event is UploadNIdEvent) {
      _uploadNID(NIDImage: event.image);
    }
  }

  Future<void> apply({required ApplyRequest request}) async {
    emit(state.copyWith(applyState: const BaseState.loading()));
    request.phone = _formPhoneNumWithCode(phoneNum: request.phone ?? "");
    request.NIDImage = state.NIDImage;
    request.licenseImage = state.licenseImage;
    request.gender = state.selectedGender;
    request.vehicleType = state.selectedVehicle;
    request.country = state.selectedCountry;

    final result = await applyUseCase.call(request: request);
    result.when(
      success: (data) {
        emit(state.copyWith(applyState: BaseState.success(data)));
      },
      error: (exception) {
        emit(
          state.copyWith(
            errorMessage: handleError(exception),
            applyState: BaseState.error(exception),
          ),
        );
      },
    );
  }

  Future<void> _selectCountry(CountryEntity country) async {
    emit(state.copyWith(selectedCountry: country));
  }

  Future<void> _getCountries() async {
    emit(
      state.copyWith(
        selectedCountry: null,
        countryState: const BaseState.loading(),
      ),
    );
    final result = await getCountriesUseCase.call();
    result.when(
      success: (data) {
        emit(state.copyWith(countryState: BaseState.success(data)));
      },
      error: (exception) {
        emit(
          state.copyWith(
            errorMessage: handleError(exception),
            countryState: BaseState.error(exception),
          ),
        );
      },
    );
  }

  Future<void> _selectVehicle(VehicleEntity vehicle) async {
    emit(state.copyWith(selectedVehicle: vehicle));
  }

  Future<void> _getVehicles() async {
    emit(state.copyWith(vehicleState: const BaseState.loading()));
    final result = await getVehiclesUseCase.call();
    result.when(
      success: (data) {
        emit(state.copyWith(vehicleState: BaseState.success(data)));
      },
      error: (exception) {
        emit(
          state.copyWith(
            errorMessage: handleError(exception),
            vehicleState: BaseState.error(exception),
          ),
        );
      },
    );
  }

  Future<void> _selectGender(Gender gender) async {
    emit(state.copyWith(selectedGender: gender));
  }

  String? _formPhoneNumWithCode({required String phoneNum}) {
    return "+${state.selectedCountry!.phoneCode}$phoneNum";
  }

  void _uploadNID({required File NIDImage}) {
    emit(state.copyWith(NIDImage: NIDImage));
  }

  void _uploadLicense({required File license}) {
    emit(state.copyWith(licenseImage: license));
  }
}
