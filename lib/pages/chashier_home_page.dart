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

  double totalPriceWE = 0.0;
  double totalPrice = 0.0;

  final TextEditingController extraController = TextEditingController();

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
    setState(() {
      totalPriceWE = 0.0;
      totalPrice = 0.0;
    });

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

      ShopController shopController = Get.find<ShopController>();
      extraController.text = Helpers.numberToStringConverter(
          await shopController.getShopExtra(widget.shopName ?? "",
              DateFormat('yyyy-MM-dd').format(DateTime.now()), session));

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

  bool editShops = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    totalPriceWE = 0.0;
    totalPrice = 0.0;

    Map<String, dynamic> listOftextEditingControllerMapList = {};

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      Map<String, List<TextEditingController>> textEditingControllerMapList =
          {};

      double salePriceT = 0;
      for (var itemData in value) {
        if (itemData.activated == false) {
          continue;
        }
        String item = itemData.name;
        String qty = itemData.qty.toString();
        String remaining = (itemData.qty - itemData.sold).toString();
        TextEditingController qtyController =
            TextEditingController(text: qty == "0" ? "" : qty);
        TextEditingController remainingController =
            TextEditingController(text: remaining == "0" ? "" : remaining);
        textEditingControllerMapList[item] = [
          qtyController,
          remainingController,
        ];
        salePriceT += (itemData.sold * itemData.salePrice);

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(editShops
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
            DataCell(editShops
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: remainingController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                  )
                : Text(remaining)),
          ]),
        );
      }

      listOftextEditingControllerMapList[key] = textEditingControllerMapList;

      totalPriceWE += salePriceT;

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
                      'REMAINING',
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
            ],
          ),
        ),
      );

      if (itemListWidget.length == 0) {
        itemWidget = Container();
      }

      supplierContainerListWidget.add(itemWidget);
    });

    totalPrice = totalPriceWE -
        (extraController.text == "" ? 0 : double.parse(extraController.text));

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
              CustomContainer(
                outerPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                innerPadding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 30,
                ),
                containerColor: Color(0xFFCDE8FF),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Price (without short):',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Helpers.numberToStringConverter(totalPriceWE),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: CustomTextField(
                      controller: extraController,
                      labelText: "Short",
                      hintText: "Enter amount",
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (extraController.text == "") {
                        Helpers.snackBarPrinter(
                          "Failed!",
                          "Please enter a value.",
                          error: true,
                        );
                      } else {
                        ShopController shopController =
                            Get.find<ShopController>();
                        await shopController.updateShopExtra(
                          widget.shopName ?? "",
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          double.parse(extraController.text),
                          session,
                        );

                        setState(() {
                          totalPrice -= double.parse(extraController.text);
                        });
                      }
                    },
                    text: "Submit",
                    fontSize: 12,
                    padding: 0,
                    styleFormPadding: 0,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomContainer(
                outerPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                innerPadding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 30,
                ),
                containerColor: Color(0xFFCDE8FF),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Price:',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Helpers.numberToStringConverter(totalPrice),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  if (!editShops) {
                    setState(() {
                      editShops = true;
                    });
                    return;
                  }

                  authController.loading.value = true;

                  try {
                    suppliersItems.forEach((key, value) async {
                      for (var itemData in value) {
                        if (itemData.activated == false) {
                          continue;
                        }
                        if (listOftextEditingControllerMapList[key]
                                    [itemData.name]![0]
                                .text ==
                            "") {
                          listOftextEditingControllerMapList[key]
                                  [itemData.name]![0]
                              .text = itemData.qty.toString();
                        }
                        if (listOftextEditingControllerMapList[key]
                                    [itemData.name]![1]
                                .text ==
                            "") {
                          listOftextEditingControllerMapList[key]
                                  [itemData.name]![1]
                              .text = (itemData.qty - itemData.sold).toString();
                        }

                        if (itemData.qty.toString() ==
                                listOftextEditingControllerMapList[key]
                                        [itemData.name]![0]
                                    .text &&
                            (itemData.qty - itemData.sold).toString() ==
                                listOftextEditingControllerMapList[key]
                                        [itemData.name]![1]
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
                                      listOftextEditingControllerMapList[key]
                                              [itemData.name]![0]
                                          .text) -
                                  int.parse(
                                      listOftextEditingControllerMapList[key]
                                              [itemData.name]![1]
                                          .text),
                              qty: int.parse(
                                  listOftextEditingControllerMapList[key]
                                          [itemData.name]![0]
                                      .text),
                              purchasePrice: itemData.purchasePrice,
                              salePrice: itemData.salePrice,
                              activated: itemData.activated,
                            ),
                            itemData.date,
                            printSnack: false,
                            widget.shopName ?? "",
                            session,
                          );
                        }
                      }
                    });

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
                      editShops = false;
                    });

                    String dateInput =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());

                    await loadData(dateInput);
                  }
                },
                text: editShops ? "Submit" : "Edit",
                fontSize: 17,
                padding: 20,
                styleFormPadding: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              ...supplierContainerListWidget,
            ],
            shopName: "${Constants.Cashier} - ${widget.shopName!}",
          ),
          const SizedBox(
            height: 20,
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
