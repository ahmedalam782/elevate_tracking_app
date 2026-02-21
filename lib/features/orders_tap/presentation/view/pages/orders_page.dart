import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/orders_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(LocaleKeys.my_orders_title.tr()),
      ),
      body: const OrdersBody(),
    );
  }
}
