
import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String? title;
  final String? description;
  final TimeOfDay? timeOfDay; // Store TimeOfDay instead of DateTime
  final String? priority;

  Reminder({
    required this.id,
    this.title,
    this.description,
    this.timeOfDay,
    this.priority,
  });

  factory Reminder.fromMap(Map<String, dynamic> data, String id) {
    return Reminder(
      id: id,
      title: data['title'] as String?,
      description: data['description'] as String?,
      timeOfDay: data['timeOfDay'] != null
          ? TimeOfDay(
        hour: data['timeOfDay']['hour'] as int,
        minute: data['timeOfDay']['minute'] as int,
      )
          : null,
      priority: data['priority'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timeOfDay': timeOfDay != null
          ? {'hour': timeOfDay!.hour, 'minute': timeOfDay!.minute}
          : null,
      'priority': priority,
    };
  }
}
