
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String lableText;
  final int maxLines;
  final TextEditingController controller;

  CustomTextfield({
    super.key,
    required this.lableText,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: lableText,
          border: const OutlineInputBorder(),
          counterText: "",
        ),
      ),
    );
  }
}
