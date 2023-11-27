import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_text_field.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';

class SuppliersContainer extends StatelessWidget {
  SuppliersContainer({super.key, required this.onPressed});

  final void Function(String id) onPressed;

  var data = {
    "supplier 1": {
      "name": "supplier 1",
      "address": "25, dias place, panadura",
      "tel": "0723884992",
      "shop": "shop 1",
    },
    "supplier 2": {
      "name": "supplier 2",
      "address": "12, galle road, colombo",
      "tel": "0723884992",
      "shop": "shop 2",
    },
    "supplier 3": {
      "name": "supplier 3",
      "address": "25, dias place, panadura",
      "tel": "0723884992",
      "shop": "shop 1",
    },
  };

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    data.forEach((key, value) {
      String name = value["name"].toString();
      String address = value["address"].toString();
      String tel = value["tel"].toString();
      String shop = value["shop"].toString();

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(name)),
            DataCell(Text(address)),
            DataCell(Text(tel)),
            DataCell(Text(shop)),
            DataCell(
              CustomButton(
                onPressed: () {
                  onPressed(name);
                },
                isIcon: true,
                isText: false,
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                fontSize: 12,
                padding: 0,
                styleFormPadding: 0,
              ),
            ),
          ],
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Suppliers',
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
          child: DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Telephone',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  '',
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
    );
  }
}
