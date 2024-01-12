import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.fontSize = 15,
    this.maxLength,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final double? fontSize;
  final int? maxLength;
  final void Function(String)? onSubmitted;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: fontSize,
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
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
