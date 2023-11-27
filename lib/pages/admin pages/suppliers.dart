import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/add_supplier_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/suppliers_container.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const AddSupplierContainer(),
          const SizedBox(
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
