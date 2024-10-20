import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/mock_data/mock_data.dart';
import 'package:q_flow/screens/rating_done/rating_done_screen.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());

  List<int> ratings = List.generate(MockData().questions.length, (index) => 1);

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

  emitUpdate() => emit(UpdateUIState());
}
