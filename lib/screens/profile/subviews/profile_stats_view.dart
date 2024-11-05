import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ProfileStatsView extends StatelessWidget {
  const ProfileStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ItemView(number: 25, title: 'Booked'),
          _ItemView(number: 20, title: 'Completed'),
          _ItemView(number: 3, title: 'Cancelled')
        ],
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({required this.number, required this.title});
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$number',
            style: TextStyle(
                fontSize: context.bodyLarge.fontSize,
                fontWeight: FontWeight.bold,
                color: context.textColor1)),
        const SizedBox(height: 8),
        Text(title,
            style: TextStyle(
                fontSize: context.bodySmall.fontSize,
                color: context.textColor2))
      ],
    );
  }
}
