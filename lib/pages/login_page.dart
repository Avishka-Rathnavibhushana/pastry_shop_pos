import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/models/user.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';
import 'package:pastry_shop_pos/pages/chashier_home_page.dart';
import 'package:pastry_shop_pos/pages/accountant_home_page.dart';
import 'package:pastry_shop_pos/pages/loadingPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<DropdownMenuItem<String>> roleDropdownItems = [];
  String? roleSelectedValue = "Select a role";

  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";

  AuthController authController = Get.find<AuthController>();

  Future<void> _populateDropdownItems() async {
    authController.logoutUser();

    List<List<String>> rolesAndShops = await authController.loadRolesAndShops();
    List<String> roles = rolesAndShops[0];
    List<String> shops = rolesAndShops[1];

    List<DropdownMenuItem<String>> roleDropdownItemsData = [];

    for (int i = 0; i < roles.length; i++) {
      roleDropdownItemsData.add(
        DropdownMenuItem(
          value: roles[i],
          child: Text(roles[i]),
        ),
      );
    }

    roleDropdownItems.addAll(
      [
        const DropdownMenuItem(
            value: "Select a role", child: Text("Select a role")),
        ...roleDropdownItemsData,
      ],
    );

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

  void onSignIn() async {
    authController.loading.value = true;

    try {
      await Future.delayed(Duration(seconds: 1));
      bool isSuccessful = await authController.authenticateUser(
        usernameController.text,
        passwordController.text,
        roleSelectedValue!,
        shop: shopSelectedValue,
      );

      if (!isSuccessful) {
        return;
      }

      if (roleSelectedValue == Constants.Admin) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const AdminHomePage(
              shopName: "Admin Panel",
            ),
          ),
        );
      } else if (roleSelectedValue == Constants.Cashier) {
        if (shopSelectedValue != "Select a shop") {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => CashierHomePage(
                shopName: "${shopSelectedValue!}",
              ),
            ),
          );
        }
      } else if (roleSelectedValue == Constants.Accountant) {
        if (shopSelectedValue != "Select a shop") {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AccountantHomePage(
                shopName: "${shopSelectedValue!}",
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    } finally {
      authController.loading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();

    // Populate the initial dropdown items
    _populateDropdownItems();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double padding = 0;

    Widget content = Container();

    if (width > Constants.MobileSize) {
      padding = (height * 0.5) / 2;
      content = Row(
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
              indent: padding,
              endIndent: padding,
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
                    controller: usernameController,
                    labelText: 'Username',
                    hintText: 'Enter Your Username',
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
                      // _addOrRemoveAdminPanelItem();
                    },
                  ),
                ),
                roleSelectedValue == Constants.Cashier ||
                        roleSelectedValue == Constants.Accountant
                    ? Padding(
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
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: onSignIn,
                  text: "Sign in",
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      padding = (width * 0.5) / 2;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(
                height: 20,
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
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Divider(
              color: Colors.black38,
              thickness: 2,
              indent: padding,
              endIndent: padding,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: CustomTextField(
                  controller: usernameController,
                  labelText: 'Username',
                  hintText: 'Enter Your Username',
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
                    // _addOrRemoveAdminPanelItem();
                  },
                ),
              ),
              roleSelectedValue == Constants.Cashier ||
                      roleSelectedValue == Constants.Accountant
                  ? Padding(
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
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: onSignIn,
                text: "Sign in",
              ),
            ],
          ),
        ],
      );
    }

    return SafeArea(
      child: Stack(
        children: [
          CustomContainer(
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
              child: content,
            ),
          ),
          Obx(
            () => LoadingPage(
              loading: authController.loading.value,
            ),
          ),
        ],
      ),
    );
  }
}
