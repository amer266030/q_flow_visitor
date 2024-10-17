import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/auth/auth_screen.dart';

import '../../extensions/img_ext.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  var idx = 0;

  changeIdx() {
    idx += 1;
    emit(UpdateUIState());
  }

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
