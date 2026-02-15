import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/validations/validations.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_country_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_text_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_vehcile_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/gender_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/upload_field.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/welcome_section.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyBody extends StatefulWidget {
  const ApplyBody({super.key});

  @override
  State<ApplyBody> createState() => _ApplyBodyState();
}

class _ApplyBodyState extends State<ApplyBody> {
  late bool isLoading;

  @override
  Widget build(BuildContext context) {
    isLoading = context.select<ApplyCubit, bool>(
      (ApplyCubit value) => value.state.applyState.state == StateType.loading,
    );
    final formKey = GlobalKey<FormState>();
    ApplyCubit cubit = context.read<ApplyCubit>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 25,
        children: [
          const WelcomeSection(),
          const ApplyCountryField(hint: "Select country", label: "Country"),
          ApplyTextField(
            hint: LocaleKeys.apply_first_name_hint.tr(),
            label: LocaleKeys.apply_first_name_label.tr(),
            controller: cubit.firstNameController,
            textInputType: TextInputType.name,
            validator: (value) => Validations.validateFirstName(value),
          ),
          ApplyTextField(
            hint: LocaleKeys.apply_last_name_hint.tr(),
            label: LocaleKeys.apply_last_name_label.tr(),
            controller: cubit.lastNameController,
            textInputType: TextInputType.name,
            validator: (value) => Validations.validateLastName(value),
          ),
          ApplyVehcileField(
            hint: LocaleKeys.apply_vehicle_type_hint.tr(),
            label: LocaleKeys.apply_vehicle_type_label.tr(),
          ),
          ApplyTextField(
            hint: LocaleKeys.apply_vehicle_number_hint.tr(),
            label: LocaleKeys.apply_vehicle_number_label.tr(),
            controller: cubit.vehicleNumberController,
            textInputType: TextInputType.number,
            validator: (value) => Validations.validateVehicleNumber(value),
          ),
          UploadField(
            hint: LocaleKeys.apply_vehicle_license_hint.tr(),
            label: LocaleKeys.apply_vehicle_license_label.tr(),
            type: UploadType.license,
          ),
          ApplyTextField(
            hint: LocaleKeys.apply_email_hint.tr(),
            label: LocaleKeys.apply_email_label.tr(),
            controller: cubit.emailController,
            textInputType: TextInputType.emailAddress,
            validator: (value) => Validations.validateEmail(value),
          ),
          ApplyTextField(
            hint: LocaleKeys.apply_phone_hint.tr(),
            label: LocaleKeys.apply_phone_label.tr(),
            controller: cubit.phoneController,
            textInputType: TextInputType.number,
            validator: (value) =>
                Validations.validatePhoneNumber(value, 11, "+20"),
          ),
          ApplyTextField(
            hint: LocaleKeys.apply_id_number_hint.tr(),
            label: LocaleKeys.apply_id_number_label.tr(),
            controller: cubit.NIDController,
            textInputType: TextInputType.number,
            validator: (value) => Validations.validateNationalId(value),
          ),
          UploadField(
            type: UploadType.NID,
            hint: LocaleKeys.apply_id_image_hint.tr(),
            label: LocaleKeys.apply_id_image_label.tr(),
          ),

          Row(
            spacing: 17,
            children: [
              Expanded(
                child: ApplyTextField(
                  hint: LocaleKeys.apply_password_hint.tr(),
                  label: LocaleKeys.apply_password_label.tr(),
                  controller: cubit.passwordController,
                  textInputType: TextInputType.name,
                  validator: (value) => Validations.validatePassword(value),
                ),
              ),
              Expanded(
                child: ApplyTextField(
                  hint: LocaleKeys.apply_confirm_password_hint.tr(),
                  label: LocaleKeys.apply_confirm_password_label.tr(),
                  controller: cubit.rePasswordController,
                  textInputType: TextInputType.name,
                  validator: (value) =>
                      Validations.validatePasswordVerification(
                        value,
                        cubit.passwordController.text,
                      ),
                ),
              ),
            ],
          ),
          const GenderSection(),
          CustomButton(
            isLoading: isLoading,
            title: LocaleKeys.apply_submit.tr(),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await cubit.doIntent(ApplySubmitEvent());
                if (cubit.state.applyState.state == StateType.success &&
                    context.mounted) {
                  //  context.go(Routes.home);
                } else if (cubit.state.applyState.state == StateType.error &&
                    context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(cubit.state.errorMessage)),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
