import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/company.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/enums/queue_length.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/reusable_components/cards/company_card_list_item.dart';
import 'package:q_flow/reusable_components/custom_text_field.dart';
import 'package:q_flow/screens/explore/explore_cubit.dart';
import 'package:q_flow/screens/explore/subviews/filterItemView.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';
import 'package:q_flow/utils/validations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.companies});

  final List<Company> companies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(companies),
      child: Builder(builder: (context) {
        final cubit = context.read<ExploreCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: 'Search',
                  controller: cubit.searchController,
                  validation: Validations.none),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  BlocBuilder<ExploreCubit, ExploreState>(
                    builder: (context, state) {
                      return Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: context.bodyLarge.fontSize,
                              fontWeight: FontWeight.bold,
                              color: context.textColor1,
                            ),
                          ),
                          children: [
                            FilterItemView(
                              title: 'Company Size',
                              itemValues: CompanySize.values
                                  .map((e) => e.value)
                                  .toList(),
                              setValueFunc: (str) => cubit.filterBySize(str),
                              currentSelection: cubit.selectedSize?.value,
                              clearValuesFunc: () => (),
                            ),
                            FilterItemView(
                              title: 'Position Openings',
                              itemValues:
                                  TechSkill.values.map((e) => e.value).toList(),
                              setValueFunc: (str) => cubit.filterBySkill(str),
                              currentSelection: cubit.selectedSkill?.value,
                              clearValuesFunc: () => (),
                            ),
                            FilterItemView(
                              title: 'Current Queue',
                              itemValues: QueueLength.values
                                  .map((e) => e.value)
                                  .toList(),
                              setValueFunc: (str) =>
                                  cubit.filterByQueueLength(str),
                              currentSelection: cubit.selectedQueue?.value,
                              clearValuesFunc: () => (),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: cubit.filteredCompanies
                          .map((company) => CompanyCardListItem(
                              company: company,
                              callback: () => (),
                              isBookmarked: Random().nextBool()))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
