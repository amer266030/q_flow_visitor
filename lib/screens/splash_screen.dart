import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/extensions/screen_size.dart';
import 'package:q_flow/screens/onboarding/onboarding_screen.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return AnimatedSplashScreen(
      duration: 2300,
      splashIconSize: context.screenWidth * 0.8,
      splash: Image(
        image: isLightTheme ? Img.splashLight : Img.splashDark,
      ),
      nextScreen: OnboardingScreen(),
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: context.bg1,
    );
  }
}
