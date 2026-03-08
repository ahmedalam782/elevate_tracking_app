import 'package:elevate_tracking_app/core/theme/app_icons.dart';

class AppLayoutData {
  final String imagePath;
  final int index;
  final String title;

  AppLayoutData({
    required this.imagePath,
    required this.index,
    required this.title,
  });

  static List<AppLayoutData> getAppLayoutData() {
    return [
      AppLayoutData(imagePath: AppIcons.iconsHome, index: 0, title: "Title 1"),
      AppLayoutData(imagePath: AppIcons.iconsOrders, index: 1, title: "Title 2"),
      AppLayoutData(
        imagePath: AppIcons.iconsProfile,
        index: 2,
        title: "Title 3",
      ),
    ];
  }
}
