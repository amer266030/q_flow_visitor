import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/screens/auth/auth_screen.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_screen.dart';

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

  bool isLoadingVisible = false;

  initialLoad(BuildContext context) async {
    emitLoading();
    var dataMgr = GetIt.I.get<DataMgr>();
    try {
      await dataMgr.fetchData();
      await Future.delayed(const Duration(milliseconds: 200));
      if (dataMgr.visitor != null) {
        if (context.mounted) navigateToHome(context);
      } else if (SupabaseMgr.shared.supabase.auth.currentUser != null) {
        if (context.mounted) navigateToEditProfile(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  var idx = 0;

  changeIdx() {
    print('current idx: $idx');
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
      'DiscoverOpportunities'.tr(),
      'ExploreTopCompanies'.tr()
    ),
    (
      'PreBookInterviews'.tr(),
      'SecureYour'.tr()
    ),
    (
      'RealTimeUpdates'.tr(),
      'StayInformed'.tr()
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
