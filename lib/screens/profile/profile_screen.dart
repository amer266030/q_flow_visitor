import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/profile/network_functions.dart';
import 'package:q_flow/screens/profile/profile_cubit.dart';
import 'package:q_flow/screens/profile/subviews/profile_header_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_list_item_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_stats_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_toggle_list_item.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(context),
      child: Builder(builder: (context) {
        final cubit = context.read<ProfileCubit>();
        return BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (cubit.previousState is LoadingState) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }

            if (state is LoadingState) {
              showLoadingDialog(context);
            }

            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return ProfileHeaderView(visitor: cubit.visitor);
                      },
                    ),
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
                                iconItems: [
                                  CupertinoIcons.bell_slash,
                                  CupertinoIcons.bell
                                ],
                                callback: () =>
                                    cubit.toggleNotifications(context)),
                            ProfileToggleListItem(
                                title: 'Language',
                                value: cubit.isEnglish,
                                strItems: ['AR', 'EN'],
                                callback: () => cubit.toggleLanguage(context)),
                            ProfileToggleListItem(
                                title: 'Theme Mode',
                                value: cubit.isDarkMode,
                                iconItems: [
                                  CupertinoIcons.sun_max,
                                  CupertinoIcons.moon
                                ],
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
          ),
        );
      }),
    );
  }
}
