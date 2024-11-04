import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/reusable_components/buttons/custom_switch.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../../reusable_components/buttons/custom_icons_switch.dart';

class ProfileToggleListItem extends StatelessWidget {
  const ProfileToggleListItem({
    super.key,
    required this.title,
    required this.value,
    required this.callback,
    this.strItems,
    this.iconItems,
  });
  final String title;
  final bool value;
  final List<String>? strItems;
  final List<IconData>? iconItems;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: context.textColor1),
                ),
              ],
            ),
          ),
          if (strItems != null)
            CustomSwitch(
                value: value,
                option1: strItems![0],
                option2: strItems![1],
                onChanged: (_) => callback())
          else
            CustomIconsSwitch(
                value: value,
                icon1: iconItems![0],
                icon2: iconItems![1],
                onChanged: (_) => callback())
        ],
      ),
    );
  }
}
