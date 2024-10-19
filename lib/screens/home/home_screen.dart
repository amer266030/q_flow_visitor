import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/extensions/screen_size.dart';
import 'package:q_flow/screens/home/home_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/ticket_view.dart';

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
                  SectionHeaderView(title: 'Upcoming Interviews'),
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: CarouselView(
                      backgroundColor: Colors.transparent,
                      shrinkExtent: 400,
                      itemExtent: context.screenWidth * 0.8,
                      scrollDirection: Axis.horizontal,
                      children: cubit.interviews
                          .map((interview) => TicketView(
                                timeOfBooking: interview.timeOfBooking ?? '',
                                positionInQueue: interview.positionInQueue ?? 0,
                                company: cubit.company,
                              ))
                          .toList(),
                    ),
                  ),
                  SectionHeaderView(title: 'Suggested For You'),
                  SectionHeaderView(title: 'Explore Companies'),
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

class SectionHeaderView extends StatelessWidget {
  const SectionHeaderView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title, style: context.bodyLarge),
    );
  }
}
