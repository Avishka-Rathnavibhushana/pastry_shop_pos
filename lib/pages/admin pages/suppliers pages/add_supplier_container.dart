import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/pill_box.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier.dart';

class AddSupplierContainer extends StatefulWidget {
  const AddSupplierContainer({super.key, required this.submit});

  final Future<bool> Function(
    Supplier supplier,
  ) submit;

  @override
  State<AddSupplierContainer> createState() => _AddSupplierContainerState();
}

class _AddSupplierContainerState extends State<AddSupplierContainer> {
  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";
  List<String> shops = [];
  List<String> items = [];
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierAddressController = TextEditingController();
  TextEditingController supplierTelController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  // add item to list
  void addItemToList(String item) {
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
      items.add(item);
      itemController.clear();
    }

    setState(() {});
  }

  // add shop to list
  void addItemToShopList(String shop) {
    if (shop == "Select a shop") {
      return;
    }
    // check if shop is already in list
    if (shops.contains(shop)) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Item already exists in the list.",
        error: true,
      );
      return;
    } else if (shop.isEmpty) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Item cannot be empty.",
        error: true,
      );
      return;
    } else {
      shops.add(shop);
      setState(() {
        shopSelectedValue = "Select a shop";
      });
    }

    setState(() {});
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
    _populateDropdownItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Add Supplier',
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
                    controller: supplierNameController,
                    labelText: 'Supplier name',
                    hintText: 'Enter Supplier Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: 300,
                  child: CustomTextField(
                    controller: supplierAddressController,
                    labelText: 'Supplier Address',
                    hintText: 'Enter Supplier Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: 300,
                  child: CustomTextField(
                    controller: supplierTelController,
                    labelText: 'Supplier Tel.',
                    hintText: 'Enter Supplier Telephone number',
                  ),
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
                    dropdownItems: shopDropdownItems,
                    selectedValue: shopSelectedValue!,
                    onChanged: (String? newValue) {
                      setState(() {
                        shopSelectedValue = newValue;
                      });
                      addItemToShopList(newValue!);
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
                  // check if all fields are filled
                  if (supplierNameController.text.isEmpty ||
                      supplierAddressController.text.isEmpty ||
                      supplierTelController.text.isEmpty ||
                      shops.isEmpty) {
                    Helpers.snackBarPrinter(
                      "Failed!",
                      "Please fill all fields.",
                      error: true,
                    );
                    return;
                  } else {
                    Supplier supplier = Supplier(
                      name: supplierNameController.text,
                      address: supplierAddressController.text,
                      tel: supplierTelController.text,
                      shops: shops,
                      items: items,
                    );

                    bool result = await widget.submit(supplier);

                    if (result) {
                      // clear fields
                      supplierNameController.clear();
                      supplierAddressController.clear();
                      supplierTelController.clear();
                      itemController.clear();
                      shopSelectedValue = "Select a shop";
                      shops = [];
                      items.clear();
                      items = [];

                      setState(() {});
                    }
                  }
                },
                text: "Submit",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
