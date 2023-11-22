import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/components/user_page_layout.dart';

// ignore: must_be_immutable
class CashierHomePage extends StatelessWidget {
  CashierHomePage({
    super.key,
    required this.shopName,
  });

  final String? shopName;

  var data = {
    "supplier 1": [
      {
        "item": "paan",
        "qty": 12,
        "sold": 12,
      },
      {
        "item": "thati paan",
        "qty": 7,
        "sold": 7,
      },
      {
        "item": "rose paan",
        "qty": 10,
        "sold": 10,
      },
      {
        "item": "biththara bun",
        "qty": 3,
        "sold": 1,
      },
      {
        "item": "jaam paan",
        "qty": 3,
        "sold": 2,
      },
    ],
    "supplier 2": [
      {
        "item": "rose paan",
        "qty": 10,
        "sold": 10,
      },
      {
        "item": "biththara bun",
        "qty": 3,
        "sold": 1,
      },
      {
        "item": "jaam paan",
        "qty": 3,
        "sold": 2,
      },
    ],
    "supplier 3": [
      {
        "item": "paan",
        "qty": 12,
        "sold": 12,
      },
    ],
  };

  var supplierData = {
    "supplier 1": [
      {
        "2023-11-17": [
          {
            "item": "paan",
            "sale price": 140,
            "purchasePrice": 115,
          },
          {
            "item": "thati paan",
            "sale price": 120,
            "purchasePrice": 100,
          },
          {
            "item": "rose paan",
            "sale price": 40,
            "purchasePrice": 30,
          },
          {
            "item": "biththara bun",
            "sale price": 60,
            "purchasePrice": 40,
          },
          {
            "item": "jaam paan",
            "sale price": 60,
            "purchasePrice": 40,
          },
        ],
      },
    ],
    "supplier 2": [
      {
        "2023-11-17": [
          {
            "item": "rose paan",
            "sale price": 40,
            "purchasePrice": 30,
          },
          {
            "item": "biththara bun",
            "sale price": 60,
            "purchasePrice": 40,
          },
          {
            "item": "jaam paan",
            "sale price": 60,
            "purchasePrice": 40,
          },
        ],
      },
    ],
    "supplier 3": [
      {
        "2023-11-17": [
          {
            "item": "paan",
            "sale price": 140,
            "purchasePrice": 115,
          },
        ],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    data.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      for (var itemData in value) {
        String item = itemData["item"].toString();
        String qty = itemData["qty"].toString();
        String sold = itemData["sold"].toString();

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 30,
                    child: CustomTextField(
                      controller: TextEditingController(),
                      labelText: '',
                      hintText: '',
                      fontSize: 12,
                      maxLength: 3,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                    onPressed: () {},
                    text: "Submit",
                    fontSize: 12,
                    padding: 0,
                    styleFormPadding: 0,
                  ),
                ],
              ),
            ),
          ]),
        );
      }
      Widget itemWidget = CustomContainer(
        outerPadding: const EdgeInsets.only(
          bottom: 20,
        ),
        innerPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        containerColor: const Color(0xFF8EB6D9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              key,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'ITEM',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'QTY',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SOLD',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SOLD AMOUNT',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: [
                ...itemListWidget,
              ],
            ),
          ],
        ),
      );

      supplierContainerListWidget.add(itemWidget);
    });

    return Container(
      alignment: Alignment.center,
      child: UserPageLayout(
        pageWidgets: [
          ...supplierContainerListWidget,
        ],
        shopName: shopName,
      ),
    );
  }
}
