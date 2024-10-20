import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileToggleListItem extends StatelessWidget {
  const ProfileToggleListItem(
      {super.key, required this.title, required this.callback});
  final String title;
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
                Icon(CupertinoIcons.circle, color: context.textColor1),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: context.textColor1),
                ),
              ],
            ),
          ),
          Switch(value: false, onChanged: (_) => callback)
        ],
      ),
    );
  }
}
