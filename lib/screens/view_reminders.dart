import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens.dart';
import '../models/reminder_model.dart';
import '../reminder_cubits/reminder_cubit.dart';

class ViewRemindersPage extends StatefulWidget {
  const ViewRemindersPage({Key? key}) : super(key: key);

  @override
  _ViewRemindersPageState createState() => _ViewRemindersPageState();
}

class _ViewRemindersPageState extends State<ViewRemindersPage> {
  String? _selectedPriorityFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reminders'),
        actions: [
          _buildPriorityFilterDropdown(),
          _buildClearFilterButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tap and hold a reminder for more options',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: BlocBuilder<ReminderCubit, ReminderState>(
              builder: (context, state) {
                if (state is ReminderLoaded) {
                  final filteredReminders = _applyPriorityFilter(state.reminders);
                  return ListView.builder(
                    itemCount: filteredReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = filteredReminders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: ListTile(
                          title: Text(reminder.title ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Priority: ${reminder.priority ?? ''}\nTime: ${reminder.timeOfDay?.format(context) ?? ''}',
                            style: TextStyle(height: 1.5),
                          ),
                          onTap: () {
                            _showReminderDetails(context, reminder);
                          },
                          onLongPress: () {
                            _showOptionsDialog(context, reminder);
                          },
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedPriorityFilter,
      onChanged: (value) {
        setState(() {
          _selectedPriorityFilter = value;
        });
      },
      items: ['low', 'medium', 'high', 'Clear Filter'].map((String priority) {
        return DropdownMenuItem<String>(
          value: priority == 'Clear Filter' ? null : priority,
          child: Text(priority),
        );
      }).toList(),
    );
  }

  Widget _buildClearFilterButton() {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        setState(() {
          _selectedPriorityFilter = null;
        });
      },
    );
  }

  List<Reminder> _applyPriorityFilter(List<Reminder> reminders) {
    if (_selectedPriorityFilter == null) {
      return reminders;
    } else {
      return reminders
          .where((reminder) => reminder.priority == _selectedPriorityFilter)
          .toList();
    }
  }

  void _showReminderDetails(BuildContext context, Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder.title ?? ''),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Description: ${reminder.description ?? ''}'),
            Text('Priority: ${reminder.priority ?? ''}'),
            Text('Time: ${reminder.timeOfDay?.format(context) ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: const Text('Update'),
              onTap: () {
                Navigator.pop(context);
                _navigateToUpdateReminder(context, reminder);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteReminder(context, reminder.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUpdateReminder(BuildContext context, Reminder reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateReminderPage(reminder: reminder)),
    );
  }

  void _deleteReminder(BuildContext context, String id) {
    context.read<ReminderCubit>().deleteReminder(id);
  }
}
