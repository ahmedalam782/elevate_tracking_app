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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApplyCubit extends Cubit<ApplyStates> {
  final ApplyUseCase applyUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final GetVehiclesUseCase getVehiclesUseCase;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController vehicleTypeController;
  TextEditingController vehicleNumberController;
  TextEditingController NIDController;
  TextEditingController genderController;
  TextEditingController passwordController;
  TextEditingController rePasswordController;
  File? NIDImage;
  File? licenseImage;

  ApplyCubit(
    this.applyUseCase,
    this.getCountriesUseCase,
    this.getVehiclesUseCase,
  ) : firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      vehicleTypeController = TextEditingController(),
      vehicleNumberController = TextEditingController(),
      NIDController = TextEditingController(),
      genderController = TextEditingController(),
      passwordController = TextEditingController(),
      rePasswordController = TextEditingController(),
      super(const ApplyStates());

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    vehicleTypeController.dispose();
    vehicleNumberController.dispose();
    NIDController.dispose();
    genderController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    return super.close();
  }

  Future<void> doIntent(ApplyEvents event) async {
    if (event is GetCountriesEvent) {
      await _getCountries();
    } else if (event is GetVehiclesEvent) {
      await _getVehicles();
    } else if (event is SelectCountryEvent) {
      await _selectCountry(event.country);
    } else if (event is SelectVehicleEvent) {
      await _selectVehicle(event.vehicle);
    } else if (event is SelectGenderEvent) {
      await selectGender(event.gender);
    } else if (event is ApplySubmitEvent) {
      await apply();
    }
  }

  Future<void> apply() async {
    emit(state.copyWith(applyState: const BaseState.loading()));
    final result = await applyUseCase.call(
      request: ApplyRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: "+${state.selectedCountry!.phoneCode}${phoneController.text}",
        vehicleType: state.selectedVehicle!.id,
        vehicleNumber: vehicleNumberController.text,
        NID: NIDController.text,
        NIDImage: NIDImage,
        gender: state.selectedGender.label,
        password: passwordController.text,
        rePassword: rePasswordController.text,
        country: state.selectedCountry!.name,
        licenseImage: licenseImage,
      ),
    );
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

  Future<void> selectGender(Gender gender) async {
    emit(state.copyWith(selectedGender: gender));
  }
}
