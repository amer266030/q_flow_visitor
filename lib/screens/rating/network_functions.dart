import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:q_flow/model/rating/company_question_rating.dart';
import 'package:q_flow/screens/rating/rating_cubit.dart';
import 'package:q_flow/supabase/supabase_rating.dart';

extension NetworkFunctions on RatingCubit {
  Future createRating(BuildContext context) async {
    emitLoading();
    try {
      if (company.id == null) throw Exception('CouldNotLoadCompany'.tr());
      if (dataMgr.visitor?.id == null) throw Exception('Could'.tr());

      List<CompanyQuestionRating> questionRatings = setRatings();

      await SupabaseRating.createRating(
        company.id!,
        dataMgr.visitor!.id!,
        questionRatings,
      );

      if (context.mounted) navigateToRatingDone(context);
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  List<CompanyQuestionRating> setRatings() {
    List<CompanyQuestionRating> questionRatings = [];

    for (int i = 0; i < questions.length; i++) {
      questionRatings.add(
        CompanyQuestionRating(
          questionId: questions[i].id,
          rating: ratings[i],
        ),
      );
    }

    return questionRatings;
  }
}
