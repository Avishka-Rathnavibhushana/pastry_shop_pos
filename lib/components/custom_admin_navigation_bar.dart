import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/constants/constants.dart';

class CustomAdminNavigationBar extends StatelessWidget {
  const CustomAdminNavigationBar(
      {super.key, required this.selectedPage, required this.onPressed});

  final int selectedPage;
  final List<Function()> onPressed;

  @override
  Widget build(BuildContext context) {
    const Color buttonBackgroundColorNotSelected = Color(0xFF5E86A6);
    const Color buttonBackgroundColorSelected = Color(0xFF1B78C4);

    double width = MediaQuery.of(context).size.width;

    Widget content = Container();

    if (width > Constants.MobileSizeMini) {
      content = ButtonBar(
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
          CustomButton(
            onPressed: onPressed[3],
            text: "Accountants",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 3
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
          CustomButton(
            onPressed: onPressed[4],
            text: "Reports",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 3
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
        ],
      );
    } else {
      content = ButtonBar(
        alignment: MainAxisAlignment.center,
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
          SizedBox(
            height: 10,
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
          SizedBox(
            height: 10,
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
          SizedBox(
            height: 10,
          ),
          CustomButton(
            onPressed: onPressed[3],
            text: "Accoountants",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 3
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            onPressed: onPressed[4],
            text: "Reports",
            fontSize: 13,
            padding: 0,
            backgroundColor: selectedPage == 3
                ? buttonBackgroundColorSelected
                : buttonBackgroundColorNotSelected,
          ),
        ],
      );
    }

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
      child: content,
    );
  }
}
