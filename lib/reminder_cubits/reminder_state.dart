part of 'reminder_cubit.dart';

@immutable
sealed class ReminderState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class ReminderInitial extends ReminderState {}

final class ReminderLoading extends ReminderState {}

final class ReminderLoaded extends ReminderState {
  final List<Reminder> reminders;
  ReminderLoaded(this.reminders);

  @override
  // TODO: implement props
  List<Object?> get props => [reminders];
}

final class ReminderError extends ReminderState {
  final String message;
  ReminderError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
