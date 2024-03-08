import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';
import 'package:pastry_shop_pos/pages/loadingPage.dart';

import '../../../components/custom_dropdown.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.shop});

  final String? shop;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String dateInput = "";
  String session = Constants.Sessions[0];
  Map<String, List<SupplierItem>> suppliersItems = {};

  double totalPrice = 0.0;
  double totalPaid = 0.0;

  AuthController authController = Get.find<AuthController>();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    authController.loading.value = true;

    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });

    loadData(dateInput);
  }

  // load data from supplierItem
  Future<void> loadData(String date) async {
    authController.loading.value = true;
    setState(() {
      totalPrice = 0.0;
      totalPaid = 0.0;
      loading = true;
    });

    Map<String, List<SupplierItem>> suppliersItemsTemp = {};

    try {
      if (widget.shop != null) {
        ShopController shopController = Get.find<ShopController>();
        List<String> supplierList =
            await shopController.getSuppliersOfShop(widget.shop ?? "");

        SupplierItemController supplierItemsController =
            Get.find<SupplierItemController>();

        if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          for (String supplier in supplierList) {
            bool isItemsEqual = await supplierItemsController.isItemsEqual(
              supplier,
              date,
              widget.shop ?? "",
              session,
            );

            if (!isItemsEqual) {
              await supplierItemsController
                  .getItemsFromSupplierAndAddToSupplierItem(
                      supplier, date, widget.shop ?? "", session);
            }
          }
        }

        for (String supplier in supplierList) {
          // load suppliers from database
          List<SupplierItem> supplierItemList =
              await supplierItemsController.getSupplierItemsByShopByTime(
                  supplier, date, widget.shop ?? "", session);

          suppliersItemsTemp[supplier] = supplierItemList;
        }
      }

      setState(() {
        suppliersItems = suppliersItemsTemp;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      authController.loading.value = false;
    }
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    if (authController.loading.value) {
      return Obx(() => LoadingPage(
            loading: authController.loading.value,
          ));
    }

    List<Widget> supplierContainerListWidget = [];

    suppliersItems.forEach((key, value) {
      List<DataRow> itemListWidget = [];

      int qtyT = 0;
      int soldT = 0;
      int balanceT = 0;
      double salePriceT = 0;
      double purchasePriceT = 0;
      double cheapT = 0;

      for (SupplierItem itemData in value) {
        if (itemData.activated == false) {
          continue;
        }
        String item = itemData.name;
        String qty = itemData.qty.toString();
        qtyT += itemData.qty;
        String sold = itemData.sold.toString();
        soldT += itemData.sold;
        String balance = (itemData.qty - itemData.sold).toString();
        balanceT += (itemData.qty - itemData.sold);
        String salePrice = Helpers.numberToStringConverter(itemData.salePrice);
        String salePriceTotal =
            Helpers.numberToStringConverter(itemData.sold * itemData.salePrice);
        salePriceT += (itemData.sold * itemData.salePrice);
        String purchasePrice =
            Helpers.numberToStringConverter(itemData.purchasePrice);
        String purchasePriceTotal = Helpers.numberToStringConverter(
            (itemData.sold * itemData.purchasePrice));
        purchasePriceT += (itemData.sold * itemData.purchasePrice);
        String cheap = Helpers.numberToStringConverter(
            ((itemData.sold * itemData.salePrice) -
                (itemData.sold * itemData.purchasePrice)));
        cheapT += ((itemData.sold * itemData.salePrice) -
            (itemData.sold * itemData.purchasePrice));

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

      totalPrice += salePriceT;
      totalPaid += purchasePriceT;

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
                      Helpers.numberToStringConverter(salePriceT),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      Helpers.numberToStringConverter(purchasePriceT),
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      Helpers.numberToStringConverter(cheapT),
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

    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "${widget.shop ?? ""} Summary",
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
                    await loadData(formattedDate);
                    setState(() {
                      dateInput =
                          formattedDate; //set output date to TextField value.
                    });
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: SizedBox(
              width: 300,
              child: CustomDropdown(
                dropdownItems:
                    Constants.Sessions.map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        )).toList(),
                selectedValue: session,
                onChanged: (String? newValue) async {
                  setState(() {
                    session = newValue!;
                  });

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
                      'Total Price :',
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
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Paid :',
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
                      Helpers.numberToStringConverter(totalPaid),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CHEAP :',
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
                      Helpers.numberToStringConverter((totalPrice - totalPaid)),
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
            height: 10,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Suppliers Summary',
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
          ...supplierContainerListWidget,
        ],
      ),
    );
  }
}
