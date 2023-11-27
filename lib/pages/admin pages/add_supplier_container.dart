import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class AddSupplierContainer extends StatelessWidget {
  const AddSupplierContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
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
        SizedBox(
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
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Container(
                    width: 300,
                    child: CustomTextField(
                      controller: TextEditingController(),
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
                  child: Container(
                    width: 300,
                    child: CustomTextField(
                      controller: TextEditingController(),
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
                  child: Container(
                    width: 300,
                    child: CustomTextField(
                      controller: TextEditingController(),
                      labelText: 'Supplier Tel.',
                      hintText: 'Enter Supplier Telephone number',
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
                        builder: (BuildContext context) => AdminHomePage(
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
        ),
      ],
    );
  }
}
