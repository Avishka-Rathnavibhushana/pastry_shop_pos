import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';

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
        "item": "පාන්",
        "qty": 12,
        "sold": 12,
      },
      {
        "item": "තැටි පාන්",
        "qty": 7,
        "sold": 7,
      },
      {
        "item": "රෝස් පාන්",
        "qty": 10,
        "sold": 10,
      },
      {
        "item": "බිත්තර බන්",
        "qty": 3,
        "sold": 1,
      },
      {
        "item": "ජෑම් පාන්",
        "qty": 3,
        "sold": 2,
      },
    ],
    "supplier 2": [
      {
        "item": "රෝස් පාන්",
        "qty": 10,
        "sold": 10,
      },
      {
        "item": "බිත්තර බන්",
        "qty": 3,
        "sold": 1,
      },
      {
        "item": "ජෑම් පාන්",
        "qty": 3,
        "sold": 2,
      },
    ],
    "supplier 3": [
      {
        "item": "පාන්",
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
            "item": "පාන්",
            "sale price": 140,
            "purchasePrice": 115,
          },
          {
            "item": "තැටි පාන්",
            "sale price": 120,
            "purchasePrice": 100,
          },
          {
            "item": "රෝස් පාන්",
            "sale price": 40,
            "purchasePrice": 30,
          },
          {
            "item": "බිත්තර බන්",
            "sale price": 60,
            "purchasePrice": 40,
          },
          {
            "item": "ජෑම් පාන්",
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
            "item": "රෝස් පාන්",
            "sale price": 40,
            "purchasePrice": 30,
          },
          {
            "item": "බිත්තර බන්",
            "sale price": 60,
            "purchasePrice": 40,
          },
          {
            "item": "ජෑම් පාන්",
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
            "item": "පාන්",
            "sale price": 140,
            "purchasePrice": 115,
          },
        ],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      dateInput = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

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
        String salePrice = (150).toString();
        String salePriceTotal = (150 * 10).toString();
        String purchasePrice = (200).toString();
        String purchasePriceTotal = (200 * 10).toString();
        String cheap = (200).toString();

        itemListWidget.add(
          DataRow(cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(Text(balance)),
            DataCell(Text(salePrice)),
            DataCell(Text(salePriceTotal)),
            DataCell(Text(purchasePrice)),
            DataCell(Text(purchasePriceTotal)),
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
                columns: [
                  DataColumn(
                    label: Text('ITEM', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('QTY', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('SOLD', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Balance', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Sale\nPrice', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Sale Price\nTotal',
                        style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label:
                        Text('Purchase\nPrice', style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('Purchase Price\nTotal',
                        style: tableColumnHeaderStyle),
                  ),
                  DataColumn(
                    label: Text('CHEAP', style: tableColumnHeaderStyle),
                  ),
                ],
                rows: [
                  ...itemListWidget,
                  DataRow(cells: [
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "10",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "8",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "2",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "6700",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "4500",
                      style: tableColumnHeaderStyle,
                    )),
                    DataCell(Text(
                      "2200",
                      style: tableColumnHeaderStyle,
                    )),
                  ]),
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
          const Align(
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
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateInput,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
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
                    //formatted date output using intl package =>  2021-03-16
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
          const SizedBox(
            height: 20,
          ),
          const CustomContainer(
            outerPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            innerPadding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            containerColor: Color(0xFFCDE8FF),
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
          const SizedBox(
            height: 10,
          ),
          const Align(
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
          const SizedBox(
            height: 10,
          ),
          ...supplierContainerListWidget,
        ],
      ),
    );
  }
}
