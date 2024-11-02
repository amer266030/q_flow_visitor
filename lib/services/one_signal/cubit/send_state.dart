part of 'send_cubit.dart';

@immutable
sealed class SendState {}

final class SendInitial extends SendState {}

final class SendLoadingState extends SendState {}

final class SendUpdateState extends SendState {}
