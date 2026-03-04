import 'package:elevate_tracking_app/features/app_layout/presentation/view_model/cubit/app_layout_state.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/pages/orders_page.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/pages/home_page.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayoutCubit extends Cubit<AppLayoutState> {
  AppLayoutCubit() : super(AppLayoutInitial());
  int index = 0;
  List<Widget> pages = [
    const HomePage(),
    // HomePage()
    const OrdersPage(),
    const ProfilePage(),
  ];
  void changeIndex(int index) {
    this.index = index;
    emit(AppLayoutInitial());
  }
}
