import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_admin_navigation_bar.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/add_shop.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/dashboard.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
    required this.shopName,
  });

  final String? shopName;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectedPage = 0;

  final List<Widget> pages = [
    DashboardPage(),
    AddShopPage(),
    ShopsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: UserPageLayout(
        topDividerSpace: 0,
        pageWidgets: [
          CustomAdminNavigationBar(selectedPage: selectedPage, onPressed: [
            () {
              setState(() {
                selectedPage = 0;
              });
            },
            () {
              setState(() {
                selectedPage = 1;
              });
            },
            () {
              setState(() {
                selectedPage = 2;
              });
            },
          ]),
          SizedBox(
            height: 20,
          ),
          CustomContainer(
            outerPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            innerPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            containerColor: const Color(0xFFCDE8FF),
            child: pages[selectedPage],
          ),
        ],
        shopName: widget.shopName,
      ),
    );
  }
}
