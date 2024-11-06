part of 'explore_cubit.dart';

@immutable
sealed class ExploreState {}

final class ExploreInitial extends ExploreState {}

final class LoadingState extends ExploreState {}

final class UpdateUIState extends ExploreState {}

final class ErrorState extends ExploreState {
  final String msg;
  ErrorState(this.msg);
}
