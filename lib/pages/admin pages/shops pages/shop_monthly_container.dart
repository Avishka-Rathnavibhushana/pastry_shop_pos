import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/components/custom_button.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';
import 'package:pastry_shop_pos/components/custom_dropdown.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/pages/loadingPage.dart';

class ShopMonthlyContainerPage extends StatefulWidget {
  const ShopMonthlyContainerPage({super.key});

  @override
  State<ShopMonthlyContainerPage> createState() =>
      _ShopMonthlyContainerPageState();
}

class _ShopMonthlyContainerPageState extends State<ShopMonthlyContainerPage> {
  List<String> yearList = Constants.YEARS;

  String month = Constants.MONTHS.keys.toList()[0];
  String year = Constants.YEARS[0];

  AuthController authController = Get.find<AuthController>();

  double totalsale = 0.0;
  double totalpurchase = 0.0;
  double totalcheap = 0.0;

  Map<String, Map<String, Map<String, double>>> shopSales = {};

  ScrollController scrollController = ScrollController();

  List<DropdownMenuItem<String>> shopDropdownItems = [];
  String shopSelectedValue = "Select a shop";

  Future<void> _populateDropdownItems() async {
    List<List<String>> rolesAndShops = await authController.loadRolesAndShops();
    List<String> shops = rolesAndShops[1];

    List<DropdownMenuItem<String>> shopDropdownItemsData = [];

    for (int i = 0; i < shops.length; i++) {
      shopDropdownItemsData.add(
        DropdownMenuItem(
          value: shops[i],
          child: Text(shops[i]),
        ),
      );
    }

    shopDropdownItems.addAll(
      [
        const DropdownMenuItem(
            value: "Select a shop", child: Text("Select a shop")),
        ...shopDropdownItemsData,
      ],
    );
    setState(() {});
  }

  Future<void> loadMonthlySummaryReport(
    String shopName,
    String year,
    String month,
  ) async {
    authController.loading.value = true;

    // load monthly summary report from database
    if (shopName == "Select a shop") {
      Helpers.snackBarPrinter("Select a shop", "Select a shop to view report");
      return;
    }
    try {
      SupplierItemController supplierItemController =
          Get.find<SupplierItemController>();
      Map<String, Map<String, Map<String, double>>> shopSalesLocal =
          await supplierItemController.getMonthlySummaryByShop2(
              shopName, year, month);
      setState(() {
        shopSales = shopSalesLocal;
      });
    } catch (e) {
      Helpers.snackBarPrinter("Error", "Error loading monthly summary report",
          error: true);
      print(e);
    } finally {
      authController.loading.value = false;
    }
    calculateTotal();
    setState(() {});
    authController.loading.value = false;
  }

  void calculateTotal() {
    totalsale = 0.0;
    totalpurchase = 0.0;
    totalcheap = 0.0;

    shopSales.forEach((key, value) {
      totalsale += value["Morning"]!["Sale"]!;
      totalpurchase += value["Morning"]!["Purchase"]!;
      totalcheap += value["Morning"]!["Cheap"]!;

      totalsale += value["Evening"]!["Sale"]!;
      totalpurchase += value["Evening"]!["Purchase"]!;
      totalcheap += value["Evening"]!["Cheap"]!;
    });
  }

  @override
  void initState() {
    super.initState();
    // authController.loading.value = true;
    _populateDropdownItems();

    calculateTotal();
    setState(() {});
  }

  TextStyle tableColumnHeaderStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  @override
  void dispose() {
    authController.loading.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> itemListWidget = [];

    shopSales.forEach((key, value) {
      String day = key.split("-")[2];

      itemListWidget.add(
        DataRow(cells: [
          DataCell(Text(day)),
          DataCell(Text("Morning")),
          DataCell(Text(value["Morning"]!["Sale"]!.toStringAsFixed(2))),
          DataCell(Text(value["Morning"]!["Purchase"]!.toStringAsFixed(2))),
          DataCell(Text(value["Morning"]!["Cheap"]!.toStringAsFixed(2))),
        ]),
      );

      itemListWidget.add(
        DataRow(cells: [
          DataCell(Text("")),
          DataCell(Text("Evening")),
          DataCell(Text(value["Evening"]!["Sale"]!.toStringAsFixed(2))),
          DataCell(Text(value["Evening"]!["Purchase"]!.toStringAsFixed(2))),
          DataCell(Text(value["Evening"]!["Cheap"]!.toStringAsFixed(2))),
        ]),
      );
    });

    return Obx(() => authController.loading.value
        ? LoadingPage(
            loading: authController.loading.value,
          )
        : Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    shopSelectedValue == "Select a shop"
                        ? "Monthly Summary Report"
                        : "$shopSelectedValue Monthly Summary Report",
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
                Container(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: CustomDropdown(
                      dropdownItems: shopDropdownItems,
                      selectedValue: shopSelectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          shopSelectedValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: CustomDropdown(
                      dropdownItems: yearList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      selectedValue: year,
                      onChanged: (String? newValue) {
                        setState(() {
                          year = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: CustomDropdown(
                      dropdownItems: Constants.MONTHS.keys
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      selectedValue: month,
                      onChanged: (String? newValue) {
                        setState(() {
                          month = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: () async {
                    authController.loading.value = true;
                    await loadMonthlySummaryReport(
                      shopSelectedValue,
                      year,
                      month,
                    );
                    authController.loading.value = false;
                  },
                  text: "Submit",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  outerPadding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  innerPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  containerColor: const Color(0xFF8EB6D9),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DataTable(
                            columns: [
                              DataColumn(
                                label:
                                    Text('Day', style: tableColumnHeaderStyle),
                              ),
                              DataColumn(
                                label:
                                    Text('Time', style: tableColumnHeaderStyle),
                              ),
                              DataColumn(
                                label:
                                    Text('Sale', style: tableColumnHeaderStyle),
                              ),
                              DataColumn(
                                label: Text('Purchase',
                                    style: tableColumnHeaderStyle),
                              ),
                              DataColumn(
                                label: Text('Cheap',
                                    style: tableColumnHeaderStyle),
                              ),
                            ],
                            rows: [
                              ...itemListWidget,
                              DataRow(cells: [
                                DataCell(Text(
                                  "Total",
                                  style: tableColumnHeaderStyle,
                                )),
                                DataCell(Text(
                                  "",
                                  style: tableColumnHeaderStyle,
                                )),
                                DataCell(Text(
                                  totalsale.toPrecision(2).toString(),
                                  style: tableColumnHeaderStyle,
                                )),
                                DataCell(Text(
                                  totalpurchase.toPrecision(2).toString(),
                                  style: tableColumnHeaderStyle,
                                )),
                                DataCell(Text(
                                  totalcheap.toPrecision(2).toString(),
                                  style: tableColumnHeaderStyle,
                                )),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
  }
}
