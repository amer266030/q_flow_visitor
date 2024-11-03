import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/extensions/img_ext.dart';
import 'package:q_flow/extensions/screen_size.dart';
import 'package:q_flow/managers/alert_manger.dart';
import 'package:q_flow/screens/home/home_cubit.dart';
import 'package:q_flow/screens/home/network_functions.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/user/company.dart';
import '../../reusable_components/cards/company_card_large.dart';
import '../../reusable_components/cards/company_card_list_item.dart';
import '../../reusable_components/cards/ticket_view.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<HomeCubit>();
        return BlocListener<HomeCubit, HomeState>(
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    _HeaderView(positionInQueue: null, cubit: cubit),
                    Divider(color: context.textColor3),
                    _SectionHeaderView(title: 'Upcoming Interviews'),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return cubit.visitor.interviews != null &&
                                cubit.visitor.interviews!.isNotEmpty
                            ? SizedBox(
                                height: context.screenWidth * 0.45,
                                child: CarouselView(
                                  backgroundColor: Colors.transparent,
                                  itemExtent: context.screenWidth * 0.7,
                                  shrinkExtent: context.screenWidth * 0.7,
                                  scrollDirection: Axis.horizontal,
                                  children: cubit.visitor.interviews!
                                      .map((interview) => TicketView(
                                            timeOfBooking: interview
                                                        .createdAt ==
                                                    null
                                                ? '?'
                                                : DateTime.parse(
                                                        interview.createdAt!)
                                                    .toFormattedStringTimeOnly(),
                                            positionInQueue:
                                                interview.positionInQueue ?? 1,
                                            company: cubit.getCompany(
                                                    interview.companyId ??
                                                        '') ??
                                                Company(),
                                          ))
                                      .toList(),
                                ),
                              )
                            : Text('No Upcoming Interviews...');
                      },
                    ),
                    _SectionHeaderView(title: 'Suggested For You'),
                    SizedBox(
                      height: context.screenWidth * 0.6,
                      child: CarouselView(
                        backgroundColor: Colors.transparent,
                        itemExtent: context.screenWidth * 0.6,
                        shrinkExtent: context.screenWidth * 0.6,
                        onTap: (index) {
                          final company = cubit.companies[index];
                          cubit.navigateToCompanyDetails(context, company);
                        },
                        children: cubit.companies
                            .map(
                              (company) => CompanyCardLarge(
                                company: company,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    _SectionHeaderView(
                        title: 'Explore Companies',
                        ctaStr: 'View all',
                        callback: () => cubit.navigateToExplore(context)),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Column(
                          children: cubit.companies
                              .map(
                                (company) => InkWell(
                                  onTap: () => cubit.navigateToCompanyDetails(
                                      context, company),
                                  child: CompanyCardListItem(
                                    company: company,
                                    isBookmarked:
                                        cubit.checkBookmark(company.id ?? ''),
                                    toggleBookmark: () => cubit.toggleBookmark(
                                        context, company.id ?? ''),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _HeaderView extends StatelessWidget {
  const _HeaderView({this.positionInQueue, required this.cubit});

  final int? positionInQueue;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: cubit.visitor.avatarUrl == null
                  ? Image(image: Img.avatar, fit: BoxFit.contain)
                  : FadeInImage(
                      placeholder: Img.avatar,
                      image: NetworkImage(cubit.visitor.avatarUrl!),
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image(image: Img.avatar, fit: BoxFit.contain);
                      },
                    ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, ${cubit.visitor.fName ?? ''}',
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
              onPressed: () => {
                    AlertManager().showQRAlert(
                      context: context,
                      title:
                          "${cubit.visitor.fName ?? ''} ${cubit.visitor.lName ?? ''}",
                    )
                  },
              icon: Icon(CupertinoIcons.qrcode, size: 40)),
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
