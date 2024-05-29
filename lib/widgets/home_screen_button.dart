import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const HomeScreenButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
