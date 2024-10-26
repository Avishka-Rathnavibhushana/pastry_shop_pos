import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/models/user.dart';

// ignore: must_be_immutable
class AccountantsContainer extends StatelessWidget {
  const AccountantsContainer(
      {super.key, required this.onPressed, required this.users});

  final void Function(String id) onPressed;
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];

    users.forEach((User user) {
      String name = user.username;
      String address = user.address.toString();
      String tel = user.tel.toString();

      String shop = user.shop ?? "";

      rows.add(
        DataRow(
          cells: [
            DataCell(Text(name)),
            DataCell(Text(address)),
            DataCell(Text(tel)),
            DataCell(Text(shop)),
            // DataCell(
            //   CustomButton(
            //     onPressed: () {
            //       onPressed(name);
            //     },
            //     isIcon: true,
            //     isText: false,
            //     icon: const Icon(
            //       Icons.description,
            //       color: Colors.white,
            //     ),
            //     fontSize: 12,
            //     padding: 0,
            //     styleFormPadding: 0,
            //   ),
            // ),
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
            'Accountants',
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
          child: SingleChildScrollView(
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
                    'Shop',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // DataColumn(
                //   label: Text(
                //     '',
                //     style: TextStyle(
                //       fontSize: 17,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
              rows: rows,
            ),
          ),
        ),
      ],
    );
  }
}
