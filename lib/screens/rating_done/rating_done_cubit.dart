import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'rating_done_state.dart';

class RatingDoneCubit extends Cubit<RatingDoneState> {
  RatingDoneCubit() : super(RatingDoneInitial());

  navigateBack(BuildContext context) => Navigator.of(context).pop();
}
