import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops%20pages/add_shop_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops%20pages/shops_container.dart';

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const AddShopContainer(),
          const SizedBox(
            height: 20,
          ),
          ShopsContainer(
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
