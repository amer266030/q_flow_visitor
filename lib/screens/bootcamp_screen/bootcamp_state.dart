part of 'bootcamp_cubit.dart';

@immutable
sealed class BootcampState {}

final class BootcampInitial extends BootcampState {}

final class LoadingState extends BootcampState {}

final class UpdateUIState extends BootcampState {}
