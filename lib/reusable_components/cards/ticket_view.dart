import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../model/user/company.dart';

class TicketView extends StatelessWidget {
  const TicketView({
    super.key,
    required this.company,
    required this.timeOfBooking,
    required this.positionInQueue,
  });

  final Company company;
  final String timeOfBooking;
  final int positionInQueue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: context.bg2,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                bottom: BorderSide(
                  color: context.textColor1.withOpacity(0.3),
                  width: 1, // Change this to your desired thickness
                ),
              ),
              boxShadow: [
                BoxShadow(
                    color: context.textColor1.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: Offset(2, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: company.logoUrl == null
                            ? Image(image: Img.logoTurquoise, fit: BoxFit.cover)
                            : FadeInImage(
                                placeholder: Img.logoTurquoise,
                                image: NetworkImage(company.logoUrl ?? ''),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image(
                                      image: Img.logoTurquoise,
                                      fit: BoxFit.cover);
                                },
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
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
                )
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: context.bg2,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: context.textColor1.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: Offset(2, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      color: context.bodyMedium.color,
                      size: context.titleSmall.fontSize,
                    ),
                    const SizedBox(width: 4),
                    Text('TimeOfBooking', style: context.bodyMedium).tr(),
                    const SizedBox(width: 8),
                    Text(
                      timeOfBooking,
                      style: TextStyle(
                        fontSize: context.bodyMedium.fontSize,
                        fontWeight: context.titleSmall.fontWeight,
                        color: context.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_3,
                      color: context.bodyMedium.color,
                      size: context.titleSmall.fontSize,
                    ),
                    const SizedBox(width: 4),
                    Text('PositionInQueue', style: context.bodyMedium).tr(),
                    const SizedBox(width: 8),
                    Text(
                      (positionInQueue == -1) ? '...' : '$positionInQueue',
                      style: TextStyle(
                        fontSize: context.bodyMedium.fontSize,
                        fontWeight: context.titleSmall.fontWeight,
                        color: context.primary,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
