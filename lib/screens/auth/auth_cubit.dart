import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/reusable_components/animated_snack_bar.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';
import 'package:q_flow/utils/validations.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthState? previousState;
  AuthCubit() : super(AuthInitial());

  var dataMgr = GetIt.I.get<DataMgr>();
  var isOtp = false;
  var emailController = TextEditingController();
    var  pinController = TextEditingController();


  toggleIsOtp() {
    isOtp = !isOtp;
    emitUpdate();
  }

  bool validateEmail(BuildContext context) {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showSnackBar(
          context, 'Email cannot be empty.', AnimatedSnackBarType.warning);
      return false;
    }
    final validationMessage = Validations.email(email);
    if (validationMessage != null) {
      showSnackBar(context, validationMessage, AnimatedSnackBarType.warning);
      return false;
    }
    return true;
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

  void showSnackBar(
      BuildContext context, String msg, AnimatedSnackBarType type) {
    if (context.mounted) {
      animatedSnakbar(msg: msg, type: type).show(context);
    }
  }

  emitLoading() => emit(LoadingState());
  emitUpdate() => emit(UpdateUIState());
  emitError(String msg) => emit(ErrorState(msg));
}
