import 'package:bloc/bloc.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/features/app_layout/presentation/view_model/cubit/app_layout_state.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/pages/home_page.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayoutCubit extends Cubit<AppLayoutState> {
  AppLayoutCubit() : super(AppLayoutInitial());
  int index = 0;
  List<Widget> pages = [
    BlocProvider(
      lazy: false,
      create: (_) =>
          HomeCubit(getPendingOrdersUseCase: getIt<GetPendingOrdersUseCase>()),
      child: const HomePage(),
    ),
    // HomePage()
    Container(),
    Container(),
  ];
  void changeIndex(int index) {
    this.index = index;
    emit(AppLayoutInitial());
  }
}
