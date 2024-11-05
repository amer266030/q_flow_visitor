import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/reusable_components/star_rating_view.dart';
import 'package:q_flow/screens/rating/network_functions.dart';
import 'package:q_flow/screens/rating/rating_cubit.dart';
import 'package:q_flow/supabase/supabase_interview.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../local_data/local_data.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key, required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit(company),
      child: Builder(builder: (context) {
        final cubit = context.read<RatingCubit>();
        return BlocListener<RatingCubit, RatingState>(
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
            body: ListView(padding: EdgeInsets.zero, children: [
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: context.textColor2),
                    ),
                    Text('Rating'.tr(),
                        style: TextStyle(
                          fontSize: context.bodyMedium.fontSize,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: BlocBuilder<RatingCubit, RatingState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: LocalData()
                                .questions
                                .asMap()
                                .entries
                                .map((entry) => StarRatingView(
                                      title: entry.value.title ?? '',
                                      text: entry.value.text ?? '',
                                      selectedRating: cubit.ratings[entry.key],
                                      setRating: (rating) =>
                                          cubit.setRating(entry.key, rating),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                    Divider(color: context.textColor2)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                child: PrimaryBtn(
                    callback: () => cubit.createRating(context),
                    title: 'SUBMIT'.tr()),
              )
            ]),
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
                        size: context.titleSmall.fontSize,
                        color: context.textColor1),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
