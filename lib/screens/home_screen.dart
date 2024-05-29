
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens.dart';
import '../reminder_cubits/reminder_cubit.dart';
import 'package:ac_reminder_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeScreenButton(
                  icon: Icons.add,
                  text: 'Add Reminders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddReminderPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                HomeScreenButton(
                  icon: Icons.view_list,
                  text: 'View Reminders',
                  onTap: () async {
                    await context.read<ReminderCubit>().fetchReminders();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewRemindersPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}
