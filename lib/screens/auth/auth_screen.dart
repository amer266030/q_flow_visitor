import 'package:flutter/material.dart';
import 'package:q_flow/reusable_components/primary_btn.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('Login', style: context.titleLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
