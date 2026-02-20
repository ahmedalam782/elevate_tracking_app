
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/routes/app_router.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_theme.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_country_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_vehcile_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/gender_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/upload_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/welcome_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock ApplyCubit manually to handle fields and method tracking
class MockApplyCubit extends MockCubit<ApplyStates> implements ApplyCubit {

}

void main() {
  late MockApplyCubit mockApplyCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockApplyCubit = MockApplyCubit();
  });

  //   tearDown(() {
  //     mockApplyCubit.close();
  //   });


   Widget buildTestWidget() {
    AppTypography.setLocale('en');
    AppTypography.setTheme(Brightness.light);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.whiteF9,
        systemNavigationBarColor: AppColors.whiteF9,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // mobile size
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, Widget? child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.light,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
            ),
          );
        },
      ),
    );
  }


  group('ApplyBody Widget Tests', () {
    testWidgets('renders all sections and fields correctly', (tester) async {
      whenListen(
        mockApplyCubit,
        Stream.fromIterable([const ApplyStates()]),
        initialState: const ApplyStates(),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify sections exist
      expect(find.byType(WelcomeSection), findsOneWidget);
      expect(find.byType(ApplyCountryField), findsOneWidget);
      expect(find.byType(ApplyVehcileField), findsOneWidget);
      expect(find.byType(GenderSection), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);

      // Verify text fields exist
      expect(find.byType(TextFormField), findsAtLeastNWidgets(5));
      expect(find.byType(UploadField), findsNWidgets(2));
    });

    // testWidgets('triggers validation on submit with empty fields', (
    //   tester,
    // ) async {
    //   whenListen(
    //     mockApplyCubit,
    //     Stream.fromIterable([const ApplyStates()]),
    //     initialState: const ApplyStates(),
    //   );

    //   await tester.pumpWidget(buildTestWidget());
    //   await tester.pumpAndSettle();

    //   final button = find.byType(CustomButton);
    //   await tester.ensureVisible(button);
    //   await tester.tap(button);
    //   await tester.pumpAndSettle();

    //   // Verify doIntent was NOT called because validation should fail
    //   expect(mockApplyCubit.doIntentCallCount, 0);

    //   // Verify validation error messages are displayed.
    //   // We check for the English string "First name is required" as we use English locale.
    //   expect(find.text("First name is required"), findsAtLeastNWidgets(1));
    // });

    // testWidgets(
    //   'calls doIntent when submit button is pressed with valid data',
    //   (tester) async {
    //     whenListen(
    //       mockApplyCubit,
    //       Stream.fromIterable([const ApplyStates()]),
    //       initialState: const ApplyStates(),
    //     );

    //     await tester.pumpWidget(buildTestWidget());
    //     await tester.pumpAndSettle();

    //     // Fill in valid data directly to controllers
    //     mockApplyCubit.firstNameController.text = "John";
    //     mockApplyCubit.lastNameController.text = "Doe";
    //     mockApplyCubit.emailController.text = "john.doe@example.com";
    //     // Phone: 11 digits, not starting with 0 (based on validation logic)
    //     mockApplyCubit.phoneController.text = "11123456789";
    //     mockApplyCubit.vehicleNumberController.text = "1234ABC";
    //     mockApplyCubit.NIDController.text = "12345678901234"; // 14 digits
    //     mockApplyCubit.passwordController.text =
    //         "Password123!"; // Needs special char
    //     mockApplyCubit.rePasswordController.text = "Password123!";

    //     // Re-pump to ensure controllers text is reflected
    //     await tester.pump();

    //     // Submit
    //     final button = find.byType(CustomButton);
    //     await tester.ensureVisible(button);
    //     await tester.tap(button);
    //     await tester.pumpAndSettle();

    //     // Check if doIntent called
    //     expect(mockApplyCubit.doIntentCallCount, 1);
    //     expect(mockApplyCubit.lastEvent, isA<ApplySubmitEvent>());
    //   },
    // );

    // testWidgets(
    //   'Ensuring validation logic passes calls doIntent (via UI interaction)',
    //   (tester) async {
    //     whenListen(
    //       mockApplyCubit,
    //       Stream.fromIterable([const ApplyStates()]),
    //       initialState: const ApplyStates(),
    //     );

    //     await tester.pumpWidget(buildTestWidget());
    //     await tester.pumpAndSettle();

    //     // Manually enter text properly
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_first_name_label.tr(),
    //       ),
    //       'John',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_last_name_label.tr(),
    //       ),
    //       'Doe',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(TextFormField, LocaleKeys.apply_email_label.tr()),
    //       'test@email.com',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(TextFormField, LocaleKeys.apply_phone_label.tr()),
    //       '11123456789',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_vehicle_number_label.tr(),
    //       ),
    //       '123ABC',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_id_number_label.tr(),
    //       ),
    //       '12345678901234',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_password_label.tr(),
    //       ),
    //       'Pass1234!',
    //     );
    //     await tester.enterText(
    //       find.widgetWithText(
    //         TextFormField,
    //         LocaleKeys.apply_confirm_password_label.tr(),
    //       ),
    //       'Pass1234!',
    //     );

    //     await tester.pump();

    //     final button = find.byType(CustomButton);
    //     await tester.ensureVisible(button);
    //     await tester.tap(button);
    //     await tester.pumpAndSettle();

    //     expect(mockApplyCubit.doIntentCallCount, 1);
    //   },
    // );
  });
}
