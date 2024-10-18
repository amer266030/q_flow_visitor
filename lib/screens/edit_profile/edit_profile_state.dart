part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class LoadingState extends EditProfileState {}

final class UpdateUIState extends EditProfileState {}
