import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/controllers/accountant_controller.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/user.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/accountant%20pages/accountants_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/accountant%20pages/add_accountant_container.dart';

class AccountantsPage extends StatefulWidget {
  const AccountantsPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  State<AccountantsPage> createState() => _AccountantsPageState();
}

class _AccountantsPageState extends State<AccountantsPage> {
  Future<bool> submitAccountant(
    User user,
  ) async {
    // check if user exists
    AuthController authController = Get.find<AuthController>();
    User? retrievedUser = await authController.getUserById(user.username);
    bool result = false;

    if (retrievedUser != null) {
      Helpers.snackBarPrinter("Failed", "User already exists");
      return false;
    }

    bool resultUser =
        await authController.createUserWithId(user.username, user);
    result = resultUser;
    await loadData();

    return result;
  }

  List<User> users = [];

  Future<void> loadData() async {
    // load suppliers from database
    AccountantController accountantController =
        Get.find<AccountantController>();
    List<User> accountantList = await accountantController.getAccountantsList();

    setState(() {
      users = accountantList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AddAccountantContainer(submit: submitAccountant),
          const SizedBox(
            height: 20,
          ),
          AccountantsContainer(
            onPressed: widget.onPressed,
            users: users,
          ),
        ],
      ),
    );
  }
}
