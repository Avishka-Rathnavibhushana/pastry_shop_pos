import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';

class CustomAdminNavigationBar extends StatelessWidget {
  const CustomAdminNavigationBar(
      {super.key, required this.selectedPage, required this.onPressed});

  final int selectedPage;
  final List<Function()> onPressed;

  @override
  Widget build(BuildContext context) {
    const Color buttonBackgroundColorNotSelected = Color(0xFF5E86A6);
    const Color buttonBackgroundColorSelected = Color(0xFF1B78C4);

    return CustomContainer(
      outerPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 0,
      ),
      innerPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 0,
      ),
      containerColor: const Color(0xFFCDE8FF),
      child: ButtonBar(
        alignment: MainAxisAlignment.start,
        children: [
          CustomButton(
            onPressed: onPressed[0],
            text: "Dashboard",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 0
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
          CustomButton(
            onPressed: onPressed[1],
            text: "Suppliers",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 1
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
          CustomButton(
            onPressed: onPressed[2],
            text: "Shops",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 2
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
        ],
      ),
    );
  }
}
