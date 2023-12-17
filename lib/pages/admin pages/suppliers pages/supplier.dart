import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/pill_box.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key, this.supplier});

  final String? supplier;

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  String dateInput = "";
  List<SupplierItem> supplierItems = [];
  TextEditingController itemController = TextEditingController();
  List<String> items = [];
  bool edit = false;

  // add item to list
  Future<void> addItemToList(String item) async {
    // check if item is already in list
    if (items.contains(item)) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Item already exists in the list.",
        error: true,
      );
      return;
    } else if (item.isEmpty) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Item cannot be empty.",
        error: true,
      );
      return;
    } else {
      SupplierController supplierController = Get.find<SupplierController>();
      bool itemExist = await supplierController.checkItemExistInSupplier(
          widget.supplier!, item);
      if (itemExist) {
        Helpers.snackBarPrinter(
          "Failed!",
          "Item already exists in the Supplier.",
          error: true,
        );
        return;
      }

      items.add(item);
      itemController.clear();
    }

    setState(() {});
  }

  Future<bool> submit(
    List<String> items,
  ) async {
    SupplierController supplierController = Get.find<SupplierController>();
    bool result = false;
    bool resultSupplier = await supplierController.addItemsToSupplier(
      widget.supplier ?? "",
      items,
    );

    if (resultSupplier) {
      await loadData(dateInput);
      result = true;
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });

    loadData(dateInput);
  }

  // load data from supplierItem
  Future<void> loadData(String date) async {
    SupplierItemController supplierItemsController =
        Get.find<SupplierItemController>();

    if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      bool isItemsEqual = await supplierItemsController.isItemsEqual(
        widget.supplier ?? " ",
        date,
      );

      if (!isItemsEqual) {
        await supplierItemsController.getItemsFromSupplierAndAddToSupplierItem(
            widget.supplier ?? "", date);
      }
    }

    // load suppliers from database
    List<SupplierItem> supplierItemList = await supplierItemsController
        .getSupplierItems(widget.supplier ?? " ", date);

    setState(() {
      supplierItems = supplierItemList;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    for (SupplierItem supplierItem in supplierItems) {
      String item = supplierItem.name;
      String qty = supplierItem.qty.toString();
      TextEditingController qtyController = TextEditingController(text: qty);
      String sold = supplierItem.sold.toString();
      TextEditingController soldController = TextEditingController(text: sold);
      String salePrice = supplierItem.salePrice.toString();
      TextEditingController salePriceController =
          TextEditingController(text: salePrice);
      String purchasePrice = supplierItem.purchasePrice.toString();
      TextEditingController purchasePriceController =
          TextEditingController(text: purchasePrice);

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(item)),
            DataCell(edit
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: qtyController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  )
                : Text(qty)),
            DataCell(edit
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: soldController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  )
                : Text(sold)),
            DataCell(edit
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: salePriceController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  )
                : Text(salePrice)),
            DataCell(edit
                ? SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: purchasePriceController,
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  )
                : Text(purchasePrice)),
            DataCell(
              CustomButton(
                onPressed: () async {
                  if (edit) {
                    SupplierItemController supplierItemsController =
                        Get.find<SupplierItemController>();
                    if (qtyController.text.isEmpty ||
                        soldController.text.isEmpty ||
                        salePriceController.text.isEmpty ||
                        purchasePriceController.text.isEmpty) {
                      Helpers.snackBarPrinter(
                        "Failed!",
                        "Fields cannot be empty.",
                        error: true,
                      );
                      return;
                    }
                    // if (int.parse(qtyController.text) <
                    //     int.parse(soldController.text)) {
                    //   Helpers.snackBarPrinter(
                    //     "Failed!",
                    //     "Sold cannot be greater than qty.",
                    //     error: true,
                    //   );
                    //   return;
                    // }
                    // if (double.parse(salePriceController.text) <
                    //     double.parse(purchasePriceController.text)) {
                    //   Helpers.snackBarPrinter(
                    //     "Failed!",
                    //     "Sale price cannot be less than purchase price.",
                    //     error: true,
                    //   );
                    //   return;
                    // }
                    if (qtyController.text == qty &&
                        soldController.text == sold &&
                        salePriceController.text == salePrice &&
                        purchasePriceController.text == purchasePrice) {
                      Helpers.snackBarPrinter(
                        "Failed!",
                        "Item Values are same",
                        error: true,
                      );
                      return;
                    }

                    // update item
                    await supplierItemsController.updateItemInSupplierItem(
                      widget.supplier ?? "",
                      SupplierItem(
                        name: item,
                        date: supplierItem.date,
                        sold: int.parse(soldController.text),
                        salePrice: double.parse(salePriceController.text),
                        purchasePrice:
                            double.parse(purchasePriceController.text),
                        qty: int.parse(qtyController.text),
                      ),
                      supplierItem.date,
                    );
                  }
                },
                isIcon: true,
                isText: false,
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                fontSize: 12,
                padding: 0,
                styleFormPadding: 0,
                enabled: edit,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Supplier 1',
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
          CustomContainer(
            outerPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            innerPadding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 0,
            ),
            containerColor: const Color(0xFFCDE8FF),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: 300,
                    child: CustomTextField(
                      controller: itemController,
                      labelText: 'Item',
                      hintText: 'Enter item name',
                      onSubmitted: (value) {
                        addItemToList(value);
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Container(
                    width: 300,
                    child: Wrap(
                      spacing: 8.0, // Adjust the spacing between pill boxes
                      runSpacing:
                          8.0, // Adjust the spacing between rows of pill boxes
                      alignment: WrapAlignment.center,
                      children: items.map((item) {
                        return PillBox(
                          text: item,
                          onClose: () {
                            // Implement close button functionality

                            setState(() {
                              items.remove(item);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // PillBox(text: "text", onClose: () {}),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: () async {
                    if (items.isEmpty) {
                      Helpers.snackBarPrinter(
                        "Failed!",
                        "Item list cannot be empty.",
                        error: true,
                      );
                      return;
                    }

                    bool result = await submit(items);
                    if (result) {
                      // clear fields
                      itemController.clear();
                      items.clear();
                      items = [];

                      setState(() {});
                    }
                  },
                  text: items.length == 1 ? 'Add New Item' : 'Add New Items',
                  enabled: !edit,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
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
                    loadData(formattedDate);
                    setState(() {
                      dateInput =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
                text: 'Select Date',
                padding: 0,
                styleFormPadding: 10,
                enabled: !edit,
              ),
              dateInput == DateFormat('yyyy-MM-dd').format(DateTime.now())
                  ? const SizedBox(
                      width: 20,
                    )
                  : Container(),
              dateInput == DateFormat('yyyy-MM-dd').format(DateTime.now())
                  ? CustomButton(
                      onPressed: () async {
                        // if (items.isEmpty) {
                        //   Helpers.snackBarPrinter(
                        //     "Failed!",
                        //     "Item list cannot be empty.",
                        //     error: true,
                        //   );
                        //   return;
                        // }

                        // bool result = await submit(items);
                        // if (result) {
                        //   // clear fields
                        //   itemController.clear();
                        //   items.clear();
                        //   items = [];

                        //   setState(() {});
                        // }

                        if (edit) {
                          await loadData(dateInput);
                        }

                        setState(() {
                          edit = !edit;
                        });
                      },
                      text: edit ? 'Done' : 'Edit',
                      padding: 0,
                      styleFormPadding: 10,
                    )
                  : Container(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomContainer(
            outerPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            innerPadding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 0,
            ),
            containerColor: const Color(0xFFCDE8FF),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'Item Name',
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
                      'Sold',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sale Price',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purchase Price',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
