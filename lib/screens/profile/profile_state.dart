part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class LoadingState extends ProfileState {}

final class UpdateUIState extends ProfileState {}

final class ErrorState extends ProfileState {
  final String msg;
  ErrorState(this.msg);
}
