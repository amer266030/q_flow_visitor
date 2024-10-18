import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavInitial());

  int currentIndex = 0;

  void updateIndex(int index) {
    currentIndex = index;
    emitUpdateUI();
  }

  emitUpdateUI() => emit(UpdateUIState());
}
