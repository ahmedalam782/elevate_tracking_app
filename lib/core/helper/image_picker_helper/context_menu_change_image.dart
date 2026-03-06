import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_typography.dart';
import '../flutter_context_menu/flutter_context_menu.dart';
import 'image_picker_helper.dart';

class ContextMenuChangeImage extends StatelessWidget {
  const ContextMenuChangeImage({
    super.key,
    this.updateImageFunction,
    this.title,
    this.cropStyle,
    this.initAspectRatio,
    required this.onTapRemoveImage,
    this.imagePath,
    this.child,
  });

  final Future<void> Function(dynamic image)? updateImageFunction;
  final String? title;
  final CropStyle? cropStyle;
  final CropAspectRatioPreset? initAspectRatio;
  final VoidCallback? onTapRemoveImage;
  final String? imagePath;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (details) {
        final entries = <ContextMenuEntry<dynamic>>[
          // Submenu for Change/Add Image with Gallery and Camera options
          MenuItem<dynamic>.submenu(
            trailing: const SizedBox.shrink(),
            backgroundColor: isDark ? AppColors.black : AppColors.whiteFF,
            icon: SvgPicture.asset(
              AppIcons.iconsAddImage,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(
                isDark ? AppColors.black : AppColors.whiteFF,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              imagePath != null
                  ? "global.change_image".tr()
                  : "global.add_image".tr(),
              style: 14.medium,
            ),
            items: [
              MenuItem<dynamic>(
                backgroundColor: isDark ? AppColors.black : AppColors.whiteFF,
                icon: const Icon(Icons.photo_library, size: 24),
                label: Text("global.gallery".tr(), style: 14.medium),
                onSelected: (_) async {
                  if (kIsWeb) {
                    final result = await ImagePickerHelper.pickImageForWeb(
                      context,
                    );
                    if (result.isNotEmpty && result[0] != null) {
                      if (updateImageFunction != null) {
                        await updateImageFunction?.call(result);
                      }
                    }
                  } else {
                    final image = await ImagePickerHelper.getImageFromGallery(
                      title:
                          title ??
                          (imagePath != null
                              ? "global.change_image".tr()
                              : "global.add_image".tr()),
                      cropStyle: cropStyle,
                      initAspectRatio: initAspectRatio,
                    );
                    if (image != null) {
                      if (updateImageFunction != null) {
                        await updateImageFunction?.call(image);
                      }
                    }
                  }
                },
              ),
              if (!kIsWeb)
                MenuItem<dynamic>(
                  backgroundColor: isDark ? AppColors.black : AppColors.whiteFF,
                  icon: const Icon(Icons.camera_alt, size: 24),
                  label: Text("global.camera".tr(), style: 14.medium),
                  onSelected: (_) async {
                    final image = await ImagePickerHelper.getImageFromCamera(
                      title:
                          title ??
                          (imagePath != null
                              ? "global.change_image".tr()
                              : "global.add_image".tr()),
                      cropStyle: cropStyle,
                      initAspectRatio: initAspectRatio,
                    );
                    if (updateImageFunction != null) {
                      await updateImageFunction?.call(image);
                    }
                  },
                ),
            ],
          ),
          if (imagePath != null)
            MenuItem<dynamic>(
              backgroundColor: isDark ? AppColors.black : AppColors.whiteFF,
              icon: SvgPicture.asset(
                AppIcons.iconsDelete,
                width: 24,
                height: 24,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  AppColors.redCC,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                "global.remove_image".tr(),
                style: 14.regular.copyWith(color: AppColors.redCC),
              ),
              textColor: AppColors.redCC,
              onSelected: (_) {
                onTapRemoveImage?.call();
              },
            ),
        ];

        final menu = ContextMenu<dynamic>(
          entries: entries,
          position: details.globalPosition,
          backgroundColor: isDark ? AppColors.black : AppColors.whiteFF,
        );

        showContextMenu<dynamic>(
          context,
          contextMenu: menu,
          onItemSelected: (_) {},
        );
      },
      child:
          child ??
          SvgPicture.asset(
            AppIcons.iconsChangeImage,
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          ),
    );
  }
}
