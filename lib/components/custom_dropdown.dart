import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    required this.dropdownItems,
    required this.onChanged,
    required this.selectedValue,
    this.borderAvailable = true,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> dropdownItems;
  final void Function(String?) onChanged;
  final String selectedValue;
  final bool borderAvailable;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        // enabledBorder: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: Colors.blue, width: 2),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: borderAvailable ? null : InputBorder.none,
        focusedBorder: borderAvailable ? null : InputBorder.none,
        errorBorder: borderAvailable ? null : InputBorder.none,
        disabledBorder: borderAvailable ? null : InputBorder.none,
        filled: true,
        fillColor: const Color(0xFFCDE8FF),
      ),
      validator: (value) => value == null ? "Select a Role" : null,
      dropdownColor: const Color(0xFFCDE8FF),
      value: selectedValue,
      onChanged: onChanged,
      items: dropdownItems,
    );
  }
}
