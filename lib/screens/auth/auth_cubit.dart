import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';
import 'package:q_flow/screens/home/home_screen.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  navigate(BuildContext context) {
    // if profile exists
    /// navigate to home
    // else
    /// navigate to edit profile
    _navigateToEditProfile(context);
  }

  _navigateToEditProfile(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EditProfileScreen()));

  _navigateToHome(BuildContext context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
}
