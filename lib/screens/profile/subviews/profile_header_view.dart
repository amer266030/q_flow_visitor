import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../../extensions/img_ext.dart';
import '../../../model/user/visitor.dart';

class ProfileHeaderView extends StatelessWidget {
  const ProfileHeaderView({super.key, required this.visitor});

  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.primary, width: 2),
                  ),
                  width: 140,
                  height: 140,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: visitor?.avatarUrl == null
                        ? ClipOval(
                            child: Image(image: Img.avatar, fit: BoxFit.cover))
                        : Image.network(visitor!.avatarUrl!, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('John Doe', style: context.titleSmall),
                ),
              ],
            ),
          ],
        ),
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => (),
                icon: Icon(CupertinoIcons.qrcode, size: 45)))
      ],
    );
  }
}
