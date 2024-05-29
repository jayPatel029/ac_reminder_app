import 'package:flutter/material.dart';
class Utils {
  static final List<String> priorities = [
    'low',
    'medium',
    'high',
  ];

  static final Map<String, Color> priorityColors = {
    'low': Colors.yellow,
    'medium': Colors.orange,
    'high': Colors.red,
  };

  static Widget priorityDropDown({
    required String selectedPriority,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: DropdownButtonFormField<String>(
        items: priorities.map((String priority) {
          return DropdownMenuItem<String>(
            value: priority,
            child: Text(
              priority,
              style: TextStyle(
                color: priorityColors[priority],
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          labelText: 'Select Priority',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
