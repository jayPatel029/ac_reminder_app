import 'package:ac_reminder_app/services/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/reminder_model.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final FirebaseFirestore _firestore;

  ReminderCubit(this._firestore) : super(ReminderInitial());

  Future<void> addReminder(Reminder reminder) async {
    try {
      emit(ReminderLoading());
      await _firestore.collection('reminders').add(reminder.toMap());
      await _scheduledNotification(reminder);
      fetchReminders();
    } catch (err) {
      emit(ReminderError(err.toString()));
    }
  }

  Future<void> fetchReminders() async {
    try {
      emit(ReminderLoading());
      QuerySnapshot snapshot = await _firestore.collection('reminders').get();

      List<Reminder> reminders = snapshot.docs
          .map((doc) =>
              Reminder.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      emit(ReminderLoaded(reminders));
    } catch (err) {
      emit(ReminderError(err.toString()));
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      emit(ReminderLoading());
      await _firestore.collection('reminders').doc(id).delete();
      fetchReminders();
    } catch (err) {
      emit(ReminderError(err.toString()));
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      emit(ReminderLoading());

      await _firestore
          .collection('reminders')
          .doc(reminder.id)
          .update(reminder.toMap());
      fetchReminders();
    } catch (err) {
      emit(ReminderError(err.toString()));
    }
  }

  Future<void> _scheduledNotification(Reminder reminder) async {
    if (reminder.timeOfDay != null) {
      final now = DateTime.now();

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminder.timeOfDay!.hour,
        reminder.timeOfDay!.minute,
      );
      if (scheduledTime.isAfter(now)) {
        await NotificationService.scheduledNotification(
            reminder.title ?? 'Reminder',
            reminder.description ?? 'You have a reminder',
            scheduledTime);
      }
    }
  }
}
