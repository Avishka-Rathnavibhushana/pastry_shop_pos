import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/shop_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/shop.dart';
import 'package:pastry_shop_pos/models/user.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops%20pages/add_shop_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/shops%20pages/shops_container.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  Future<bool> submitShop(
    Shop shop,
    User user,
  ) async {
    ShopController shopController = Get.find<ShopController>();
    bool result = false;

    // check if user exists
    AuthController authController = Get.find<AuthController>();
    User? retrievedUser = await authController.getUserById(user.username);

    if (retrievedUser != null) {
      Helpers.snackBarPrinter("Failed", "User already exists");
      return false;
    }

    bool resultShop = await shopController.createShop(shop);

    if (resultShop) {
      AuthController authController = Get.find<AuthController>();
      bool resultUser =
          await authController.createUserWithId(user.username, user);
      result = resultUser;
      await loadData();
    }

    return result;
  }

  Future<void> deleteShop(String id, BuildContext context) async {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Shop"),
      content: const Text("Are you sure you want to delete this shop?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            ShopController shopController = Get.find<ShopController>();
            bool result = await shopController.deleteShop(id);

            if (result) {
              await loadData();
            }

            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<Shop> shops = [];

  Future<void> loadData() async {
    // load suppliers from database
    ShopController shopController = Get.find<ShopController>();
    List<Shop> shopsList = await shopController.getShopsList();

    setState(() {
      shops = shopsList;
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
          AddShopContainer(submit: submitShop),
          const SizedBox(
            height: 20,
          ),
          ShopsContainer(
            onPressed: widget.onPressed,
            shops: shops,
            deleteShop: (id) {
              deleteShop(id, context);
            },
          ),
        ],
      ),
    );
  }
}
