import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/extensions/screen_size.dart';
import 'package:q_flow/screens/home/home_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/cards/company_card_large.dart';
import '../../reusable_components/cards/company_card_list_item.dart';
import '../../reusable_components/cards/ticket_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  _HeaderView(positionInQueue: null),
                  Divider(color: context.textColor3),
                  _SectionHeaderView(title: 'Upcoming Interviews'),
                  SizedBox(
                    height: context.screenWidth * 0.45,
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return CarouselView(
                          backgroundColor: Colors.transparent,
                          itemExtent: context.screenWidth * 0.7,
                          shrinkExtent: context.screenWidth * 0.7,
                          scrollDirection: Axis.horizontal,
                          children: cubit.interviews
                              .map((interview) => TicketView(
                                    timeOfBooking:
                                        interview.timeOfBooking ?? '',
                                    positionInQueue:
                                        interview.positionInQueue ?? 0,
                                    company: cubit.companies.first,
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  _SectionHeaderView(title: 'Suggested For You'),
                  SizedBox(
                    height: context.screenWidth * 0.6,
                    child: CarouselView(
                      backgroundColor: Colors.transparent,
                      itemExtent: context.screenWidth * 0.6,
                      shrinkExtent: context.screenWidth * 0.6,
                      children: cubit.companies
                          .map(
                            (company) => CompanyCardLarge(company: company),
                          )
                          .toList(),
                    ),
                  ),
                  _SectionHeaderView(
                      title: 'Explore Companies',
                      ctaStr: 'View all',
                      callback: () => cubit.navigateToExplore(context)),
                  Column(
                    children: cubit.companies
                        .map((company) => CompanyCardListItem(
                              company: company,
                              isBookmarked: Random().nextBool(),
                              callback: () => (),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _HeaderView extends StatelessWidget {
  const _HeaderView({this.positionInQueue});

  final int? positionInQueue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
              child: Image(image: Img.logoTurquoise, fit: BoxFit.contain)),
        )),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, John Doe',
                  style: context.bodyLarge, maxLines: 1, softWrap: true),
              Text('No upcoming Interviews',
                  style: context.bodyMedium, maxLines: 1, softWrap: true),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.person_3,
                    color: context.textColor2,
                    size: context.titleSmall.fontSize,
                  ),
                  SizedBox(width: 4),
                  Text('Position in queue',
                      style: context.bodySmall, maxLines: 1, softWrap: true),
                  SizedBox(width: 4),
                  Text(
                    positionInQueue == null ? '/NA' : '$positionInQueue',
                    style: TextStyle(
                        color: context.primary,
                        fontSize: context.bodySmall.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: IconButton(
              onPressed: () => (), icon: Icon(CupertinoIcons.qrcode, size: 40)),
        )
      ],
    );
  }
}

class _SectionHeaderView extends StatelessWidget {
  const _SectionHeaderView({required this.title, this.ctaStr, this.callback});

  final String title;
  final String? ctaStr;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.bodyLarge),
          if (ctaStr != null)
            TextButton(
              onPressed: callback!,
              child: Text(
                ctaStr ?? '',
                style: TextStyle(
                  color: context.primary,
                  fontSize: context.bodySmall.fontSize,
                  fontWeight: context.titleSmall.fontWeight,
                ),
              ),
            )
        ],
      ),
    );
  }
}
