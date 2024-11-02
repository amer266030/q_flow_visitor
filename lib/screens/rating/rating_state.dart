part of 'rating_cubit.dart';

@immutable
sealed class RatingState {}

final class RatingInitial extends RatingState {}

final class LoadingState extends RatingState {}

final class UpdateUIState extends RatingState {}

final class ErrorState extends RatingState {
  final String msg;
  ErrorState(this.msg);
}
