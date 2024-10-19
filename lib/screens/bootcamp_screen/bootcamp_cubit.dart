import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/enums/bootcamp.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';

part 'bootcamp_state.dart';

class BootcampCubit extends Cubit<BootcampState> {
  BootcampCubit() : super(BootcampInitial());

  List<Bootcamp> bootcamps = [];

  navigateToBottomNav(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavScreen()));

  bootcampTapped(Bootcamp bootcamp) {
    bootcamps.contains(bootcamp)
        ? bootcamps.remove(bootcamp)
        : bootcamps.add(bootcamp);
    emitUpdate();
  }

  emitUpdate() => emit(UpdateUIState());
}
