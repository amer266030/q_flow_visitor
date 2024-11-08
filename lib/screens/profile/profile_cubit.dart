import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';
import 'package:q_flow/screens/onboarding/onboarding_screen.dart';
import 'package:q_flow/screens/privacy_policy_screen.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user/visitor.dart';
import '../../theme_data/app_theme_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileState? previousState;
  ProfileCubit(BuildContext context) : super(ProfileInitial()) {
    initialLoad(context);
  }

  var dataMgr = GetIt.I.get<DataMgr>();
  Visitor? visitor;

  bool isNotificationsEnabled = false;
  bool isDarkMode = true;
  bool isEnglish = true;

  initialLoad(BuildContext context) async {
    visitor = dataMgr.visitor;
    final prefs = await SharedPreferences.getInstance();
    isNotificationsEnabled =
        (prefs.getString('notifications').toString() == 'true');
    final savedTheme = prefs.getString('theme');
    isDarkMode = (savedTheme == ThemeMode.dark.toString());
    final savedLocale = prefs.getString('locale');
    isEnglish = (savedLocale == 'en_US' || savedLocale == 'true');
    emitUpdate();
  }

  navigateToEditProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) =>
                EditProfileScreen(isInitialSetup: false, visitor: visitor)))
        .then((_) async {
      try {
        var visitor = await SupabaseVisitor.fetchProfile();
        if (visitor != null) {
          initialLoad(context);
        }
        emitUpdate();
      } catch (_) {}
    });
  }

  navigateToPrivacyPolicy(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));

  void toggleNotifications(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    isNotificationsEnabled = !isNotificationsEnabled;
    await prefs.setString(
        'notifications', isNotificationsEnabled ? 'true' : 'false');
    emitUpdate();
  }

  void toggleLanguage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    isEnglish = !isEnglish;
    await prefs.setString('locale', isEnglish ? 'true' : 'false');
    context.setLocale(
        isEnglish ? const Locale('en', 'US') : const Locale('ar', 'SA'));
    emitUpdate();
  }

  void toggleDarkMode(BuildContext context) {
    isDarkMode = !isDarkMode;
    final themeCubit = context.read<AppThemeCubit>();
    themeCubit.changeTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    emitUpdate();
  }

  navigateToOnBoarding(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );

  @override
  void emit(ProfileState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
