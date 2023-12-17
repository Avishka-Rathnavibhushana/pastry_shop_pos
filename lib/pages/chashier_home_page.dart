import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());

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

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      for (var itemData in value) {
        String item = itemData.name;
        String qty = itemData.qty.toString();
        String sold = itemData.sold.toString();
        TextEditingController soldController = TextEditingController();

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: soldController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                    onPressed: () async {
                      SupplierItemController supplierItemsController =
                          Get.find<SupplierItemController>();

                      int soldAmount =
                          (int.parse(sold) + int.parse(soldController.text));
                      // update item
                      bool result = await supplierItemsController
                          .updateItemInSupplierItem(
                        key,
                        SupplierItem(
                          name: item,
                          date: itemData.date,
                          sold: soldAmount,
                          qty: itemData.qty,
                          purchasePrice: itemData.purchasePrice,
                          salePrice: itemData.salePrice,
                        ),
                        itemData.date,
                      );
                      if (result) {
                        int index = suppliersItems[key]!
                            .indexWhere((element) => element.name == item);
                        setState(() {
                          suppliersItems[key]![index].sold = soldAmount;
                        });
                      }
                      soldController.clear();
                    },
                    text: "Submit",
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
                      'SOLD AMOUNT',
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
      child: UserPageLayout(
        pageWidgets: [
          ...supplierContainerListWidget,
        ],
        shopName: "${Constants.Cashier} - ${widget.shopName!}",
      ),
    );
  }
}
