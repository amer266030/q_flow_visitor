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
  OnboardingCubit(BuildContext context) : super(OnboardingInitial()) {
    initialLoad(context);
  }

  initialLoad(BuildContext context) async {
    var dataMgr = GetIt.I.get<DataMgr>();
    await dataMgr.fetchData();

    print(dataMgr.visitor);
    print(SupabaseMgr.shared.supabase.auth.currentUser?.id);
    if (dataMgr.visitor != null) {
      navigateToHome(context);
    } else if (SupabaseMgr.shared.supabase.auth.currentUser != null) {
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) navigateToEditProfile(context);
    }
  }

  var idx = 0;

  changeIdx() {
    idx += 1;
    emit(UpdateUIState());
  }

  navigateToHome(BuildContext context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const BottomNavScreen()));

  navigateToEditProfile(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EditProfileScreen()));

  navigateToAuth(BuildContext context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));

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
}
