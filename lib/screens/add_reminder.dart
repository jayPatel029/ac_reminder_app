import 'package:ac_reminder_app/models/reminder_model.dart';
import 'package:ac_reminder_app/reminder_cubits/reminder_cubit.dart';
import 'package:ac_reminder_app/screens/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_reminder_app/widgets/widgets.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String selectedPriority = Utils.priorities.first;

  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Reminder"),
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
                controller: titleController,
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                lableText: 'Enter description',
                controller: descController,
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
                      setState(() => timeOfDay = time);
                    },
                    child: Text(
                      timeOfDay.format(context),
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
                selectedPriority: selectedPriority,
                onChanged: (String? newValue) {
                  setState(() => selectedPriority = newValue!);
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final reminder = Reminder(
                      id: '',
                      title: titleController.text,
                      description: descController.text,
                      timeOfDay: timeOfDay,
                      priority: selectedPriority,
                    );

                    context.read<ReminderCubit>().addReminder(reminder);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: timeOfDay);
}
