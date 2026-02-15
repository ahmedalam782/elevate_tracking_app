import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ApplyTextField extends StatefulWidget {
  const ApplyTextField({
    super.key,
    this.label,
    this.textInputType,
    this.controller,
    this.hint,
    this.validator,
  });
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  @override
  State<ApplyTextField> createState() => _ApplyTextFieldState();
}

class _ApplyTextFieldState extends State<ApplyTextField> {
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        focusNode: focusNode,
        keyboardType: widget.textInputType,
        maxLines: 1,
        style: 16.regular.copyWith(color: AppColors.black0C),
        decoration: InputDecoration(
          hint: Text(
            widget.hint ?? "",
            style: 14.regular.copyWith(color: AppColors.grayA6),
          ),
          labelText: widget.label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: WidgetStateTextStyle.resolveWith((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.error)) {
              return const TextStyle(color: Colors.red);
            }
            if (states.contains(WidgetState.focused)) {
              return 14.regular.copyWith(color: AppColors.primerColor);
            }
            return 14.regular.copyWith(color: AppColors.gray53);
          }),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.gray53, width: 1.0),
          ),
        ),
      ),
    );
  }
}
