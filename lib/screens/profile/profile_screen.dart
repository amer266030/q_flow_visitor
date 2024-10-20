import 'package:flutter/material.dart';
import 'package:q_flow/screens/profile/subviews/profile_header_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_list_item_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_stats_view.dart';
import 'package:q_flow/screens/profile/subviews/profile_toggle_list_item.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              ProfileHeaderView(visitor: null),
              ProfileStatsView(),
              Divider(color: context.textColor2),
              ProfileListItemView(title: 'Update profile', callback: () => ()),
              ProfileListItemView(title: 'Privacy policy', callback: () => ()),
              ProfileToggleListItem(title: 'Notifications', callback: () => ()),
              ProfileToggleListItem(title: 'Language', callback: () => ()),
              ProfileToggleListItem(title: 'Theme Mode', callback: () => ()),
              ProfileListItemView(title: 'Logout', callback: () => ()),
            ],
          ),
        ),
      ),
    );
  }
}
