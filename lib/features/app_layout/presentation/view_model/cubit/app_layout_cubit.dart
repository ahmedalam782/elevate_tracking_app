import 'package:bloc/bloc.dart';
import 'package:elevate_tracking_app/features/app_layout/presentation/view_model/cubit/app_layout_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppLayoutCubit extends Cubit<AppLayoutState> {
  AppLayoutCubit() : super(AppLayoutInitial());
  int index = 0;
  List<Widget> pages = [Container(), Container(), Container()];
  void changeIndex(int index) {
    this.index = index;
    emit(AppLayoutInitial());
  }
}
