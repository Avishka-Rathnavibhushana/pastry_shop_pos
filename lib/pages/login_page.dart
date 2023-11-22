import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/chashier_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<DropdownMenuItem<String>> roleDropdownItems = [];
  String? roleSelectedValue = "Select a role";

  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";

  void _populateDropdownItems() {
    roleDropdownItems.addAll([
      const DropdownMenuItem(
          value: "Select a role", child: Text("Select a role")),
      const DropdownMenuItem(value: "Admin", child: Text("Admin")),
      const DropdownMenuItem(value: "Cashier", child: Text("Cashier")),
    ]);

    shopDropdownItems.addAll(
      [
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        const DropdownMenuItem(value: "Shop 1", child: Text("Shop 1")),
        const DropdownMenuItem(value: "Shop 2", child: Text("Shop 2")),
        const DropdownMenuItem(value: "Shop 3", child: Text("Shop 3")),
      ],
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Populate the initial dropdown items
    _populateDropdownItems();
  }

  void _addOrRemoveAdminPanelItem() {
    // Add a new item to the dropdown list
    setState(() {
      shopDropdownItems = [];
    });
    if (roleSelectedValue == "Admin") {
      shopDropdownItems.addAll([
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        const DropdownMenuItem(
            value: "Admin Panel", child: Text("Admin Panel")),
      ]);
    } else {
      shopDropdownItems.addAll([
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        const DropdownMenuItem(value: "Shop 1", child: Text("Shop 1")),
        const DropdownMenuItem(value: "Shop 2", child: Text("Shop 2")),
        const DropdownMenuItem(value: "Shop 3", child: Text("Shop 3")),
      ]);
    }

    shopSelectedValue = "Select a shop";

    // Rebuild the widget to reflect the changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double verticlePadding = (height * 0.5) / 2;

    return SafeArea(
      child: CustomContainer(
        outerPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        innerPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 0,
        ),
        containerColor: const Color(0xFFCDE8FF),
        child: Container(
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   color: Color(0x542582CE),
          //   borderRadius: BorderRadius.circular(10),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ],
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Pastry Shop POS',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: VerticalDivider(
                  color: Colors.black38,
                  thickness: 2,
                  indent: verticlePadding,
                  endIndent: verticlePadding,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: CustomTextField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'Enter Your Name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: CustomTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: CustomDropdown(
                        dropdownItems: roleDropdownItems,
                        selectedValue: roleSelectedValue!,
                        onChanged: (String? newValue) {
                          setState(() {
                            roleSelectedValue = newValue;
                          });
                          _addOrRemoveAdminPanelItem();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => CashierHomePage(
                              shopName: shopSelectedValue,
                            ),
                          ),
                        );
                      },
                      text: "Sign in",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
