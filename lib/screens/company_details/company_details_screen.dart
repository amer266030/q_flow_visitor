import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';

import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/company.dart';
import 'company_details_cubit.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key, required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyDetailsCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<CompanyDetailsCubit>();
        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _ImgView(callback: (context) => cubit.navigateBack(context)),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name ?? '',
                      style: TextStyle(
                        fontSize: context.bodyLarge.fontSize,
                        fontWeight: FontWeight.bold,
                        color: context.textColor1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About Us:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(company.description ?? '',
                              style: context.bodySmall),
                        ],
                      ),
                    ),
                    _RowItemView(
                        title: 'Number of employees:',
                        details: company.companySize?.value ?? ''),
                    _RowItemView(
                        title: 'Established since:',
                        details: '${company.establishedYear ?? ''}'),
                    _RowItemView(
                      title: 'Social Links',
                      details: '',
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => (),
                            icon: Icon(
                              BootstrapIcons.linkedin,
                              color: context.primary,
                              size: context.titleSmall.fontSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () => (),
                            icon: Icon(
                              BootstrapIcons.link_45deg,
                              color: context.primary,
                              size: context.titleSmall.fontSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () => (),
                            icon: Icon(
                              BootstrapIcons.twitter_x,
                              color: context.primary,
                              size: context.titleSmall.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Position Openings',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing:
                            8.0, // Adds horizontal spacing between children
                        runSpacing: 4.0, // Adds vertical spacing between lines
                        children: cubit.skills
                            .map((skill) => Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(100),
                                      border:
                                          Border.all(color: context.primary)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8.0),
                                    child: Text(skill.value,
                                        style: TextStyle(
                                            fontSize:
                                                context.bodySmall.fontSize,
                                            color: context.textColor1)),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: context.textColor3),
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_3,
                          color: context.textColor2,
                          size: context.titleMedium.fontSize,
                        ),
                        SizedBox(width: 4),
                        Text('Current queue:',
                            style: context.bodyMedium,
                            maxLines: 1,
                            softWrap: true),
                        SizedBox(width: 4),
                        Text(
                          '12',
                          style: TextStyle(
                              color: context.primary,
                              fontSize: context.bodyMedium.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.time,
                          color: context.textColor2,
                          size: context.titleMedium.fontSize,
                        ),
                        SizedBox(width: 4),
                        Text('Estimated Waiting:',
                            style: context.bodyMedium,
                            maxLines: 1,
                            softWrap: true),
                        SizedBox(width: 4),
                        Text(
                          '25:00 min',
                          style: TextStyle(
                              color: context.primary,
                              fontSize: context.bodyMedium.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        children: [
                          Expanded(
                              child: PrimaryBtn(
                                  callback: () =>
                                      cubit.navigateToInterviewBooked(context),
                                  title: 'Book Interview'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ImgView extends StatelessWidget {
  const _ImgView({
    required this.callback,
  });

  final Function(BuildContext) callback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Image(image: Img.logoPurple, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: IconButton(
                  onPressed: () => callback(context),
                  icon: Icon(CupertinoIcons.chevron_left_square,
                      size: context.titleLarge.fontSize,
                      color: context.textColor1)),
            )
          ],
        ),
      ),
    );
  }
}

class _RowItemView extends StatelessWidget {
  const _RowItemView({
    required this.title,
    required this.details,
    this.child,
  });

  final String title;
  final String details;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          if (child != null)
            child!
          else
            Text(
              details,
              style: TextStyle(
                color: context.primary,
                fontSize: context.bodyMedium.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
