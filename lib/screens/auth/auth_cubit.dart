import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthState? previousState;
  AuthCubit() : super(AuthInitial());

  var dataMgr = GetIt.I.get<DataMgr>();
  var isOtp = false;
  var emailController = TextEditingController();

  toggleIsOtp() {
    isOtp = !isOtp;
    emitUpdate();
  }

  navigateToHome(BuildContext context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BottomNavScreen()));

  navigateToEditProfile(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EditProfileScreen()));

  @override
  void emit(AuthState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitLoading() => emit(LoadingState());
  emitUpdate() => emit(UpdateUIState());
  emitError(String msg) => emit(ErrorState(msg));
}
