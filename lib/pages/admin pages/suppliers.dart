import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/add_supplier_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/suppliers_container.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AddSupplierContainer(),
          SizedBox(
            height: 20,
          ),
          SuppliersContainer(
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
