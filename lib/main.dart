import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:q_flow/screens/explore/explore_screen.dart';
import 'package:q_flow/screens/onboarding/onboarding_screen.dart';
import 'package:q_flow/theme_data/app_theme_cubit.dart';
import 'package:q_flow/theme_data/app_themes.dart';

import 'model/company.dart';
import 'model/enums/company_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SupabaseMgr.shared.initialize();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppThemeCubit(),
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            locale: context.locale, // From EasyLocalization
            supportedLocales: context.supportedLocales, // From EasyLocalization
            localizationsDelegates:
                context.localizationDelegates, // From EasyLocalization
            home: BottomNavScreen(),
          );
        },
      ),
    );
  }
}
