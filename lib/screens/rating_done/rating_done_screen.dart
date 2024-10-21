import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/screens/rating_done/rating_done_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';

import '../../reusable_components/buttons/primary_btn.dart';
import '../../reusable_components/page_header_view.dart';

class RatingDoneScreen extends StatelessWidget {
  const RatingDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingDoneCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<RatingDoneCubit>();
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageHeaderView(title: 'Thank you for \nyour feedback'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: [
                            Text(
                                "We appreciate you taking the time to rate the interview. Your feedback is valuable in helping us improve the event experience.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: context.bodyLarge.fontSize)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: PrimaryBtn(
                                  callback: () => cubit.navigateBack(context),
                                  title: 'OK')),
                        ],
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