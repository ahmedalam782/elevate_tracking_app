import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/core/validations/validations.dart';
import 'package:elevate_tracking_app/features/apply/domain/entities/vehicles_list_entity.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyVehcileField extends StatefulWidget {
  const ApplyVehcileField({super.key, required this.hint, required this.label});

  final String hint;
  final String label;
  @override
  State<ApplyVehcileField> createState() => _ApplyVehcileFieldState();
}

class _ApplyVehcileFieldState extends State<ApplyVehcileField> {
  late ApplyCubit cubit;
  @override
  void initState() {
    cubit = context.read<ApplyCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ApplyCubit, ApplyStates, BaseState<VehiclesListEntity>>(
      selector: (ApplyStates state) => state.vehicleState,

      builder: (BuildContext context, BaseState<VehiclesListEntity> state) {
        bool loading =
            state.state == StateType.loading || state.state == StateType.error;
        return DropdownButtonFormField<VehicleEntity>(
          dropdownColor: AppColors.whiteF9,
          hint: Text(
            loading ? "Loading..." : widget.hint,
            style: 14.regular.copyWith(color: AppColors.grayA6),
          ),
          menuMaxHeight: 300,
          iconSize: 24,
          initialValue: cubit.state.selectedVehicle,
          decoration: InputDecoration(
            labelText: widget.label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: 14.regular.copyWith(color: AppColors.gray53),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray53, width: 1.0),
            ),
          ),

          items: state.data?.vehicles
              .map(
                (VehicleEntity vehicle) => DropdownMenuItem<VehicleEntity>(
                  value: vehicle,
                  child: Text(
                    vehicle.type,
                    style: 16.regular.copyWith(color: AppColors.black0C),
                  ),
                ),
              )
              .toList(),
          onChanged: loading
              ? null
              : (newValue) async {
                  await cubit.doIntent(SelectVehicleEvent(vehicle: newValue!));
                },
          validator: (value) => Validations.validateName(value?.type),
        );
      },
    );
  }
}
