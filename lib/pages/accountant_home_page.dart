import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
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
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];

      int qtyT = 0;
      int soldT = 0;
      int balanceT = 0;
      double salePriceT = 0;
      double purchasePriceT = 0;
      double cheapT = 0;

      for (var itemData in value) {
        String item = itemData.name;
        String qty = itemData.qty.toString();
        qtyT += itemData.qty;
        String sold = itemData.sold.toString();
        soldT += itemData.sold;
        String balance = (itemData.qty - itemData.sold).toString();
        balanceT += (itemData.qty - itemData.sold);
        String salePrice = itemData.salePrice.toString();
        String salePriceTotal = (itemData.sold * itemData.salePrice).toString();
        salePriceT += (itemData.sold * itemData.salePrice);
        String purchasePrice = itemData.purchasePrice.toString();
        String purchasePriceTotal =
            (itemData.qty * itemData.purchasePrice).toString();
        purchasePriceT += (itemData.qty * itemData.purchasePrice);
        String cheap = ((itemData.qty * itemData.purchasePrice) -
                (itemData.sold * itemData.salePrice))
            .toString();
        cheapT += ((itemData.qty * itemData.purchasePrice) -
            (itemData.sold * itemData.salePrice));

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(Text(balance)),
            DataCell(Text(salePrice)),
            DataCell(Text(salePriceTotal)),
            DataCell(Text(purchasePrice)),
            DataCell(Text(purchasePriceTotal)),
            DataCell(Text(cheap)),
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
                columns: [
                  DataColumn(
                    label: Text('ITEM', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('QTY', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('SOLD', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Balance', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Sale\nPrice', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Sale Price\nTotal',
                        style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label:
                        Text('Purchase\nPrice', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Purchase Price\nTotal',
                        style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('CHEAP', style: tableColumnHeaderStyle),
                  ),
                ],
                rows: [
                  ...itemListWidget,
                  DataRow(cells: [
                    DataCell(Text(
                      "Total",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      qtyT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      soldT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      balanceT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      salePriceT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      purchasePriceT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      cheapT.toString(),
                      style: tableColumnHeaderStyle,
                    )),
                  ]),
                ],
              ),
            ],
          ),
        ),
      );

      supplierContainerListWidget.add(itemWidget);
    });

    Widget pageData = Center(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Shop 1',
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
          ...supplierContainerListWidget,
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
