import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontSize: context.bodyLarge.fontSize,
                  fontWeight: FontWeight.bold,
                  color: context.textColor1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
