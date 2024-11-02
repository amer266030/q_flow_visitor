part of 'bookmarks_cubit.dart';

@immutable
sealed class BookmarksState {}

final class BookmarksInitial extends BookmarksState {}

final class LoadingState extends BookmarksState {}

final class UpdateUIState extends BookmarksState {}

final class ErrorState extends BookmarksState {
  final String msg;
  ErrorState(this.msg);
}
