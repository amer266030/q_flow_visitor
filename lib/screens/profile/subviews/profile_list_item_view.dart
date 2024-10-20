import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileListItemView extends StatelessWidget {
  const ProfileListItemView(
      {super.key, required this.title, required this.callback});
  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            Icon(
              CupertinoIcons.chevron_right,
              color: context.textColor1,
              size: context.bodyLarge.fontSize,
            )
          ],
        ),
      ),
    );
  }
}
