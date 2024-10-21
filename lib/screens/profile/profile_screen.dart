import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/profile/profile_cubit.dart';
import 'package:q_flow/screens/profile/subviews/profile_header_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_list_item_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_stats_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_toggle_list_item.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(context),
      child: Builder(builder: (context) {
        final cubit = context.read<ProfileCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  ProfileHeaderView(visitor: null),
                  ProfileStatsView(),
                  Divider(color: context.textColor2),
                  ProfileListItemView(
                      title: 'Update profile',
                      callback: () => cubit.navigateToEditProfile(context)),
                  ProfileListItemView(
                      title: 'Privacy policy',
                      callback: () => cubit.navigateToPrivacyPolicy(context)),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          ProfileToggleListItem(
                              title: 'Notifications',
                              value: cubit.isNotificationsEnabled,
                              callback: () =>
                                  cubit.toggleNotifications(context)),
                          ProfileToggleListItem(
                              title: 'Language',
                              value: cubit.isEnglish,
                              callback: () => cubit.toggleLanguage(context)),
                          ProfileToggleListItem(
                              title: 'Theme Mode',
                              value: cubit.isDarkMode,
                              callback: () => cubit.toggleDarkMode(context)),
                        ],
                      );
                    },
                  ),
                  ProfileListItemView(
                      title: 'Logout', callback: () => cubit.logout(context)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
