import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

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

  Map<String, List<SupplierItem>> suppliersItems = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
    loadData(dateInput);
  }

  // load data from supplierItem
  Future<void> loadData(String date) async {
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
          await supplierItemsController.getSupplierItems(supplier, date);

      setState(() {
        suppliersItems[supplier] = supplierItemList;
      });
    }
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    List<DataRow> supplierContainerListWidgetRows = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];

      double salePriceT = 0;
      double purchasePriceT = 0;

      for (var itemData in value) {
        salePriceT += (itemData.sold * itemData.salePrice);
        purchasePriceT += (itemData.qty * itemData.purchasePrice);
      }

      supplierContainerListWidgetRows.add(
        DataRow(cells: [
          DataCell(Text(key)),
          DataCell(Text(Helpers.numberToStringConverter(salePriceT))),
          DataCell(Text(Helpers.numberToStringConverter(purchasePriceT))),
        ]),
      );
    });

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
                        label: Text('Sale Price\nTotal',
                            style: tableColumnHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Purchase Price\nTotal',
                            style: tableColumnHeaderStyle),
                      ),
                    ],
                    rows: [
                      ...supplierContainerListWidgetRows,
                    ],
                  ),
                ],
              ),
            ),
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
