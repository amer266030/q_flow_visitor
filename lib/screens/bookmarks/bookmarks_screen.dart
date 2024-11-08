import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/reusable_components/cards/company_card_list_item.dart';
import 'package:q_flow/screens/bookmarks/bookmarks_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<BookmarksCubit>();
        return BlocListener<BookmarksCubit, BookmarksState>(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Bookmarks',
                        style: TextStyle(
                          fontSize: context.bodyLarge.fontSize,
                          fontWeight: FontWeight.bold,
                          color: context.textColor1,
                        ),
                      ).tr(),
                    ),
                    Expanded(
                      child: BlocBuilder<BookmarksCubit, BookmarksState>(
                        builder: (context, state) {
                          if (cubit.bookmarkedCompanies.isEmpty) {
                            return Center(
                              child: Text(
                                'Bookmark is empty.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.textColor1,
                                ),
                              ),
                            );
                          }
                          return ListView(
                            children: cubit.bookmarkedCompanies
                                .map((company) => InkWell(
                                      onTap: () =>
                                          cubit.navigateToCompanyDetails(
                                              context, company),
                                      child: CompanyCardListItem(
                                          company: company,
                                          toggleBookmark: () =>
                                              cubit.toggleBookmark(
                                                  context, company.id ?? ''),
                                          isBookmarked: cubit
                                              .checkBookmark(company.id ?? '')),
                                    ))
                                .toList(),
                          );
                        },
                      ),
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
