import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../theme/app_colors.dart';

class ImagePickerHelper {
  File? file;
  static final ImagePicker picker = ImagePicker();

  static Future<File?> _imageCropper({
    required String sourcePath,
    required String title,
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
    BuildContext? context,
  }) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: AppColors.primerColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: initAspectRatio ?? CropAspectRatioPreset.original,
            lockAspectRatio: false,
            cropStyle: cropStyle ?? CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: title,
            doneButtonTitle: "global.save".tr(),
            cancelButtonTitle: "global.cancel".tr(),
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: false,
            cropStyle: cropStyle ?? CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          if (kIsWeb)
            WebUiSettings(
              context: context!,
              presentStyle: WebPresentStyle.dialog,
              translations: WebTranslations(
                title: title,
                cropButton: "global.save".tr(),
                cancelButton: "global.cancel".tr(),
                rotateLeftTooltip: "global.rotateLeftTooltip".tr(),
                rotateRightTooltip: "global.rotateRightTooltip".tr(),
              ),
            ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch (e) {
      debugPrint('Error cropping image: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _processImage(
    Uint8List rawBytes, {
    String? fileName,
  }) async {
    try {
      final decoded = img.decodeImage(rawBytes);
      if (decoded == null) return null;

      // Resize and compress
      final resized = img.copyResize(decoded, width: 1024); // max width
      final compressedBytes = Uint8List.fromList(
        img.encodeJpg(resized, quality: 85),
      );

      File? tempFile;
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        final tempPath = p.join(
          tempDir.path,
          fileName ?? "image_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
        tempFile = await File(tempPath).writeAsBytes(compressedBytes);
      }

      return {'file': tempFile, 'bytes': compressedBytes, 'fileName': fileName};
    } catch (e) {
      debugPrint("Image processing error: $e");
      return null;
    }
  }

  // Mobile: Camera
  static Future<File?> getImageFromCamera({
    required String title,
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
  }) async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.camera);

      if (picked != null) {
        final croppedFile = await _imageCropper(
          sourcePath: picked.path,
          title: title,
          cropStyle: cropStyle,
          initAspectRatio: initAspectRatio,
        );
        if (croppedFile == null) return null;
        final bytes = await croppedFile.readAsBytes();
        final result = await _processImage(
          bytes,
          fileName: p.basename(picked.path),
        );

        return result?['file'] as File?;
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
    return null;
  }

  // Mobile: Gallery
  static Future<File?> getImageFromGallery({
    required String title,
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
  }) async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        final croppedFile = await _imageCropper(
          sourcePath: picked.path,
          title: title,
          cropStyle: cropStyle,
          initAspectRatio: initAspectRatio,
        );
        if (croppedFile == null) return null;
        final bytes = await croppedFile.readAsBytes();
        if (bytes.lengthInBytes <= 5 * 1024 * 1024) {
          // Return original bytes and fileName without compression
          final tempDir = await getTemporaryDirectory();
          final tempPath = p.join(tempDir.path, p.basename(picked.path));
          final tempFile = await File(tempPath).writeAsBytes(bytes);
          return tempFile;
        }
        final result = await _processImage(
          bytes,
          fileName: p.basename(picked.path),
        );

        return result?['file'] as File?;
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
    }
    return null;
  }

  // Web: Pick and Resize

  static Future<List<dynamic>> pickImageForWeb(BuildContext context) async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        // Check if image size is <= 5MB (5 * 1024 * 1024 bytes)
        if (bytes.lengthInBytes <= 5 * 1024 * 1024) {
          // Return original bytes and fileName without compression
          return [bytes, picked.name];
        }
        final result = await _processImage(bytes, fileName: picked.name);
        return [result?['bytes'], result?['fileName']];
      }
    } catch (e) {
      debugPrint('Web image picker error: $e');
    }
    return [];
  }
}
