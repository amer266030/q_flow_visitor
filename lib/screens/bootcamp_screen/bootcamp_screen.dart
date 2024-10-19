import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/reusable_components/page_header_view.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/screens/bootcamp_screen/bootcamp_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';
import '../../model/enums/bootcamp.dart';

class BootcampScreen extends StatelessWidget {
  const BootcampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BootcampCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<BootcampCubit>();
        return Scaffold(
          body: SafeArea(
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeaderView(title: 'Bootcamp'),
                      BlocBuilder<BootcampCubit, BootcampState>(
                        builder: (context, state) {
                          return Expanded(
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 24,
                              ),
                              children: Bootcamp.values
                                  .map((b) => InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () => cubit.bootcampTapped(b),
                                        child: _GridItemView(
                                            title: b.value,
                                            isSelected:
                                                cubit.bootcamps.contains(b)),
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
                                callback: () =>
                                    cubit.navigateToBottomNav(context),
                                title: 'Continue'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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
          shape: BoxShape.circle,
          color: context.bg2,
          border: Border.all(
              color: isSelected ? context.primary : context.bg3, width: 3)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: context.titleSmall.fontSize,
              color: isSelected ? context.primary : context.textColor2),
          textAlign: TextAlign.center,
          maxLines: 2,
          softWrap: true,
        ),
      ),
    );
  }
}
