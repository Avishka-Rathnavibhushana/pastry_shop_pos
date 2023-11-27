import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_admin_navigation_bar.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';

import 'package:pastry_shop_pos/pages/admin%20pages/dashboard.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops%20pages/shop.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/supplier.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers.dart';
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
  int selectedPage = 2;

  List<Widget> pages = [];

  bool showSupplier = false;
  bool showShop = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      pages = [
        DashboardPage(),
        SuppliersPage(
          onPressed: (String id) {
            print(id);
            setState(() {
              showSupplier = true;
            });
          },
        ),
        ShopsPage(
          onPressed: (String id) {
            print(id);
            setState(() {
              showShop = true;
            });
          },
        ),
      ];
    });
  }

  // var onPressed =

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: UserPageLayout(
        topDividerSpace: 0,
        pageWidgets: [
          CustomAdminNavigationBar(
            selectedPage: selectedPage,
            onPressed: [
              () {
                setState(() {
                  selectedPage = 0;
                  showSupplier = false;
                  showShop = false;
                });
              },
              () {
                setState(() {
                  selectedPage = 1;
                  showSupplier = false;
                  showShop = false;
                });
              },
              () {
                setState(() {
                  selectedPage = 2;
                  showSupplier = false;
                  showShop = false;
                });
              },
            ],
          ),
          SizedBox(
            height: 20,
          ),
          showSupplier
              ? SupplierPage()
              : showShop
                  ? ShopPage()
                  : pages[selectedPage],
        ],
        shopName: widget.shopName,
      ),
    );
  }
}
