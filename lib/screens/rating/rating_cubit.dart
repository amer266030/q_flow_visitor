import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/model/rating/company_rating_question.dart';
import 'package:q_flow/screens/rating_done/rating_done_screen.dart';

import '../../model/user/company.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingState? previousState;
  RatingCubit(Company company) : super(RatingInitial()) {
    initialLoad(company);
  }

  var dataMgr = GetIt.I.get<DataMgr>();
  List<CompanyRatingQuestion> questions = [];
  List<int> ratings = [];
  var company = Company();

  initialLoad(Company company) {
    this.company = company;
    questions = dataMgr.ratingQuestions;
    ratings = List.generate(questions.length, (index) => 1);
    emitUpdate();
  }

  void setRating(int idx, double rating) {
    ratings[idx] = rating.round();
    emitUpdate();
  }

  void navigateToRatingDone(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RatingDoneScreen()))
        .then((_) {
      if (context.mounted && Navigator.canPop(context)) {
        navigateBack(context);
      }
    });
  }

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  @override
  void emit(RatingState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitLoading() => emit(LoadingState());
  emitUpdate() => emit(UpdateUIState());
  emitError(String msg) => emit(ErrorState(msg));
}
