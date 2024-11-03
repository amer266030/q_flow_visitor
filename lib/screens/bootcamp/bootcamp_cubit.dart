import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/model/enums/bootcamp.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';

part 'bootcamp_state.dart';

class BootcampCubit extends Cubit<BootcampState> {
  BootcampState? previousState;
  BootcampCubit() : super(BootcampInitial());

  var dataMgr = GetIt.I.get<DataMgr>();
  Bootcamp? bootcamp;

  initialLoad() {
    bootcamp = dataMgr.visitor?.bootcamp;
  }

  navigateToBottomNav(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
        (route) => false,
      );

  bootcampTapped(Bootcamp bootcamp) {
    this.bootcamp = bootcamp;
    emitUpdate();
  }

  @override
  void emit(BootcampState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
