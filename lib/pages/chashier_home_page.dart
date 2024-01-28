import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
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
  String session = Constants.Sessions[0];

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
    Map<String, List<SupplierItem>> suppliersItemsTemp = {};

    try {
      if (widget.shopName != null) {
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
              widget.shopName ?? "",
              session,
            );
            if (!isItemsEqual) {
              await supplierItemsController
                  .getItemsFromSupplierAndAddToSupplierItem(
                      supplier, date, widget.shopName ?? "", session);
            }
          }
        }

        for (String supplier in supplierList) {
          // load suppliers from database
          List<SupplierItem> supplierItemList =
              await supplierItemsController.getSupplierItemsByShopByTime(
                  supplier, date, widget.shopName ?? "", session);

          suppliersItemsTemp[supplier] = supplierItemList;
        }
      }

      setState(() {
        suppliersItems = suppliersItemsTemp;
      });
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(Duration(seconds: 1));
      authController.loading.value = false;
    }
  }

  String editShop = "";

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      Map<String, List<TextEditingController>> textEditingControllerMapList =
          {};
      for (var itemData in value) {
        String item = itemData.name;
        String qty = itemData.qty.toString();
        String sold = itemData.sold.toString();
        TextEditingController qtyController =
            TextEditingController(text: qty == "0" ? "" : qty);
        TextEditingController soldController =
            TextEditingController(text: sold == "0" ? "" : sold);
        textEditingControllerMapList[item] = [
          qtyController,
          soldController,
        ];

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(key == editShop
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
            DataCell(key == editShop
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
                  // DataColumn(
                  //   label: Text(
                  //     'Edit',
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
                rows: [
                  ...itemListWidget,
                ],
              ),
              CustomButton(
                onPressed: () async {
                  if (key != editShop) {
                    setState(() {
                      editShop = key;
                    });
                    return;
                  }

                  authController.loading.value = true;

                  try {
                    for (var itemData in value) {
                      if (textEditingControllerMapList[itemData.name]![0]
                              .text ==
                          "") {
                        textEditingControllerMapList[itemData.name]![0].text =
                            itemData.qty.toString();
                      }
                      if (textEditingControllerMapList[itemData.name]![1]
                              .text ==
                          "") {
                        textEditingControllerMapList[itemData.name]![1].text =
                            itemData.sold.toString();
                      }

                      if (itemData.qty ==
                              textEditingControllerMapList[itemData.name]![0]
                                  .text &&
                          itemData.sold ==
                              textEditingControllerMapList[itemData.name]![1]
                                  .text) {
                      } else {
                        SupplierItemController supplierItemsController =
                            Get.find<SupplierItemController>();

                        // update item
                        bool result = await supplierItemsController
                            .updateItemInSupplierItem(
                          key,
                          SupplierItem(
                            name: itemData.name,
                            date: itemData.date,
                            sold: int.parse(
                                textEditingControllerMapList[itemData.name]![1]
                                    .text),
                            qty: int.parse(
                                textEditingControllerMapList[itemData.name]![0]
                                    .text),
                            purchasePrice: itemData.purchasePrice,
                            salePrice: itemData.salePrice,
                          ),
                          itemData.date,
                          printSnack: false,
                          widget.shopName ?? "",
                          session,
                        );

                        if (result) {
                          int index = suppliersItems[key]!.indexWhere(
                              (element) => element.name == itemData.name);

                          suppliersItems[key]![index].sold = int.parse(
                              textEditingControllerMapList[itemData.name]![1]
                                  .text);
                          suppliersItems[key]![index].qty = int.parse(
                              textEditingControllerMapList[itemData.name]![0]
                                  .text);
                        }
                      }
                    }

                    Helpers.snackBarPrinter(
                        "Successful!", "Successfully updated.");
                  } catch (e) {
                    Helpers.snackBarPrinter(
                      "Failed!",
                      "Something is wrong. Please try again.",
                      error: true,
                    );
                    print(e);
                  } finally {
                    await Future.delayed(Duration(seconds: 1));
                    authController.loading.value = false;
                    setState(() {
                      editShop = "";
                    });
                  }
                },
                text: key == editShop ? "Submit" : "Edit",
                fontSize: 12,
                padding: 0,
                styleFormPadding: 0,
                enabled: key == editShop || editShop == "",
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: 300,
                  child: CustomDropdown(
                    dropdownItems: Constants.Sessions.map(
                        (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            )).toList(),
                    selectedValue: session,
                    onChanged: (String? newValue) async {
                      setState(() {
                        session = newValue!;
                      });

                      String dateInput =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                      await loadData(dateInput);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
