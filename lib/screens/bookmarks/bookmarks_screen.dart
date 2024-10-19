import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/reusable_components/cards/company_card_list_item.dart';
import 'package:q_flow/screens/bookmarks/bookmarks_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<BookmarksCubit>();
        return Scaffold(
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
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: cubit.companies
                          .map((company) => CompanyCardListItem(
                              company: company,
                              callback: () => (),
                              isBookmarked: Random().nextBool()))
                          .toList(),
                    ),
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
