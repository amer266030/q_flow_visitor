import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../model/user/visitor.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [Text('Profile')],
          ),
        ),
      ),
    );
  }
}

class _ImgView extends StatelessWidget {
  const _ImgView({required this.visitor});

  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            color: context.bg3,
            width: 120,
            height: 120,
            child: visitor?.avatarUrl == null
                ? Image(image: Img.avatar, fit: BoxFit.cover)
                : Image.network(visitor!.avatarUrl!, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
