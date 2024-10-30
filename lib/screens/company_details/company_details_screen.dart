import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';

import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/user/company.dart';
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
              _ImgView(
                callback: (context) => cubit.navigateBack(context),
                company: company,
              ),
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
                            onPressed: () {
                              final socialLink =
                                  company.socialLinks?.firstWhere(
                                (link) => link.linkType == LinkType.linkedIn,
                                orElse: () => SocialLink(
                                    url: '', linkType: LinkType.linkedIn),
                              );
                              if (socialLink != null) {
                                cubit.launchLink(
                                    socialLink.url, LinkType.linkedIn);
                              } else {
                                print("No LinkedIn link found");
                              }
                            },
                            icon: Icon(
                              BootstrapIcons.linkedin,
                              color: context.primary,
                              size: context.titleSmall.fontSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final socialLink =
                                  company.socialLinks?.firstWhere(
                                (link) => link.linkType == LinkType.website,
                                orElse: () => SocialLink(
                                    url: '', linkType: LinkType.website),
                              );
                              if (socialLink != null) {
                                cubit.launchLink(
                                    socialLink.url, LinkType.website);
                              } else {
                                print("No Website link found");
                              }
                            },
                            icon: Icon(
                              BootstrapIcons.link_45deg,
                              color: context.primary,
                              size: context.titleSmall.fontSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final socialLink =
                                  company.socialLinks?.firstWhere(
                                (link) => link.linkType == LinkType.twitter,
                                orElse: () => SocialLink(
                                    url: '', linkType: LinkType.twitter),
                              );

                              // Debugging: Check what URL is found
                              if (socialLink != null &&
                                  socialLink.url!.isNotEmpty) {
                                print(
                                    "Launching Twitter link: ${socialLink.url}"); // Log the URL
                                cubit.launchLink(
                                    socialLink.url, LinkType.twitter);
                              } else {
                                print("No Twitter link found or URL is empty");
                              }
                            },
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
  const _ImgView({required this.callback, required this.company});

  final Function(BuildContext) callback;
  final Company? company;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      child: Stack(
        children: [
          company?.logoUrl == null
              ? Image(image: Img.logoPurple, fit: BoxFit.contain)
              : Row(
                  children: [
                    Expanded(
                        child: Image.network(company!.logoUrl!,
                            fit: BoxFit.contain)),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: IconButton(
                onPressed: () => callback(context),
                icon: Icon(CupertinoIcons.arrow_left_square_fill,
                    size: context.titleLarge.fontSize,
                    color: context.textColor1)),
          )
        ],
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
