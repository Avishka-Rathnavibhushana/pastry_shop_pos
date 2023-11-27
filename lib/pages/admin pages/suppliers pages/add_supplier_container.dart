import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class AddSupplierContainer extends StatefulWidget {
  const AddSupplierContainer({super.key});

  @override
  State<AddSupplierContainer> createState() => _AddSupplierContainerState();
}

class _AddSupplierContainerState extends State<AddSupplierContainer> {
  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String? shopSelectedValue = "Select a shop";

  void _populateDropdownItems() {
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
            'Add Supplier',
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
                child: SizedBox(
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
                child: SizedBox(
                  width: 300,
                  child: CustomTextField(
                    controller: TextEditingController(),
                    labelText: 'Supplier Tel.',
                    hintText: 'Enter Supplier Telephone number',
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
