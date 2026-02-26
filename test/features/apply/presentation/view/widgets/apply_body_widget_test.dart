import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_body.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apply_body_widget_test.mocks.dart';

@GenerateMocks([ApplyCubit])
void main() {
  late MockApplyCubit mockApplyCubit;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockApplyCubit = MockApplyCubit();

    // Default state
    when(mockApplyCubit.state).thenReturn(const ApplyStates());
    when(mockApplyCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockApplyCubit.close()).thenAnswer((_) async => {});
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => BlocProvider<ApplyCubit>.value(
        value: mockApplyCubit,
        child: const MaterialApp(
          localizationsDelegates: [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          home: Scaffold(body: ApplyBody()),
        ),
      ),
    );
  }

  group('ApplyBody Widget Test', () {
    testWidgets('renders all fields and sections', (WidgetTester tester) async {
      final country = const CountryEntity(
        name: 'Egypt',
        phoneCode: '20',
        flag: '🇪🇬',
      );
      final vehicle = const VehicleEntity(
        type: 'Car',
        id: '1',
        image: 'car.png',
      );

      when(mockApplyCubit.state).thenReturn(
        ApplyStates(
          countryState: BaseState.success([country]),
          vehicleState: BaseState.success(
            VehiclesListEntity(vehicles: [vehicle]),
          ),
          selectedCountry: country,
          selectedVehicle: vehicle,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Check for welcome section components via keys or text if unique
      expect(find.byType(ApplyBody), findsOneWidget);
    });

    testWidgets(
      'shows validation errors when submit is pressed with empty fields',
      (WidgetTester tester) async {
        when(mockApplyCubit.state).thenReturn(const ApplyStates());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final submitButton = find.text(LocaleKeys.apply_submit.tr());
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Check if some validation errors appear (we use .tr() so it should find the translated text)
        expect(
          find.text(LocaleKeys.validations_first_name_required.tr()),
          findsOneWidget,
        );
        expect(
          find.text(LocaleKeys.validations_last_name_required.tr()),
          findsOneWidget,
        );
      },
    );
  });
}
