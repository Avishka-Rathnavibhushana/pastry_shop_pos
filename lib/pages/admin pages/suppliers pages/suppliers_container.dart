import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/models/supplier.dart';

class SuppliersContainer extends StatelessWidget {
  const SuppliersContainer(
      {super.key,
      required this.onPressed,
      required this.suppliers,
      required this.deleteSupplier});

  final void Function(String id) onPressed;
  final void Function(String id) deleteSupplier;
  final Map<String, List<Supplier>> suppliers;

  @override
  Widget build(BuildContext context) {
    List<Widget> shopSuppliers = [];

    suppliers.forEach((key, value) {
      List<DataRow> rows = [];

      value.forEach((Supplier supplier) {
        String name = supplier.name.toString();
        String address = supplier.address.toString();
        String tel = supplier.tel.toString();

        List<String> shopList = [];
        if (supplier.shops != null) {
          shopList = supplier.shops as List<String>;
        }
        String suppliers = "[ ${shopList.join(" ,")} ]";

        rows.add(
          DataRow(
            cells: [
              DataCell(Text(name)),
              DataCell(Text(address)),
              DataCell(Text(tel)),
              DataCell(Text(suppliers)),
              DataCell(
                CustomButton(
                  onPressed: () {
                    onPressed(name);
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
              DataCell(
                CustomButton(
                  onPressed: () {
                    deleteSupplier(name);
                  },
                  isIcon: true,
                  isText: false,
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xFFEB7169),
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

      Widget shopSupplierWidget = CustomContainer(
          outerPadding: const EdgeInsets.symmetric(
          vertical: 20,
            horizontal: 0,
          ),
          innerPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 0,
          ),
          containerColor: const Color(0xFFCDE8FF),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Text(
                key,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DataTable(
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
                      'Preview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ],
          ),
        ),
      );

      shopSuppliers.add(shopSupplierWidget);
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
        ...shopSuppliers,
      ],
    );
  }
}
