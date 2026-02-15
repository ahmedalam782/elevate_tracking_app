import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_app_bar.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view/widgets/apply_body.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyPage extends StatelessWidget {
  const ApplyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ApplyCubit>()
        ..doIntent(GetCountriesEvent())
        ..doIntent(GetVehiclesEvent()),
      child: Scaffold(
        backgroundColor: AppColors.whiteF9,
        appBar: CustomAppBar(title: LocaleKeys.apply_app_bar_title.tr()),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ApplyBody(),
          ),
        ),
      ),
    );
  }
}
