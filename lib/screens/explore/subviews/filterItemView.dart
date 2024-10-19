import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class FilterItemView extends StatelessWidget {
  const FilterItemView({
    super.key,
    required this.title,
    required this.itemValues,
    this.currentSelection,
    required this.setValueFunc,
    required this.clearValuesFunc,
  });

  final String title;
  final List<String> itemValues;
  final String? currentSelection;
  final Function(String) setValueFunc;
  final VoidCallback clearValuesFunc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: context.bodyMedium.fontSize,
                  fontWeight: context.titleSmall.fontWeight,
                ),
              ),
              TextButton(
                onPressed: clearValuesFunc,
                child: Text(
                  'clear',
                  style: TextStyle(
                    fontSize: context.bodySmall.fontSize,
                    color: context.primary,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: itemValues
                          .map((value) => InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => setValueFunc(value),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: context.bg2,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: (currentSelection == value)
                                                ? context.primary
                                                : context.bg3)),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(value,
                                            style: TextStyle(
                                                fontSize:
                                                    context.bodySmall.fontSize,
                                                color:
                                                    (currentSelection == value)
                                                        ? context.textColor1
                                                        : context.textColor2))),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
