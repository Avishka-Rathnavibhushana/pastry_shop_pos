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
import 'package:pastry_shop_pos/pages/loadingPage.dart';

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

  AuthController authController = Get.find<AuthController>();

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
    authController.loading.value = true;

    // load shops from database
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
    authController.loading.value = false;
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
    authController.loading.value = true;

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

    authController.loading.value = false;
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
    List<Widget> supplierContainerListWidget = [];

    supplierItems.forEach((key, value) {
      List<DataRow> rows = [];

      Map<String, List<dynamic>> textEditingControllerMapList = {};

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

        textEditingControllerMapList[item] = [
          qtyController,
          remainingController,
          salePriceController,
          purchasePriceController,
          activated
        ];

        rows.add(
          DataRow(
            cells: [
              DataCell(Text(item)),
              DataCell(edit
                  ? SizedBox(
                      width: 50,
                      height: 30,
                      child: CustomTextField(
                        controller: textEditingControllerMapList[item]![0],
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
                        controller: textEditingControllerMapList[item]![1],
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
                        controller: textEditingControllerMapList[item]![2],
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
                        controller: textEditingControllerMapList[item]![3],
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
                          selectedValue: textEditingControllerMapList[item]![4]
                              ? "Yes"
                              : "No",
                          onChanged: (String? newValue) {
                            textEditingControllerMapList[item]![4] =
                                newValue == "Yes" ? true : false;
                          },
                          borderAvailable: false,
                        ),
                      )
                    : Text(
                        textEditingControllerMapList[item]![4] ? "Yes" : "No"),
              ),
              DataCell(
                Text("data"),
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
              SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  authController.loading.value = true;
                  if (edit) {
                    SupplierItemController supplierItemsController =
                        Get.find<SupplierItemController>();

                    for (SupplierItem supplierItem in value) {
                      String item = supplierItem.name;
                      String qtyInitial = supplierItem.qty.toString();
                      String remainingInitial =
                          (supplierItem.qty - supplierItem.sold).toString();
                      String salePriceInitial = Helpers.numberToStringConverter(
                          supplierItem.salePrice);
                      String purchasePriceInitial =
                          Helpers.numberToStringConverter(
                              supplierItem.purchasePrice);
                      bool activatedInital = supplierItem.activated != null
                          ? supplierItem.activated!
                          : false;

                      textEditingControllerMapList[item]![0]
                          .text = qtyInitial == "0" &&
                              textEditingControllerMapList[item]![0].text == ""
                          ? "0"
                          : textEditingControllerMapList[item]![0].text;
                      textEditingControllerMapList[item]![1]
                          .text = remainingInitial == "0" &&
                              textEditingControllerMapList[item]![1].text == ""
                          ? "0"
                          : textEditingControllerMapList[item]![1].text;
                      textEditingControllerMapList[item]![2]
                          .text = salePriceInitial == "0" &&
                              textEditingControllerMapList[item]![2].text == ""
                          ? "0"
                          : textEditingControllerMapList[item]![2].text;
                      textEditingControllerMapList[item]![3]
                          .text = purchasePriceInitial == "0" &&
                              textEditingControllerMapList[item]![3].text == ""
                          ? "0"
                          : textEditingControllerMapList[item]![3].text;

                      if (textEditingControllerMapList[item]![0].text ==
                              qtyInitial &&
                          textEditingControllerMapList[item]![1].text ==
                              remainingInitial &&
                          textEditingControllerMapList[item]![2].text ==
                              salePriceInitial &&
                          textEditingControllerMapList[item]![3].text ==
                              purchasePriceInitial &&
                          textEditingControllerMapList[item]![4] ==
                              activatedInital) {
                        // Helpers.snackBarPrinter(
                        //   "Failed!",
                        //   "Item Values are same",
                        //   error: true,
                        // );
                        // return;
                        continue;
                      }

                      if (textEditingControllerMapList[item]![0].text.isEmpty ||
                          textEditingControllerMapList[item]![1].text.isEmpty ||
                          textEditingControllerMapList[item]![2].text.isEmpty ||
                          textEditingControllerMapList[item]![3].text.isEmpty) {
                        if (textEditingControllerMapList[item]![0]
                            .text
                            .isEmpty) {
                          textEditingControllerMapList[item]![0].text = "0";
                        }
                        if (textEditingControllerMapList[item]![1]
                            .text
                            .isEmpty) {
                          textEditingControllerMapList[item]![1].text = "0";
                        }
                        if (textEditingControllerMapList[item]![2]
                            .text
                            .isEmpty) {
                          textEditingControllerMapList[item]![2].text = "0";
                        }
                        if (textEditingControllerMapList[item]![3]
                            .text
                            .isEmpty) {
                          textEditingControllerMapList[item]![3].text = "0";
                        }
                        // Helpers.snackBarPrinter(
                        //   "Failed!",
                        //   "Fields cannot be empty.",
                        //   error: true,
                        // );
                        // return;
                      }

                      // update item
                      await supplierItemsController.updateItemInSupplierItem(
                        widget.supplier ?? "",
                        SupplierItem(
                          name: item,
                          date: supplierItem.date,
                          sold: (int.parse(
                                  textEditingControllerMapList[item]![0].text) -
                              int.parse(
                                  textEditingControllerMapList[item]![1].text)),
                          salePrice: double.parse(
                              textEditingControllerMapList[item]![2].text),
                          purchasePrice: double.parse(
                              textEditingControllerMapList[item]![3].text),
                          qty: int.parse(
                              textEditingControllerMapList[item]![0].text),
                          activated: textEditingControllerMapList[item]![4],
                        ),
                        supplierItem.date,
                        key,
                        session,
                        printSnack: false,
                      );
                    }

                    Helpers.snackBarPrinter(
                      "Success!",
                      "Items updated successfully.",
                    );
                  }

                  authController.loading.value = false;
                },
                isIcon: true,
                isText: false,
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                fontSize: 12,
                padding: 15,
                styleFormPadding: 0,
                enabled: edit,
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
