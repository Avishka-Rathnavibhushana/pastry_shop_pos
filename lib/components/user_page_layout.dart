import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/pages/login_page.dart';

class UserPageLayout extends StatelessWidget {
  const UserPageLayout({
    super.key,
    required this.pageWidgets,
    required this.shopName,
    this.topDividerSpace = 20,
  });

  final List<Widget> pageWidgets;
  final String? shopName;
  final double topDividerSpace;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget content = Container();

    if (width > Constants.MobileSize) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: Text(
                    'Pastry Shop POS',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            shopName!,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              AuthController authController = Get.find<AuthController>();
              authController.logoutUser(snackBar: true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      );
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(
                width: 20,
              ),
              const Expanded(
                child: Text(
                  'Pastry Shop POS',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                shopName!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  AuthController authController = Get.find<AuthController>();
                  authController.logoutUser(snackBar: true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Material(
      child: SafeArea(
        child: CustomContainer(
          outerPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          innerPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          containerColor: const Color(0xFFCDE8FF),
          child: Column(
            children: [
              content,
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              SizedBox(
                height: topDividerSpace,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...pageWidgets,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
