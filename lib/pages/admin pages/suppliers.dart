import 'dart:js_util';

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

  Future<void> deleteSupplier(String id, BuildContext context) async {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Supplier"),
      content: const Text("Are you sure you want to delete this supplier?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            SupplierController supplierController =
                Get.find<SupplierController>();
            bool result = await supplierController.deleteSupplier(id);

            if (result) {
              await loadData();
            }

            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Map<String, List<Supplier>> suppliers = {};

  Future<void> loadData() async {
    // load suppliers from database
    SupplierController supplierController = Get.find<SupplierController>();
    List<Supplier> suppliersList = await supplierController.getSuppliersList();

    // ShopController shopController = Get.find<ShopController>();
    // List<String> shops = await shopController.getShopsNameList();

    // shop wise suplier list
    Map<String, List<Supplier>> shopWiseSupplier = {};

    for (int i = 0; i < suppliersList.length; i++) {
      for (int j = 0; j < suppliersList[i].shops.length; j++) {
        if (shopWiseSupplier.containsKey(suppliersList[i].shops[j])) {
          shopWiseSupplier[suppliersList[i].shops[j]]!.add(suppliersList[i]);
        } else {
          shopWiseSupplier[suppliersList[i].shops[j]] = [suppliersList[i]];
        }
      }
    }

    setState(() {
      suppliers = shopWiseSupplier;
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
            deleteSupplier: (id) {
              deleteSupplier(id, context);
            },
          ),
        ],
      ),
    );
  }
}
