import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    required this.dropdownItems,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> dropdownItems;
  final void Function(String?) onChanged;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        // enabledBorder: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: Colors.blue, width: 2),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Color(0xFFCDE8FF),
      ),
      validator: (value) => value == null ? "Select a Role" : null,
      dropdownColor: Color(0xFFCDE8FF),
      value: selectedValue,
      onChanged: onChanged,
      items: dropdownItems,
    );
  }
}
