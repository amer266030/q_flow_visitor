import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/skills/network_functions.dart';
import 'package:q_flow/screens/skills/skills_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/enums/tech_skill.dart';
import '../../reusable_components/buttons/primary_btn.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';
import '../../reusable_components/page_header_view.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => SkillsCubit(),
        child: Builder(builder: (context) {
          final cubit = context.read<SkillsCubit>();
          return BlocListener<SkillsCubit, SkillsState>(
            listener: (context, state) async {
              if (cubit.previousState is LoadingState) {
                await Navigator.of(context).maybePop();
              }
              if (state is LoadingState &&
                  cubit.previousState is! LoadingState) {
                if (context.mounted) showLoadingDialog(context);
              }
              if (state is ErrorState) {
                if (context.mounted) showErrorDialog(context, state.msg);
              }
            },
            child: Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     PageHeaderView(title: "Skills".tr()),
                    BlocBuilder<SkillsCubit, SkillsState>(
                      builder: (context, state) {
                        return Expanded(
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            children: TechSkill.values
                                .map((b) => InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () => cubit.positionTapped(b),
                                      child: _GridItemView(
                                          title: b.value,
                                          isSelected: cubit.skills.contains(b)),
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryBtn(
                              callback: () => cubit.updateSkills(context),
                              title: 'Continue'.tr()),
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ),
          );
        }),
      ),
    );
  }
}

class _GridItemView extends StatelessWidget {
  const _GridItemView({required this.title, required this.isSelected});

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
          color: context.bg2,
          border: Border.all(
              color: isSelected ? context.primary : context.bg3, width: 3)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: context.bodyMedium.fontSize,
                color: isSelected ? context.primary : context.textColor2),
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
