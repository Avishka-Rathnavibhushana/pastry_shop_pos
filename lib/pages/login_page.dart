import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';

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
      DropdownMenuItem(child: Text("Select a role"), value: "Select a role"),
      DropdownMenuItem(child: Text("Admin"), value: "Admin"),
      DropdownMenuItem(child: Text("Cashier"), value: "Cashier"),
    ]);

    shopDropdownItems.addAll(
      [
        DropdownMenuItem(child: Text("Select a shop"), value: "Select a shop"),
        DropdownMenuItem(child: Text("Shop 1"), value: "Shop 1"),
        DropdownMenuItem(child: Text("Shop 2"), value: "Shop 2"),
        DropdownMenuItem(child: Text("Shop 3"), value: "Shop 3"),
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

  void _addNewItem() {
    // Add a new item to the dropdown list
    if (roleSelectedValue == "Admin") {
      setState(() {
        shopDropdownItems.insert(
          1,
          DropdownMenuItem(child: Text("Admin Panel"), value: "Admin Panel"),
        );
      });
    }
    // Rebuild the widget to reflect the changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double verticlePadding = (height * 0.5) / 2;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFCDE8FF),
          elevation: 18,
          shadowColor: Color(0xFF000000),
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
                      Text(
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
                            _addNewItem();
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
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1B78C4),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
