part of 'interview_booked_cubit.dart';

@immutable
sealed class InterviewBookedState {}

final class InterviewBookedInitial extends InterviewBookedState {}

final class LoadingState extends InterviewBookedState {}

final class UpdateUIState extends InterviewBookedState {}
