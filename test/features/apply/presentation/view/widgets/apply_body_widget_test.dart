import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/languages/lang.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_request.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/apply_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_countries_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/repositories/get_vehicles_repository.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/apply_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_countries_use_case.dart';
import 'package:elevate_tracking_app/features/apply/domain/use_cases/get_vehicles_use_case.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_body.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_country_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_text_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_vehcile_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/gender_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/upload_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/welcome_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeGetCountriesUseCase implements GetCountriesUseCase {
  @override
  Future<Result<List<CountryEntity>>> call() async =>
      const Success(data: <CountryEntity>[]);

  @override
  GetCountriesRepository get getCountriesRepository =>
      throw UnimplementedError();
}

class FakeGetVehiclesUseCase implements GetVehiclesUseCase {
  @override
  Future<Result<VehiclesListEntity>> call() async =>
      const Success(data: VehiclesListEntity(vehicles: <VehicleEntity>[]));

  @override
  GetVehiclesRepository get repository => throw UnimplementedError();
}

class FakeApplyUseCase implements ApplyUseCase {
  @override
  Future<Result<ApplyResponse>> call({required ApplyRequest request}) async =>
      Success(data: ApplyResponse(message: 'ok'));

  @override
  ApplyRepository get repository => throw UnimplementedError();
}

Widget buildTestWidget(ApplyCubit cubit) {
  return EasyLocalization(
    supportedLocales: const [englishLocale],
    startLocale: englishLocale,
    fallbackLocale: englishLocale,
    path: assetsLocalization,
    child: Builder(
      builder: (BuildContext context) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, Widget? child) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Scaffold(
                body: BlocProvider<ApplyCubit>.value(
                  value: cubit,
                  child: const SingleChildScrollView(child: ApplyBody()),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

void main() {
  late ApplyCubit cubit;

  setUp(() {
    cubit = ApplyCubit(
      FakeApplyUseCase(),
      FakeGetCountriesUseCase(),
      FakeGetVehiclesUseCase(),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ApplyBody', () {
    testWidgets('renders form with all main sections and fields', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(WelcomeSection), findsOneWidget);
      expect(find.byType(ApplyCountryField), findsOneWidget);
      expect(find.byType(ApplyVehcileField), findsOneWidget);
      expect(find.byType(GenderSection), findsOneWidget);
      expect(find.byType(UploadField), findsNWidgets(2));
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('apply state is initial before submit', (tester) async {
      await tester.pumpWidget(buildTestWidget(cubit));
      await tester.pumpAndSettle();

      expect(cubit.state.applyState.state, StateType.initial);
    });
  });
}
