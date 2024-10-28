import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthState? previousState;
  AuthCubit() : super(AuthInitial());

  var isOtp = false;
  var emailController = TextEditingController();

  toggleIsOtp() {
    isOtp = !isOtp;
    emitUpdate();
  }

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
