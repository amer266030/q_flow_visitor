import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/screens/company_details/network_functions.dart';
import 'package:q_flow/supabase/supabase_interview.dart';

import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/user/company.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';
import 'company_details_cubit.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key, required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyDetailsCubit(company),
      child: Builder(builder: (context) {
        final cubit = context.read<CompanyDetailsCubit>();
        return BlocListener<CompanyDetailsCubit, CompanyDetailsState>(
          listener: (context, state) {
            if (cubit.previousState is LoadingState) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }

            if (state is LoadingState) {
              showLoadingDialog(context);
            }

            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                _ImgView(
                    company: company,
                    callback: (context) => cubit.navigateBack(context)),
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
                            Text('About',
                                style: TextStyle(fontWeight: FontWeight.bold)).tr(),
                            SizedBox(height: 4),
                            Text(company.description ?? '',
                                style: context.bodySmall),
                          ],
                        ),
                      ),
                      _RowItemView(
                          title: 'Number'.tr(),
                          details: company.companySize?.value ?? ''),
                      _RowItemView(
                          title: 'Established'.tr(),
                          details: '${company.establishedYear ?? ''}'),
                      _RowItemView(
                        title: 'Social'.tr(),
                        details: '',
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                final socialLink =
                                    company.socialLinks?.firstWhere(
                                  (link) => link.linkType == LinkType.linkedIn,
                                );

                                if (socialLink != null) {
                                  cubit.launchLink(
                                      socialLink.url, LinkType.linkedIn);
                                } else {
                                  cubit.emitError('Link'.tr());
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
                                );

                                // Debugging: Check what URL is found
                                if (socialLink != null &&
                                    socialLink.url!.isNotEmpty) {
                                  print(
                                      "Launching Twitter link: ${socialLink.url}"); // Log the URL
                                  cubit.launchLink(
                                      socialLink.url, LinkType.twitter);
                                } else {
                                  print(
                                      "No Twitter link found or URL is empty");
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
                      Text('Position',
                          style: TextStyle(fontWeight: FontWeight.bold)).tr(),
                      SizedBox(height: 8),
                      if (company.skills != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: company.skills!
                                .map((skill) => Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: context.primary)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8.0),
                                        child: Text(
                                            skill.techSkill?.value ?? '',
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
                          Text('QueuePosition',
                              style: context.bodyMedium,
                              maxLines: 1,
                              softWrap: true).tr(),
                          SizedBox(width: 4),
                          BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
                            builder: (context, state) {
                              return Text(
                                '${cubit.queueLength}',
                                style: TextStyle(
                                    color: context.primary,
                                    fontSize: context.bodyMedium.fontSize,
                                    fontWeight: FontWeight.bold),
                              );
                            },
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
                          Text('EstimatedWaiting',
                              style: context.bodyMedium,
                              maxLines: 1,
                              softWrap: true).tr(),
                          SizedBox(width: 4),
                          BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
                            builder: (context, state) {
                              return Text(
                                '${cubit.queueLength * 2}:00 min',
                                style: TextStyle(
                                    color: context.primary,
                                    fontSize: context.bodyMedium.fontSize,
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            Expanded(
                                child: PrimaryBtn(
                                    callback: () => cubit.createInterview(
                                        context, company.id ?? ''),
                                    title: 'BookInterview'.tr()))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ImgView extends StatelessWidget {
  const _ImgView({
    required this.callback,
    required this.company,
  });

  final Company company;
  final Function(BuildContext) callback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: company.logoUrl == null
                ? Image(image: Img.logoTurquoise, fit: BoxFit.cover)
                : FadeInImage(
                    placeholder: Img.logoTurquoise,
                    image: NetworkImage(company.logoUrl ?? ''),
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image(image: Img.logoTurquoise, fit: BoxFit.cover);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: InkWell(
              onTap: () => callback(context),
              child: Container(
                  decoration: BoxDecoration(
                    color: context.bg1,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.chevron_left,
                        size: context.titleMedium.fontSize,
                        color: context.textColor1),
                  )),
            ),
          ),
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
