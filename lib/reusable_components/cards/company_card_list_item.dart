import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../model/company.dart';

class CompanyCardListItem extends StatelessWidget {
  const CompanyCardListItem({
    super.key,
    required this.company,
    required this.callback,
    required this.isBookmarked,
  });
  final Company company;
  final bool isBookmarked;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.bg2,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: Img.logoPurple,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(company.name ?? '',
                                style: context.bodyMedium,
                                maxLines: 1,
                                softWrap: true),
                            Text(company.description ?? '',
                                style: context.bodySmall,
                                maxLines: 3,
                                softWrap: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: callback,
                icon: Icon(
                  isBookmarked
                      ? CupertinoIcons.bookmark_fill
                      : CupertinoIcons.bookmark,
                  size: context.titleSmall.fontSize,
                  color: isBookmarked ? context.primary : context.textColor2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
