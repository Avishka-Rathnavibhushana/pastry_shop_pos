import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/user.dart';

class AddAccountantContainer extends StatefulWidget {
  const AddAccountantContainer({super.key, required this.submit});

  final Future<bool> Function(
    User user,
  ) submit;

  @override
  State<AddAccountantContainer> createState() => _AddAccountantContainerState();
}

class _AddAccountantContainerState extends State<AddAccountantContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";

  AuthController authController = Get.find<AuthController>();

  Future<void> _populateDropdownItems() async {
    authController.logoutUser();

    List<List<String>> rolesAndShops = await authController.loadRolesAndShops();
    List<String> shops = rolesAndShops[1];

    List<DropdownMenuItem<String>> shopDropdownItemsData = [];

    for (int i = 0; i < shops.length; i++) {
      shopDropdownItemsData.add(
        DropdownMenuItem(
          value: shops[i],
          child: Text(shops[i]),
        ),
      );
    }

    shopDropdownItems.addAll(
      [
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        ...shopDropdownItemsData,
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
            'Add Accountant',
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
                    controller: nameController,
                    labelText: 'Accountant username',
                    hintText: 'Enter Accountant username',
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
                    controller: addressController,
                    labelText: 'Accountant Address',
                    hintText: 'Enter Accountant Address',
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
                    controller: telController,
                    labelText: 'Accountant Tel.',
                    hintText: 'Enter Accountant Telephone number',
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
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    obscureText: true,
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
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  // check if all fields are filled
                  if (nameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      telController.text.isEmpty ||
                      shopSelectedValue == "Select a shop" ||
                      passwordController.text.isEmpty) {
                    Helpers.snackBarPrinter(
                      "Failed!",
                      "Please fill all fields.",
                      error: true,
                    );
                    return;
                  } else {
                    User user = User(
                      username: nameController.text,
                      address: addressController.text,
                      tel: telController.text,
                      password:
                          Helpers.encryptPassword(passwordController.text),
                      role: Constants.Accountant,
                      shop: shopSelectedValue,
                    );

                    bool result = await widget.submit(user);

                    if (result) {
                      // clear fields
                      nameController.clear();
                      addressController.clear();
                      telController.clear();
                      passwordController.clear();
                      shopSelectedValue = "Select a shop";

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
