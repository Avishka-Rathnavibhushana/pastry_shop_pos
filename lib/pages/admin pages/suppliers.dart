import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/models/supplier.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/add_supplier_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/suppliers_container.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  Future<bool> submitSupplier(
    Supplier supplier,
  ) async {
    SupplierController supplierController = Get.find<SupplierController>();
    bool result = false;
    bool resultSupplier = await supplierController.createSupplier(supplier);

    if (resultSupplier) {
      ShopController shopController = Get.find<ShopController>();
      for (int i = 0; i < supplier.shops.length; i++) {
        bool resultShop = await shopController.addSupplierToShop(
          supplier.shops[i].toString(),
          supplier.name.toString(),
        );

        result = resultShop;
      }
    }

    if (result) {
      await loadData();
    }

    return result;
  }

  List<Supplier> suppliers = [];

  Future<void> loadData() async {
    // load suppliers from database
    SupplierController supplierController = Get.find<SupplierController>();
    List<Supplier> suppliersList = await supplierController.getSuppliersList();

    setState(() {
      suppliers = suppliersList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AddSupplierContainer(submit: submitSupplier),
          const SizedBox(
            height: 20,
          ),
          SuppliersContainer(
            onPressed: widget.onPressed,
            suppliers: suppliers,
          ),
        ],
      ),
    );
  }
}
