import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/models/shop.dart';

// ignore: must_be_immutable
class ShopsContainer extends StatelessWidget {
  ShopsContainer(
      {super.key,
      required this.onPressed,
      required this.shops,
      required this.deleteShop});

  final void Function(String id) onPressed;
  final void Function(String id) deleteShop;
  final List<Shop> shops;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    shops.forEach((Shop shop) {
      String name = shop.name.toString();
      String address = shop.address.toString();
      String tel = shop.tel.toString();
      List<String> suppliersList = [];
      if (shop.suppliers != null) {
        suppliersList = shop.suppliers as List<String>;
      }
      String suppliers = "[ ${suppliersList.join(" ,")} ]";

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
                  Icons.description,
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
                  deleteShop(name);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Shops',
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
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
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
                      'Suppliers',
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
            ),
          ),
        ),
      ],
    );
  }
}
