import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';
import 'package:pastry_shop_pos/pages/loadingPage.dart';

class CashierHomePage extends StatefulWidget {
  const CashierHomePage({
    super.key,
    required this.shopName,
  });

  final String? shopName;

  @override
  State<CashierHomePage> createState() => _CashierHomePageState();
}

class _CashierHomePageState extends State<CashierHomePage> {
  Map<String, List<SupplierItem>> suppliersItems = {};

  AuthController authController = Get.find<AuthController>();

  

  @override
  void initState() {

    authController.todayDate.value = _formatdatetime(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _gettime());
    super.initState();

    String dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());

    loadData(dateInput);
  }

  void _gettime() {
    final DateTime now = DateTime.now();
    final String formatteddatetime = _formatdatetime(now);

    authController.todayDate.value = formatteddatetime;

  }

  String _formatdatetime(DateTime datetime) {
    return DateFormat('EEEE, MMMM d, y \n H:mm:s').format(datetime);
  }

  // load data from supplierItem
  Future<void> loadData(String date) async {
    authController.loading.value = true;
    try {
      ShopController shopController = Get.find<ShopController>();
      List<String> supplierList =
          await shopController.getSuppliersOfShop(widget.shopName ?? "");

      SupplierItemController supplierItemsController =
          Get.find<SupplierItemController>();

      if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        for (String supplier in supplierList) {
          bool isItemsEqual = await supplierItemsController.isItemsEqual(
            supplier,
            date,
          );
          if (!isItemsEqual) {
            await supplierItemsController
                .getItemsFromSupplierAndAddToSupplierItem(supplier, date);
          }
        }
      }

      for (String supplier in supplierList) {
        // load suppliers from database
        List<SupplierItem> supplierItemList =
            await supplierItemsController.getSupplierItems(supplier, date);

        setState(() {
          suppliersItems[supplier] = supplierItemList;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(Duration(seconds: 1));
      authController.loading.value = false;
    }
  }

  List<bool> editList = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      for (var itemData in value) {
        if (editList.length < value.length) {
          setState(() {
            editList.add(false);
          });
        }
        String item = itemData.name;
        String qty = itemData.qty.toString();
        String sold = itemData.sold.toString();
        TextEditingController qtyController = TextEditingController(text: qty);
        TextEditingController soldController =
            TextEditingController(text: sold);

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(editList[suppliersItems[key]!
                    .indexWhere((element) => element.name == itemData.name)]
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: qtyController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                  )
                : Text(qty)),
            DataCell(editList[suppliersItems[key]!
                    .indexWhere((element) => element.name == itemData.name)]
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: soldController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                  )
                : Text(sold)),
            DataCell(
              Row(
                children: [
                  CustomButton(
                    onPressed: () async {
                      authController.loading.value = true;

                      try {
                        if (editList[suppliersItems[key]!.indexWhere(
                            (element) => element.name == itemData.name)]) {
                          SupplierItemController supplierItemsController =
                              Get.find<SupplierItemController>();

                          // update item
                          bool result = await supplierItemsController
                              .updateItemInSupplierItem(
                            key,
                            SupplierItem(
                              name: item,
                              date: itemData.date,
                              sold: int.parse(soldController.text),
                              qty: int.parse(qtyController.text),
                              purchasePrice: itemData.purchasePrice,
                              salePrice: itemData.salePrice,
                            ),
                            itemData.date,
                          );
                          if (result) {
                            int index = suppliersItems[key]!
                                .indexWhere((element) => element.name == item);
                            setState(() {
                              suppliersItems[key]![index].sold =
                                  int.parse(soldController.text);
                              suppliersItems[key]![index].qty =
                                  int.parse(qtyController.text);
                            });
                          }
                          // qty = qtyController.text;
                          // sold = soldController.text;
                        }
                        setState(() {
                          editList[suppliersItems[key]!.indexWhere(
                                  (element) => element.name == itemData.name)] =
                              !editList[suppliersItems[key]!.indexWhere(
                                  (element) => element.name == itemData.name)];
                        });
                      } catch (e) {
                        print(e);
                      } finally {
                        await Future.delayed(Duration(seconds: 1));
                        authController.loading.value = false;
                      }
                    },
                    text: editList[suppliersItems[key]!.indexWhere(
                            (element) => element.name == itemData.name)]
                        ? "Submit"
                        : "Edit",
                    fontSize: 12,
                    padding: 0,
                    styleFormPadding: 0,
                  ),
                ],
              ),
            ),
          ]),
        );
      }
      Widget itemWidget = CustomContainer(
        outerPadding: const EdgeInsets.only(
          bottom: 20,
        ),
        innerPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        containerColor: const Color(0xFF8EB6D9),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                key,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'ITEM',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'QTY',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'SOLD',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: [
                  ...itemListWidget,
                ],
              ),
            ],
          ),
        ),
      );

      supplierContainerListWidget.add(itemWidget);
    });

    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          UserPageLayout(
            pageWidgets: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Date : ",
                    //   style: const TextStyle(
                    //     fontSize: 25,
                    //     fontWeight: FontWeight.bold,
                    //     // fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                    Obx(
                      () => Text(
                        authController.todayDate.value,
                      style: const TextStyle(
                        fontSize: 25,
                        // fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ...supplierContainerListWidget,
            ],
            shopName: "${Constants.Cashier} - ${widget.shopName!}",
          ),
          Obx(
            () => LoadingPage(
              loading: authController.loading.value,
            ),
          ),
        ],
      ),
    );
  }
}
