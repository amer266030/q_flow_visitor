import 'package:flutter/material.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../model/user/company.dart';

class CompanyCardLarge extends StatelessWidget {
  const CompanyCardLarge({
    super.key,
    required this.company,
  });

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: company.logoUrl == null
                    ? Image(image: Img.logoTurquoise, fit: BoxFit.cover)
                    : FadeInImage(
                        placeholder: Img.logoTurquoise,
                        image: NetworkImage(company.logoUrl ?? ''),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image(
                              image: Img.logoTurquoise, fit: BoxFit.cover);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: context.bg2,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          company.name ?? '',
                          style: context.bodyMedium,
                          maxLines: 1,
                          softWrap: true,
                        ),
                        Text(
                          company.description ?? '',
                          style: context.bodySmall,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
