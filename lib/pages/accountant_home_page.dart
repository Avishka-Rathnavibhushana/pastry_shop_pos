import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';
import 'package:pastry_shop_pos/pages/loadingPage.dart';

import '../components/custom_dropdown.dart';

class AccountantHomePage extends StatefulWidget {
  const AccountantHomePage({
    super.key,
    required this.shopName,
  });

  final String? shopName;

  @override
  State<AccountantHomePage> createState() => _AccountantHomePageState();
}

class _AccountantHomePageState extends State<AccountantHomePage> {
  String dateInput = "";

  Map<String, List<SupplierItem>> suppliersItemsMorning = {};
  Map<String, List<SupplierItem>> suppliersItemsEvening = {};

  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
    loadData(dateInput);
  }

  Future<void> loadData(String date) async {
    authController.loading.value = true;

    try {
      Map<String, List<SupplierItem>> suppliersItemsMorningTemp =
          await loadDataForSession(date, Constants.Sessions[0]);
      Map<String, List<SupplierItem>> suppliersItemsEveningTemp =
          await loadDataForSession(date, Constants.Sessions[1]);

      setState(() {
        suppliersItemsMorning = suppliersItemsMorningTemp;
        suppliersItemsEvening = suppliersItemsEveningTemp;
      });
    } catch (e) {
      authController.loading.value = false;

      print(e);
    } finally {
      authController.loading.value = false;
    }
  }

  // load data from supplierItem for a session
  Future<Map<String, List<SupplierItem>>> loadDataForSession(
      String date, String session) async {
    Map<String, List<SupplierItem>> suppliersItemsTemp = {};

    if (widget.shopName != null) {
      ShopController shopController = Get.find<ShopController>();
      List<String> supplierList =
          await shopController.getSuppliersOfShop(widget.shopName ?? "");

      SupplierItemController supplierItemsController =
          Get.find<SupplierItemController>();

      // if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      //   for (String supplier in supplierList) {
      //     bool isItemsEqual = await supplierItemsController.isItemsEqual(
      //       supplier,
      //       date,
      //     );
      //     if (!isItemsEqual) {
      //       await supplierItemsController
      //           .getItemsFromSupplierAndAddToSupplierItem(supplier, date);
      //     }
      //   }
      // }

      for (String supplier in supplierList) {
        // load suppliers from database
        List<SupplierItem> supplierItemList =
            await supplierItemsController.getSupplierItemsByShopByTime(
                supplier, date, widget.shopName ?? "", session);

        suppliersItemsTemp[supplier] = supplierItemList;
      }

      return suppliersItemsTemp;
    }

    return {};
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  @override
  void dispose() {
    authController.loading.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authController.loading.value) {
      return Obx(() => LoadingPage(
            loading: authController.loading.value,
          ));
    }

    List<DataRow> supplierContainerListWidgetRows = [];

    double totalSalePriceTM = 0;
    double totalPurchasePriceTM = 0;
    double totalSalePriceTE = 0;
    double totalPurchasePriceTE = 0;
    double totalSalePrice = 0;
    double totalPurchasePrice = 0;

    suppliersItemsMorning.forEach((key, value) {
      List<DataRow> itemListWidget = [];

      double salePriceTM = 0;
      double purchasePriceTM = 0;
      double salePriceTE = 0;
      double purchasePriceTE = 0;

      for (var itemData in value) {
        if (itemData.activated == false) {
          continue;
        }
        salePriceTM += (itemData.sold * itemData.salePrice);
        purchasePriceTM += (itemData.sold * itemData.purchasePrice);
      }
      for (var itemData in suppliersItemsEvening[key]!) {
        if (itemData.activated == false) {
          continue;
        }
        salePriceTE += (itemData.sold * itemData.salePrice);
        purchasePriceTE += (itemData.sold * itemData.purchasePrice);
      }

      totalSalePriceTM += salePriceTM;
      totalPurchasePriceTM += purchasePriceTM;
      totalSalePriceTE += salePriceTE;
      totalPurchasePriceTE += purchasePriceTE;
      totalSalePrice += salePriceTM + salePriceTE;
      totalPurchasePrice += purchasePriceTM + purchasePriceTE;

      supplierContainerListWidgetRows.add(
        DataRow(cells: [
          DataCell(Text(key)),
          DataCell(Text(Helpers.numberToStringConverter(salePriceTM))),
          DataCell(Text(Helpers.numberToStringConverter(purchasePriceTM))),
          DataCell(Text(Helpers.numberToStringConverter(salePriceTE))),
          DataCell(Text(Helpers.numberToStringConverter(purchasePriceTE))),
          DataCell(
              Text(Helpers.numberToStringConverter(salePriceTM + salePriceTE))),
          DataCell(Text(Helpers.numberToStringConverter(
              purchasePriceTM + purchasePriceTE))),
        ]),
      );
    });

    DataRow totalRow = DataRow(cells: [
      DataCell(Text("Total")),
      DataCell(Text(Helpers.numberToStringConverter(totalSalePriceTM))),
      DataCell(Text(Helpers.numberToStringConverter(totalPurchasePriceTM))),
      DataCell(Text(Helpers.numberToStringConverter(totalSalePriceTE))),
      DataCell(Text(Helpers.numberToStringConverter(totalPurchasePriceTE))),
      DataCell(Text(Helpers.numberToStringConverter(totalSalePrice))),
      DataCell(Text(Helpers.numberToStringConverter(totalPurchasePrice))),
    ]);

    Widget pageData = Center(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Shop Summary",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateInput,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              CustomButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dateInput == ""
                        ? DateTime.now()
                        : DateTime.parse(dateInput),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateInput =
                          formattedDate; //set output date to TextField value.
                    });

                    loadData(dateInput);
                  }
                },
                text: 'Select Date',
                padding: 0,
                styleFormPadding: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomContainer(
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
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Supplier', style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Morning\nSale Price',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Morning\nPurchase Price',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Evening\nSale Price',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Evening\nPurchase Price',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Total\nSale Price',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Total\nPurchase Price',
                            style: tableColumnHeaderStyle),
                      ),
                    ],
                    rows: [
                      ...supplierContainerListWidgetRows,
                      totalRow,
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    return Container(
      alignment: Alignment.center,
      child: UserPageLayout(
        pageWidgets: [
          pageData,
        ],
        shopName: "${Constants.Accountant} - ${widget.shopName!}",
      ),
    );
  }
}
