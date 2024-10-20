import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class ToggleBtnsV2 extends StatelessWidget {
  const ToggleBtnsV2(
      {super.key,
      required this.currentIndex,
      required this.tabs,
      required this.callback});
  final int currentIndex;
  final List<String> tabs;
  final ValueChanged<int> callback;

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected =
        List.generate(tabs.length, (index) => index == currentIndex);
    return Container(
      decoration: BoxDecoration(
        color: context.bg2,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tabs
              .asMap() // Use asMap to get index along with value
              .map((index, str) => MapEntry(
                    index,
                    InkWell(
                      onTap: () => callback(index),
                      child: _ItemView(
                        str: str,
                        isSelected: isSelected[index],
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({required this.str, required this.isSelected});
  final String str;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primary,
            context.primary.withOpacity(0.4),
            context.primary.withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: isSelected ? Colors.black : Colors.transparent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 55),
          child: Center(
            child: Text(
              str,
              style: TextStyle(
                fontSize: context.bodyMedium.fontSize,
                color: isSelected ? context.textColor1 : context.textColor2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
