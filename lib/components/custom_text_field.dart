import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
      obscureText: obscureText,
    );
  }
}
