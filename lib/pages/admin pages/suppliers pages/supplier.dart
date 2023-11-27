import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/add_supplier_container.dart';
import 'package:pastry_shop_pos/pages/admin%20pages/suppliers%20pages/suppliers_container.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  String dateInput = "";

  var items = [
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
  ];

  var prices = [
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
  ];

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
    List<DataRow> rows = [];
    int count = 0;
    for (var i in items) {
      String item = i["item"].toString();
      String qty = i["qty"].toString();
      String sold = i["sold"].toString();
      String salePrice = prices[count]["sale price"].toString();
      String purchasePrice = prices[count]["purchasePrice"].toString();

      count++;

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(item)),
            DataCell(Text(qty)),
            DataCell(Text(sold)),
            DataCell(Text(salePrice)),
            DataCell(Text(purchasePrice)),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Supplier 1',
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
              horizontal: 0,
            ),
            containerColor: const Color(0xFFCDE8FF),
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'Item Name',
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
                    'Sold',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sale Price',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Purchase Price',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: rows,
            ),
          ),
        ],
      ),
    );
  }
}
