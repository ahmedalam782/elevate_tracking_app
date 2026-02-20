// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/core/validations/validations.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_cubit.dart';
import 'package:elevate_tracking_app/features/apply/presentation/view_model/cubit/apply_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

enum UploadType { license, NID }

class UploadField extends StatefulWidget {
  const UploadField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.label,
    required this.type,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? label;
  final UploadType type;

  @override
  State<UploadField> createState() => _UploadFieldState();
}

class _UploadFieldState extends State<UploadField> {
  late ApplyCubit cubit;
  String? fileName;
  @override
  void initState() {
    cubit = context.read<ApplyCubit>();
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      if (widget.type == UploadType.license) {
        cubit.doIntent(UploadLicenseEvent(image: File(pickedFile.path)));
      } else {
        cubit.doIntent(UploadNIdEvent(image: File(pickedFile.path)));
      }
      setState(() {
        fileName = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      canRequestFocus: false,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _pickImage(ImageSource.gallery);
      },
      decoration: InputDecoration(
        hint: Text(
          (widget.type == UploadType.license
              ? cubit.state.licenseImage?.path.split('/').last ??
                    widget.hint ??
                    ""
              : cubit.state.NIDImage?.path.split('/').last ??
                    widget.hint ??
                    ""),
          style:
              (widget.type == UploadType.license
                      ? cubit.state.licenseImage?.path.split('/').last
                      : cubit.state.NIDImage?.path.split('/').last) !=
                  null
              ? 16.regular.copyWith(color: AppColors.black0C)
              : 14.regular.copyWith(color: AppColors.grayA6),
        ),
        labelText: widget.label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
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
        suffixIcon: IconButton(
          onPressed: null,
          icon: SvgPicture.asset(AppIcons.iconsUpload),
        ),
      ),
      validator: (value) => Validations.validateUserImage(
        widget.type == UploadType.license
            ? cubit.state.licenseImage
            : cubit.state.NIDImage,
      ),
    );
  }
}
