
import 'package:ac_reminder_app/widgets/widgets.dart';
import 'package:ac_reminder_app/screens/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/reminder_model.dart';
import '../reminder_cubits/reminder_cubit.dart';

class UpdateReminderPage extends StatefulWidget {
  final Reminder reminder;

  const UpdateReminderPage({Key? key, required this.reminder}) : super(key: key);

  @override
  _UpdateReminderPageState createState() => _UpdateReminderPageState();
}

class _UpdateReminderPageState extends State<UpdateReminderPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedPriority;
  late TimeOfDay _timeOfDay;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder.title);
    _descController = TextEditingController(text: widget.reminder.description);
    _selectedPriority = widget.reminder.priority ?? Utils.priorities.first;
    _timeOfDay = widget.reminder.timeOfDay ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Reminder'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                lableText: 'Enter title',
                controller: _titleController,
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                lableText: 'Enter description',
                controller: _descController,
                maxLines: 6,
              ),
              const SizedBox(height: 30),
              const Text(
                'Pick Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final time = await pickTime();
                      if (time == null) return;
                      setState(() => _timeOfDay = time);
                    },
                    child: Text(
                      _timeOfDay.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Priority',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Utils.priorityDropDown(
                selectedPriority: _selectedPriority,
                onChanged: (String? newValue) {
                  setState(() => _selectedPriority = newValue!);
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updatedReminder = Reminder(
                      id: widget.reminder.id,
                      title: _titleController.text,
                      description: _descController.text,
                      timeOfDay: _timeOfDay,
                      priority: _selectedPriority,
                    );

                    context.read<ReminderCubit>().updateReminder(updatedReminder);

                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: _timeOfDay,
  );
}
