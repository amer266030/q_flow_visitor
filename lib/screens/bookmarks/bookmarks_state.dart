part of 'bookmarks_cubit.dart';

@immutable
sealed class BookmarksState {}

final class BookmarksInitial extends BookmarksState {}

final class UpdateUIState extends BookmarksState {}
