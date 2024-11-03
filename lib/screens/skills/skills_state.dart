part of 'skills_cubit.dart';

@immutable
sealed class SkillsState {}

final class SkillsInitial extends SkillsState {}

final class LoadingState extends SkillsState {}

final class UpdateUIState extends SkillsState {}

final class ErrorState extends SkillsState {
  final String msg;
  ErrorState(this.msg);
}
