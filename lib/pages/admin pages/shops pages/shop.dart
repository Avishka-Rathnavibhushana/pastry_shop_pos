import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/add_supplier_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/suppliers_container.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String dateInput = "";

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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> supplierContainerListWidget = [];

    data.forEach((key, value) {
      List<DataRow> itemListWidget = [];
      for (var itemData in value) {
        String item = itemData["item"].toString();
        String qty = itemData["qty"].toString();
        String sold = itemData["sold"].toString();
        String balance = (0).toString();
        String sale_price = (150).toString();
        String sale_price_total = (150 * 10).toString();
        String purchase_price = (200).toString();
        String purchase_price_total = (200 * 10).toString();
        String cheap = (200).toString();

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(Text(balance)),
            DataCell(Text(sale_price)),
            DataCell(Text(sale_price_total)),
            DataCell(Text(purchase_price)),
            DataCell(Text(purchase_price_total)),
            DataCell(Text(cheap)),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
                      'Balance',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sale\nPrice',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sale Price\nTotal',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purchase\nPrice',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purchase Price\nTotal',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'CHEAP',
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
        ),
      );

      supplierContainerListWidget.add(itemWidget);
    });

    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Shop 1 Summary',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateInput,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              CustomButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateInput =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
                text: 'Select Date',
                padding: 0,
                styleFormPadding: 10,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CustomContainer(
            outerPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            innerPadding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            containerColor: const Color(0xFFCDE8FF),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Price :',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '4720',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Paid :',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '3810',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CHEAP :',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '930',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Suppliers Summary',
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
          ...supplierContainerListWidget,
        ],
      ),
    );
  }
}
