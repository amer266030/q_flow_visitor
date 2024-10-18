import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class OvalToggleButtons extends StatelessWidget {
  const OvalToggleButtons({
    super.key,
    required this.currentIndex,
    required this.tabs,
    required this.callback,
  });
  final int currentIndex;
  final List<String> tabs;
  final ValueChanged<int> callback;

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected =
        List.generate(tabs.length, (index) => index == currentIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.bg1,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ToggleButtons(
            isSelected: isSelected,
            onPressed: (idx) => callback(idx),
            borderColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            hoverColor: Colors.transparent,
            fillColor: Colors.transparent,
            splashColor: Colors.transparent, // Remove splash effect
            highlightColor: Colors.transparent, // Remove pressed color
            color: context.bg2, // Default unselected color
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            borderRadius: BorderRadius.circular(100),
            constraints: const BoxConstraints(),
            children: tabs
                .asMap() // Use asMap to get index along with value
                .map((index, str) => MapEntry(
                      index,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8),
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
            context.primary.withOpacity(0.5),
            context.primary.withOpacity(0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: isSelected ? Colors.black : Colors.transparent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 55),
          child: Center(
            child: Text(
              str,
              style: TextStyle(
                fontSize: context.bodyMedium.fontSize,
                color: isSelected ? context.textColor1 : context.textColor3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
