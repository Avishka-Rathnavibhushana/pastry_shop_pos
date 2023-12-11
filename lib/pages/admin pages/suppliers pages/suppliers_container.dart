import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/models/Supplier.dart';

class SuppliersContainer extends StatefulWidget {
  SuppliersContainer(
      {super.key, required this.onPressed, required this.suppliers});

  final void Function(String id) onPressed;
  List<Supplier> suppliers;

  @override
  State<SuppliersContainer> createState() => _SuppliersContainerState();
}

class _SuppliersContainerState extends State<SuppliersContainer> {
  List<DataRow> rows = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rows = [];

    widget.suppliers.forEach((Supplier supplier) {
      String name = supplier.name.toString();
      String address = supplier.address.toString();
      String tel = supplier.tel.toString();
      String shop = supplier.shop.toString();

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
                  widget.onPressed(name);
                },
                isIcon: true,
                isText: false,
                icon: const Icon(
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
        const Align(
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
