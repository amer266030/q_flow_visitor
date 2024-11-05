import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:q_flow/screens/auth/auth_screen.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';
import 'package:q_flow/screens/onboarding/network_functions.dart';

import '../../extensions/img_ext.dart';
import '../../managers/data_mgr.dart';
import '../../supabase/client/supabase_mgr.dart';
import '../bottom_nav/bottom_nav_screen.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingState? previousState;
  OnboardingCubit(BuildContext context) : super(OnboardingInitial()) {
    initialLoad(context);
  }

  var dataMgr = GetIt.I.get<DataMgr>();

  initialLoad(BuildContext context) async {
    emitLoading();

    try {
      await dataMgr.fetchData();
      await Future.delayed(const Duration(milliseconds: 50));
      if (dataMgr.visitor != null) {
        if (dataMgr.visitor!.externalId == null) {
          await setExternalId();
        }
        OneSignal.login(dataMgr.visitor!.externalId!);
        if (context.mounted) navigateToHome(context);
      } else if (SupabaseMgr.shared.supabase.auth.currentUser != null) {
        if (context.mounted) navigateToEditProfile(context);
      } else {
        emitUpdate();
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  var idx = 0;

  changeIdx() {
    idx += 1;
    emitUpdate();
  }

  navigateToHome(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        (route) => false,
      );

  navigateToEditProfile(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        (route) => false,
      );

  navigateToAuth(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );

  final List<AssetImage> images = [Img.ob1, Img.ob2, Img.ob3];
  final List<(String, String)> content = [
    (
      'Discover \nOpportunities',
      'Explore top companies and find the right job opportunities at your next career fair.'
    ),
    (
      'Pre-Book \nInterviews',
      'Secure your interview slots in advance and plan your schedule effortlessly.'
    ),
    (
      'Real-Time \nUpdates',
      'Stay informed with real-time notifications and manage your interviews on the go'
    )
  ];

  @override
  void emit(OnboardingState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
