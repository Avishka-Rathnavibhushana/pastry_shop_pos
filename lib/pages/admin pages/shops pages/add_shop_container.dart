import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class AddShopContainer extends StatefulWidget {
  const AddShopContainer({super.key});

  @override
  State<AddShopContainer> createState() => _AddShopContainerState();
}

class _AddShopContainerState extends State<AddShopContainer> {
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
                    controller: TextEditingController(),
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
                    controller: TextEditingController(),
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
                    controller: TextEditingController(),
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
                    controller: TextEditingController(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    obscureText: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AdminHomePage(
                        shopName: "shopSelectedValue",
                      ),
                    ),
                  );
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
