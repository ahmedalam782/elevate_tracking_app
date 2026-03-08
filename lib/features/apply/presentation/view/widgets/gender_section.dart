import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/core/utils/enums/gender.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderSection extends StatefulWidget {
  const GenderSection({super.key, this.showError = false});

  final bool showError;
  static const double _labelFontSize = 18;
  static const double spaceBetween = 8;

  @override
  State<GenderSection> createState() => _GenderSectionState();
}

class _GenderSectionState extends State<GenderSection> {
  late ApplyCubit cubit;
  @override
  void initState() {
    cubit = context.read<ApplyCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ApplyCubit, ApplyStates, Gender>(
      selector: (ApplyStates state) => state.selectedGender,
      builder: (BuildContext context, Gender state) => RadioGroup<Gender>(
        groupValue: state,
        onChanged: (value) {
          cubit.doIntent(SelectGenderEvent(gender: value!));
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.apply_gender_hint.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray53,
                      fontSize: GenderSection._labelFontSize,
                    ),
                  ),
                ),
                const SizedBox(width: GenderSection.spaceBetween),
                Expanded(
                  flex: 3,
                  child: _GenderOption(
                    value: Gender.female,
                    label: LocaleKeys.apply_gender_female.tr(),
                    selectedGender: state,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _GenderOption(
                    value: Gender.male,
                    label: LocaleKeys.apply_gender_male.tr(),
                    selectedGender: state,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.value,
    required this.label,
    required this.selectedGender,
  });

  final Gender value;
  final String label;
  final Gender? selectedGender;
  static const int _animationDuration = 300;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Gender>(value: value),
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: _animationDuration),
            style: 16.regular.copyWith(
              color: selectedGender == value
                  ? AppColors.black0C
                  : AppColors.gray53,
            ),
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
