import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/shop.dart';
import 'package:pastry_shop_pos/models/user.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class AddShopContainer extends StatefulWidget {
  const AddShopContainer({super.key, required this.submit});

  final Future<bool> Function(
    Shop shop,
    User user,
  ) submit;

  @override
  State<AddShopContainer> createState() => _AddShopContainerState();
}

class _AddShopContainerState extends State<AddShopContainer> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();
  TextEditingController shopTelController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Add Shop',
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
                    controller: shopNameController,
                    labelText: 'Shop name',
                    hintText: 'Enter Shop Name',
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
                    controller: shopAddressController,
                    labelText: 'Shop Address',
                    hintText: 'Enter Shop Address',
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
                    controller: shopTelController,
                    labelText: 'Shop Tel.',
                    hintText: 'Enter Shop Telephone number',
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
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  // check if all fields are filled
                  if (shopNameController.text.isEmpty ||
                      shopAddressController.text.isEmpty ||
                      shopTelController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    Helpers.snackBarPrinter(
                      "Failed!",
                      "Please fill all fields.",
                      error: true,
                    );
                    return;
                  } else {
                    Shop shop = Shop(
                      name: shopNameController.text,
                      address: shopAddressController.text,
                      tel: shopTelController.text,
                      suppliers: [],
                      extra: {},
                    );

                    User user = User(
                      username: shopNameController.text,
                      address: shopAddressController.text,
                      tel: shopTelController.text,
                      password:
                          Helpers.encryptPassword(passwordController.text),
                      role: Constants.Cashier,
                      shop: shopNameController.text,
                    );

                    bool result = await widget.submit(shop, user);

                    if (result) {
                      // clear fields
                      shopNameController.clear();
                      shopAddressController.clear();
                      shopTelController.clear();
                      passwordController.clear();

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
