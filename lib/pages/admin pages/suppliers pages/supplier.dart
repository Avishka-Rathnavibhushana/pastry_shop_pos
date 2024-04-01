import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/pill_box.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

import '../../../components/custom_dropdown.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key, this.supplier});

  final String? supplier;

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  String dateInput = "";
  String session = Constants.Sessions[0];
  String shop = "";
  Map<String, List<SupplierItem>> supplierItems = {};
  TextEditingController itemController = TextEditingController();
  List<String> items = [];
  bool edit = false;

  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";
  List<String> shops = [];

  // add shop to list
  void addShopToShopList(String shop) {
    if (shop == "Select a shop") {
      return;
    }
    // check if shop is already in list
    if (shops.contains(shop)) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Shop already exists in the list.",
        error: true,
      );
      return;
    } else if (shop.isEmpty) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Shops cannot be empty.",
        error: true,
      );
      return;
    } else {
      if (supplierItems.keys.contains(shop)) {
        Helpers.snackBarPrinter(
          "Failed!",
          "Shop already added to supplier.",
          error: true,
        );
        return;
      }

      shops.add(shop);
      setState(() {
        shopSelectedValue = "Select a shop";
      });
    }

    setState(() {});
  }

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

  Future<bool> submitShops(
    List<String> shops,
  ) async {
    SupplierController supplierController = Get.find<SupplierController>();
    bool result = false;
    bool resultSupplier = await supplierController.addShopsToSupplier(
      widget.supplier ?? "",
      shops,
    );

    if (resultSupplier) {
      ShopController shopController = Get.find<ShopController>();
      for (var shopTemp in shops) {
        await shopController.addSupplierToShop(
          shopTemp,
          widget.supplier ?? "",
        );
      }
    }

    if (resultSupplier) {
      await loadData(dateInput);
      result = true;
    }

    return result;
  }

  Future<void> _populateDropdownItems() async {
    // load shops from database
    AuthController authController = AuthController();
    List<DropdownMenuItem<String>> shops = [];

    await authController.loadShopsList().then((value) {
      value.forEach((element) {
        shops.add(
          DropdownMenuItem(
            value: element,
            child: Text(element),
          ),
        );
      });
    });

    shopDropdownItems.addAll(
      [
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        ...shops,
      ],
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });

    _populateDropdownItems();

    loadData(dateInput);
  }

  // load data from supplierItem
  Future<void> loadData(String date) async {
    Map<String, List<SupplierItem>> supplierItemList = {};

    if (widget.supplier != null) {
      SupplierController supplierController = Get.find<SupplierController>();
      Supplier? supplier =
          await supplierController.getSupplierById(widget.supplier ?? "");

      Map<String, List<SupplierItem>> supplierItemListTemp = {};

      for (String item in supplier!.shops) {
        SupplierItemController supplierItemsController =
            Get.find<SupplierItemController>();

        if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          bool isItemsEqual = await supplierItemsController.isItemsEqual(
            widget.supplier ?? "",
            date,
            item,
            session,
          );

          if (!isItemsEqual) {
            await supplierItemsController
                .getItemsFromSupplierAndAddToSupplierItem(
                    widget.supplier ?? "", date, item, session);
          }
        }

        // load suppliers from database
        List<SupplierItem> supplierItemListSingle =
            await supplierItemsController.getSupplierItemsByShopByTime(
                widget.supplier ?? "", date, item, session);

        supplierItemListTemp[item] = supplierItemListSingle;
      }

      setState(() {
        supplierItems = supplierItemListTemp;
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

    supplierItems.forEach((key, value) {
      List<DataRow> rows = [];

      for (SupplierItem supplierItem in value) {
        String item = supplierItem.name;
        String qty = supplierItem.qty.toString();
        TextEditingController qtyController = TextEditingController(text: qty);
        String remaining = (supplierItem.qty - supplierItem.sold).toString();
        TextEditingController remainingController =
            TextEditingController(text: remaining);
        String salePrice =
            Helpers.numberToStringConverter(supplierItem.salePrice);
        TextEditingController salePriceController =
            TextEditingController(text: salePrice);
        String purchasePrice =
            Helpers.numberToStringConverter(supplierItem.purchasePrice);
        TextEditingController purchasePriceController =
            TextEditingController(text: purchasePrice);
        bool activated =
            supplierItem.activated != null ? supplierItem.activated! : false;

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
                        maxLength: 10,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    )
                  : Text(qty)),
              DataCell(edit
                  ? SizedBox(
                      width: 50,
                      height: 30,
                      child: CustomTextField(
                        controller: remainingController,
                        labelText: '',
                        hintText: '',
                        fontSize: 12,
                        maxLength: 10,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    )
                  : Text(remaining)),
              DataCell(edit
                  ? SizedBox(
                      width: 50,
                      height: 30,
                      child: CustomTextField(
                        controller: salePriceController,
                        labelText: '',
                        hintText: '',
                        fontSize: 12,
                        maxLength: 10,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                        maxLength: 10,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    )
                  : Text(purchasePrice)),
              DataCell(
                edit
                    ? SizedBox(
                        width: 90,
                        height: 35,
                        child: CustomDropdown(
                          dropdownItems: ["Yes", "No"]
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          selectedValue: activated ? "Yes" : "No",
                          onChanged: (String? newValue) {
                            activated = newValue == "Yes" ? true : false;
                          },
                          borderAvailable: false,
                        ),
                      )
                    : Text(activated ? "Yes" : "No"),
              ),
              DataCell(
                CustomButton(
                  onPressed: () async {
                    if (edit) {
                      SupplierItemController supplierItemsController =
                          Get.find<SupplierItemController>();

                      qtyController.text =
                          qty == "0" && qtyController.text == ""
                              ? "0"
                              : qtyController.text;
                      remainingController.text =
                          remaining == "0" && remainingController.text == ""
                              ? "0"
                              : remainingController.text;
                      salePriceController.text =
                          salePrice == "0" && salePriceController.text == ""
                              ? "0"
                              : salePriceController.text;
                      purchasePriceController.text = purchasePrice == "0" &&
                              purchasePriceController.text == ""
                          ? "0"
                          : purchasePriceController.text;

                      if (qtyController.text.isEmpty ||
                          remainingController.text.isEmpty ||
                          salePriceController.text.isEmpty ||
                          purchasePriceController.text.isEmpty) {
                        Helpers.snackBarPrinter(
                          "Failed!",
                          "Fields cannot be empty.",
                          error: true,
                        );
                        return;
                      }

                      if (qtyController.text == qty &&
                          remainingController.text == remaining &&
                          salePriceController.text == salePrice &&
                          purchasePriceController.text == purchasePrice &&
                          activated == supplierItem.activated) {
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
                          sold: (int.parse(qtyController.text) -
                              int.parse(remainingController.text)),
                          salePrice: double.parse(salePriceController.text),
                          purchasePrice:
                              double.parse(purchasePriceController.text),
                          qty: int.parse(qtyController.text),
                          activated: activated,
                        ),
                        supplierItem.date,
                        key,
                        session,
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

      Widget itemWidget = CustomContainer(
        outerPadding: const EdgeInsets.only(
          bottom: 20,
        ),
        innerPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        containerColor: const Color(0xFFCDE8FF),
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
                      'Remaining',
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
                      'Show',
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
              widget.supplier ?? "",
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
                      textInputAction: TextInputAction.done,
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
                    child: CustomDropdown(
                      dropdownItems: shopDropdownItems,
                      selectedValue: shopSelectedValue!,
                      onChanged: (String? newValue) {
                        setState(() {
                          shopSelectedValue = newValue;
                        });
                        addShopToShopList(newValue!);
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
                      children: shops.map((shop) {
                        return PillBox(
                          text: shop,
                          onClose: () {
                            // Implement close button functionality
                            setState(() {
                              shops.remove(shop);
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
                    if (shops.isEmpty) {
                      Helpers.snackBarPrinter(
                        "Failed!",
                        "Shop list cannot be empty.",
                        error: true,
                      );
                      return;
                    }

                    bool result = await submitShops(shops);
                    if (result) {
                      // clear fields
                      shopSelectedValue = "Select a shop";
                      shops.clear();
                      shops = [];

                      setState(() {});
                    }
                  },
                  text: shops.length == 1 ? 'Add Shop' : 'Add Shops',
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: SizedBox(
              width: 300,
              child: IgnorePointer(
                ignoring: edit,
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
          ),
          const SizedBox(
            height: 20,
          ),
          ...supplierContainerListWidget,
        ],
      ),
    );
  }
}
