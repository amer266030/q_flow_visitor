part of 'tickets_cubit.dart';

@immutable
sealed class TicketsState {}

final class TicketsInitial extends TicketsState {}

final class LoadingState extends TicketsState {}

final class UpdateUIState extends TicketsState {}
