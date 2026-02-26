import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/core/validations/validations.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/country_entity.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyCountryField extends StatefulWidget {
  const ApplyCountryField({super.key, this.hint, this.label});

  final String? hint;
  final String? label;
  @override
  State<ApplyCountryField> createState() => _ApplyCountryFieldState();
}

class _ApplyCountryFieldState extends State<ApplyCountryField> {
  late ApplyCubit cubit;
  @override
  void initState() {
    cubit = context.read<ApplyCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ApplyCubit,
      ApplyStates,
      BaseState<List<CountryEntity>>
    >(
      selector: (ApplyStates state) => state.countryState,

      builder: (BuildContext context, BaseState<List<CountryEntity>> state) {
        bool loading =
            state.state == StateType.loading || state.state == StateType.error;
        return DropdownButtonFormField<CountryEntity>(
          dropdownColor: AppColors.whiteF9,
          hint: Text(
            loading ? "Loading..." : widget.hint ?? "",
            style: 14.regular.copyWith(color: AppColors.grayA6),
          ),
          menuMaxHeight: 300,
          iconSize: 24,
          initialValue: cubit.state.selectedCountry,
          decoration: InputDecoration(
            labelText: widget.label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            focusColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray53, width: 1.0),
            ),
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: 14.regular.copyWith(color: AppColors.gray53),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray53, width: 1.0),
            ),
          ),

          items: state.data?.map((CountryEntity country) {
            return DropdownMenuItem<CountryEntity>(
              value: country,
              child: Text(
                country.name,
                style: 16.regular.copyWith(color: AppColors.black0C),
              ),
            );
          }).toList(),

          onChanged: (newValue) async {
            await cubit.doIntent(SelectCountryEvent(country: newValue!));
          },
          validator: (value) => Validations.validateName(value?.name),
        );
      },
    );
  }
}
