import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_body.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';

import 'package:elevate_tracking_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_countries_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_vehicles_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_countries_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_vehicles_repository.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/apply_repository.dart';

class FakeApplyUseCase implements ApplyUseCase {
  Result<ApplyResponse>? _response;
  ApplyRequest? lastRequest;
  int callCount = 0;

  void setResponse(Result<ApplyResponse> response) => _response = response;

  @override
  Future<Result<ApplyResponse>> call({required ApplyRequest request}) async {
    callCount++;
    lastRequest = request;
    return _response!;
  }

  @override
  ApplyRepository get repository => throw UnimplementedError();
}

class FakeGetCountriesUseCase implements GetCountriesUseCase {
  Result<List<CountryEntity>>? _response;
  int callCount = 0;

  void setResponse(Result<List<CountryEntity>> response) =>
      _response = response;

  @override
  Future<Result<List<CountryEntity>>> call() async {
    callCount++;
    return _response!;
  }

  @override
  GetCountriesRepository get getCountriesRepository =>
      throw UnimplementedError();
}

class FakeGetVehiclesUseCase implements GetVehiclesUseCase {
  Result<VehiclesListEntity>? _response;
  int callCount = 0;

  void setResponse(Result<VehiclesListEntity> response) => _response = response;

  @override
  Future<Result<VehiclesListEntity>> call() async {
    callCount++;
    return _response!;
  }

  @override
  GetVehiclesRepository get repository => throw UnimplementedError();
}

Future<void> _pumpWidget(WidgetTester tester, ApplyCubit cubit) async {
  await EasyLocalization.ensureInitialized();
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/localization',
      startLocale: const Locale('en'),
      child: MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: ApplyBody()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders ApplyBody and submit button', (tester) async {
    final fakeApply = FakeApplyUseCase();
    final fakeCountries = FakeGetCountriesUseCase();
    final fakeVehicles = FakeGetVehiclesUseCase();

    final cubit = ApplyCubit(
      fakeApply as dynamic,
      fakeCountries as dynamic,
      fakeVehicles as dynamic,
    );

    await _pumpWidget(tester, cubit);

    expect(find.byType(ApplyBody), findsOneWidget);
    expect(find.text(LocaleKeys.apply_submit.tr()), findsOneWidget);
  });
  group("test UI", () {
    testWidgets('submit triggers apply and shows success state', (
      tester,
    ) async {
      final fakeApply = FakeApplyUseCase();
      final fakeCountries = FakeGetCountriesUseCase();
      final fakeVehicles = FakeGetVehiclesUseCase();

      final cubit = ApplyCubit(
        fakeApply as dynamic,
        fakeCountries as dynamic,
        fakeVehicles as dynamic,
      );

      await _pumpWidget(tester, cubit);

      // prepare cubit state to satisfy form validation
      await cubit.doIntent(
        SelectCountryEvent(
          country: const CountryEntity(name: 'C', phoneCode: '1', flag: 'f'),
        ),
      );
      await cubit.doIntent(
        SelectVehicleEvent(
          vehicle: const VehicleEntity(id: 'v', type: 't', image: 'i'),
        ),
      );
      cubit.firstNameController.text = 'FN';
      cubit.lastNameController.text = 'LN';
      cubit.emailController.text = 'e@e.com';
      cubit.phoneController.text = '1234567890';
      cubit.NIDController.text = '12345';
      cubit.passwordController.text = 'password';
      cubit.rePasswordController.text = 'password';

      fakeApply.setResponse(Success(data: ApplyResponse(message: 'ok')));

      await tester.tap(find.text(LocaleKeys.apply_submit.tr()));
      await tester.pumpAndSettle();

      expect(cubit.state.applyState.state, StateType.success);
    });

    testWidgets('submit shows snackbar on error', (tester) async {
      final fakeApply = FakeApplyUseCase();
      final fakeCountries = FakeGetCountriesUseCase();
      final fakeVehicles = FakeGetVehiclesUseCase();

      final cubit = ApplyCubit(
        fakeApply as dynamic,
        fakeCountries as dynamic,
        fakeVehicles as dynamic,
      );

      await _pumpWidget(tester, cubit);

      await cubit.doIntent(
        SelectCountryEvent(
          country: const CountryEntity(name: 'C', phoneCode: '1', flag: 'f'),
        ),
      );
      await cubit.doIntent(
        SelectVehicleEvent(
          vehicle: const VehicleEntity(id: 'v', type: 't', image: 'i'),
        ),
      );
      cubit.firstNameController.text = 'FN';
      cubit.lastNameController.text = 'LN';
      cubit.emailController.text = 'e@e.com';
      cubit.phoneController.text = '1234567890';
      cubit.NIDController.text = '12345';
      cubit.passwordController.text = 'password';
      cubit.rePasswordController.text = 'password';

      fakeApply.setResponse(Error(exception: Exception('fail')));

      await tester.tap(find.text(LocaleKeys.apply_submit.tr()));
      await tester.pumpAndSettle();

      expect(cubit.state.applyState.state, StateType.error);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
