import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';
import 'package:q_flow/screens/onboarding/onboarding_screen.dart';
import 'package:q_flow/screens/privacy_policy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme_data/app_theme_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  bool isNotificationsEnabled = false;
  bool isDarkMode = true;
  bool isEnglish = true;

  initialLoad(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');
    isDarkMode = (savedTheme == ThemeMode.dark.toString());
    final savedLocale = prefs.getString('locale');
    isEnglish = (savedLocale == 'true');
    emitUpdate();
  }

  navigateToEditProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditProfileScreen()))
        .then((_) {
      // Update Info on page?
    });
  }

  navigateToPrivacyPolicy(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));

  void toggleDarkMode(BuildContext context) {
    print('this was called!');
    isDarkMode = !isDarkMode;
    final themeCubit = context.read<AppThemeCubit>();
    themeCubit.changeTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    emitUpdate();
  }

  void toggleLanguage(BuildContext context) {
    isEnglish = !isEnglish;
    context.setLocale(
        isEnglish ? const Locale('en', 'US') : const Locale('ar', 'SA'));
    _saveLocale(isEnglish);
  }

  Future<void> _saveLocale(bool isEnglish) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', isEnglish ? 'true' : 'false');
  }

  logout(BuildContext context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnboardingScreen()));

  emitUpdate() => emit(UpdateUIState());
}
