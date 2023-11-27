import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomContainer(
      outerPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 0,
      ),
      innerPadding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 0,
      ),
      containerColor: Color(0xFFCDE8FF),
      child: Center(
        child: Text(
          "Welcome to Admin Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
