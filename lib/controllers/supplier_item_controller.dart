import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

class SupplierItemController extends GetxController {
  // get supplier items for a specific date like 2023-12-12
  Future<List<SupplierItem>> getSupplierItemsByShopByTime(
      String supplierId, String date, String shop, String session) async {
    try {
      // Fetch the specific item list document from the 'itemList' collection
      DocumentSnapshot itemListSnapshot = await FirebaseFirestore.instance
          .collection('supplierItems')
          .doc(supplierId)
          .collection(shop + " " + session)
          .doc(date)
          .get();

      // Check if the item list document exists
      if (itemListSnapshot.exists) {
        // Retrieve the data from the item list document
        Map<String, dynamic>? itemListData =
            itemListSnapshot.data() as Map<String, dynamic>?;

        if (itemListData != null) {
          // If the data is present, create a list of SupplierItems
          List<SupplierItem> items = [];

          itemListData["items"].forEach((item) {
            items.add(
              SupplierItem.fromMapSubset(item as Map<String, dynamic>)
                ..date = itemListData["date"],
            );
          });
          return items;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting supplier items: $e');
      return [];
    }
  }

  // add supplier item for a specific supplier and date
  Future<bool> addSupplierItem(
      String supplierId, SupplierItem supplierItem, String date) async {
    try {
      // Fetch the specific item list document from the 'itemList' collection
      DocumentSnapshot itemListSnapshot = await FirebaseFirestore.instance
          .collection('supplierItems')
          .doc(supplierId)
          .collection('itemList')
          .doc(date)
          .get();

      // Check if the item list document exists
      if (itemListSnapshot.exists) {
        // Retrieve the data from the item list document
        Map<String, dynamic>? itemListData =
            itemListSnapshot.data() as Map<String, dynamic>?;

        if (itemListData != null) {
          // If the data is present, create a list of SupplierItems
          List<SupplierItem> items = [];

          itemListData["items"].forEach((item) {
            items.add(
              SupplierItem.fromMapSubset(item as Map<String, dynamic>)
                ..date = itemListData["date"],
            );
          });

          // Check if the item already exists in the list
          bool itemExists = false;
          for (SupplierItem item in items) {
            if (item.name == supplierItem.name) {
              itemExists = true;
              break;
            }
          }

          if (itemExists) {
            // Item already exists in the list
            return false;
          } else {
            // Item doesn't exist in the list, so add it
            items.add(supplierItem);

            // Update the item list document
            await FirebaseFirestore.instance
                .collection('supplierItems')
                .doc(supplierId)
                .collection('itemList')
                .doc(supplierItem.date)
                .update({
              "items": items.map((item) => item.toMapSubset()).toList(),
            });

            return true;
          }
        } else {
          return false;
        }
      } else {
        // Item list document doesn't exist, so create it
        await FirebaseFirestore.instance
            .collection('supplierItems')
            .doc(supplierId)
            .collection('itemList')
            .doc(supplierItem.date)
            .set({
          "date": supplierItem.date,
          "items": [supplierItem.toMapSubset()],
        });

        return true;
      }
    } catch (e) {
      print('Error adding supplier item: $e');
      return false;
    }
  }

  // add a list of supplier items for a specific supplier and date
  Future<bool> addSupplierItems(
      String supplierId,
      List<SupplierItem> supplierItems,
      String date,
      String shop,
      String session) async {
    try {
      // Fetch the specific item list document from the 'itemList' collection
      DocumentSnapshot itemListSnapshot = await FirebaseFirestore.instance
          .collection('supplierItems')
          .doc(supplierId)
          .collection(shop + " " + session)
          .doc(date)
          .get();

      // Check if the item list document exists
      if (itemListSnapshot.exists) {
        // Retrieve the data from the item list document
        Map<String, dynamic>? itemListData =
            itemListSnapshot.data() as Map<String, dynamic>?;

        if (itemListData != null) {
          // If the data is present, create a list of SupplierItems
          List<SupplierItem> items = [];

          itemListData["items"].forEach((item) {
            items.add(
              SupplierItem.fromMapSubset(item as Map<String, dynamic>)
                ..date = itemListData["date"],
            );
          });

          // Check if the items already exist in the list
          bool itemsNotExist = true;
          List<SupplierItem> itemsNonExisting = [];
          for (SupplierItem supplierItem in supplierItems) {
            itemsNotExist = true;
            for (SupplierItem item in items) {
              if (item.name == supplierItem.name) {
                itemsNotExist = false;
                break;
              }
            }
            if (itemsNotExist) {
              itemsNonExisting.add(supplierItem);
            }
          }

          if (itemsNonExisting.length == 0) {
            // Items already exist in the list
            return false;
          } else {
            // Items don't exist in the list, so add them
            items.addAll(itemsNonExisting);

            // Update the item list document
            await FirebaseFirestore.instance
                .collection('supplierItems')
                .doc(supplierId)
                .collection(shop + " " + session)
                .doc(date)
                .update({
              "items": items.map((item) => item.toMapSubset()).toList(),
            });

            return true;
          }
        } else {
          return false;
        }
      } else {
        // Item list document doesn't exist, so create it
        await FirebaseFirestore.instance
            .collection('supplierItems')
            .doc(supplierId)
            .collection(shop + " " + session)
            .doc(date)
            .set({
          "date": date,
          "items": supplierItems.map((item) => item.toMapSubset()).toList(),
        });

        return true;
      }
    } catch (e) {
      print('Error adding supplier items: $e');
      return false;
    }
  }

  // get items from supplier and add to supplier item
  Future<bool> getItemsFromSupplierAndAddToSupplierItem(
      String supplierId, String date, String shop, String session) async {
    try {
      // fetch items from the supplier
      SupplierController supplierController = Get.find<SupplierController>();
      Supplier? supplier = await supplierController.getSupplierById(supplierId);

      List<SupplierItem> supplierItemsPreviousDay = [];

      //if previous date's prices are available up to 30 days, load them from supplierItem and add to today supplierItem
      for (int i = 1; i < 31; i++) {
        DateTime dateTime = DateTime.parse(date);
        DateTime previousDate = dateTime.subtract(Duration(days: i));
        String previousDateStr = previousDate.toString().split(" ")[0];

        supplierItemsPreviousDay = await getSupplierItemsByShopByTime(
          supplierId,
          previousDateStr,
          shop,
          session,
        );

        if (supplierItemsPreviousDay.length > 0) {
          break;
        }
      }

      if (supplier != null) {
        // create a list of supplier items
        List<SupplierItem> supplierItems = [];
        supplier.items.forEach((item) {
          double salePrice = 0;
          double purchasePrice = 0;
          bool previousDayActivation = true;
          bool previousDayUpdateQty = false;
          if (supplierItemsPreviousDay.length > 0) {
            if (supplierItemsPreviousDay
                .where((element) => element.name == item)
                .isEmpty) {
              salePrice = 0;
              purchasePrice = 0;
              previousDayActivation = true;
              previousDayUpdateQty = false;
            } else {
              SupplierItem element = supplierItemsPreviousDay
                  .firstWhere((element) => element.name == item);
              salePrice = element.salePrice;
              purchasePrice = element.purchasePrice;

              previousDayActivation = element.activated!;
              previousDayUpdateQty = element.updateQty!;
            }
          }
          supplierItems.add(
            SupplierItem(
              name: item,
              qty: 0,
              sold: 0,
              salePrice: salePrice,
              purchasePrice: purchasePrice,
              date: date,
              activated: previousDayActivation,
              updateQty: previousDayUpdateQty,
            ),
          );
        });

        // add the supplier items to the supplier item list
        bool result = await addSupplierItems(
            supplierId, supplierItems, date, shop, session);

        return result;
      } else {
        return false;
      }
    } catch (e) {
      print(
          'Error getting items from supplier and adding to supplier item: $e');
      return false;
    }
  }

  // Update item in supplier item for a specific date to add items from previous session
  Future<bool> updateSuppllierItemsOfaShopWithPreviousSessionRemQty(
      String supplierId, String date, String shop, String session) async {
    try {
      String currentSession = session;
      String currentDate = date;
      // fetch items from the supplier item
      List<SupplierItem> supplierItemsFromSupplierItem =
          await getSupplierItemsByShopByTime(
              supplierId, date, shop, currentSession);

      // fetch items from the supplieritems of previous session
      List<SupplierItem> supplierItemsFromSupplierItemPreviousSession = [];

      if (currentSession == Constants.Sessions[0]) {
        date = DateTime.parse(date)
            .subtract(Duration(days: 1))
            .toString()
            .split(" ")[0];
        session = Constants.Sessions[1];
        supplierItemsFromSupplierItemPreviousSession =
            await getSupplierItemsByShopByTime(supplierId, date, shop, session);
      } else {
        session = Constants.Sessions[0];
        supplierItemsFromSupplierItemPreviousSession =
            await getSupplierItemsByShopByTime(supplierId, date, shop, session);
      }

      // loop in supplierItemsFromSupplierItem list and update the qty of the items from previous session
      for (int i = 0; i < supplierItemsFromSupplierItem.length; i++) {
        SupplierItem supplierItem = supplierItemsFromSupplierItem[i];
        // qty should be updated only if the item is available in the previous session
        if (supplierItemsFromSupplierItemPreviousSession
            .where((element) => element.name == supplierItem.name)
            .isEmpty) {
          continue;
        }

        // qty should be updated only if the UpdateQty is true
        if (!supplierItem.updateQty!) {
          continue;
        }

        SupplierItem supplierItemPreviousSession =
            supplierItemsFromSupplierItemPreviousSession
                .firstWhere((element) => element.name == supplierItem.name);

        supplierItem.qty = (supplierItemPreviousSession.qty -
                supplierItemPreviousSession.sold) +
            supplierItem.qty;

        // update thedatabase in item in the supplier item
        await updateItemInSupplierItem(
            supplierId, supplierItem, currentDate, shop, currentSession,
            printSnack: false);
      }

      Helpers.snackBarPrinter("Successful!",
          "Successfully updated the supplier items with previous session.");

      return true;
    } catch (e) {
      print(
          'Error getting items from supplier and adding to supplier item: $e');

      Helpers.snackBarPrinter(
          "Failed!", "Something is Wrong. Please try again.",
          error: true);

      return false;
    }
  }

  // check whether item list in supplier is equal to item list in supplier item
  Future<bool> isItemsEqual(
      String supplierId, String date, String shop, String session) async {
    try {
      // fetch items from the supplier
      SupplierController supplierController = Get.find<SupplierController>();
      Supplier? supplier = await supplierController.getSupplierById(supplierId);

      if (supplier != null) {
        // create a list of supplier items
        List<SupplierItem> supplierItems = [];
        supplier.items.forEach((item) {
          supplierItems.add(
            SupplierItem(
              name: item,
              qty: 0,
              sold: 0,
              salePrice: 0,
              purchasePrice: 0,
              date: date,
              activated: true,
            ),
          );
        });

        // fetch items from the supplier item
        List<SupplierItem> supplierItemsFromSupplierItem =
            await getSupplierItemsByShopByTime(supplierId, date, shop, session);

        // check whether the two lists are equal
        if (supplierItems.length == supplierItemsFromSupplierItem.length) {
          // for (int i = 0; i < supplierItems.length; i++) {
          //   if (supplierItems[i].name !=
          //       supplierItemsFromSupplierItem[i].name) {
          //     return false;
          //   }
          // }
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking whether items are equal: $e');
      return false;
    }
  }

  // update item in supplier item for a specific date
  Future<bool> updateItemInSupplierItem(String supplierId,
      SupplierItem supplierItem, String date, String shop, String session,
      {bool printSnack = true}) async {
    try {
      // Fetch the specific item list document from the 'itemList' collection
      DocumentSnapshot itemListSnapshot = await FirebaseFirestore.instance
          .collection('supplierItems')
          .doc(supplierId)
          .collection(shop + " " + session)
          .doc(date)
          .get();

      // Check if the item list document exists
      if (itemListSnapshot.exists) {
        // Retrieve the data from the item list document
        Map<String, dynamic>? itemListData =
            itemListSnapshot.data() as Map<String, dynamic>?;

        if (itemListData != null) {
          // If the data is present, create a list of SupplierItems
          List<SupplierItem> items = [];

          itemListData["items"].forEach((item) {
            items.add(
              SupplierItem.fromMapSubset(item as Map<String, dynamic>)
                ..date = itemListData["date"],
            );
          });

          // Check if the item already exists in the list
          bool itemExists = false;
          int index = 0;
          for (SupplierItem item in items) {
            if (item.name == supplierItem.name) {
              itemExists = true;
              break;
            }
            index++;
          }

          if (itemExists) {
            // Item already exists in the list, so update it
            items[index] = supplierItem;

            // Update the item list document
            await FirebaseFirestore.instance
                .collection('supplierItems')
                .doc(supplierId)
                .collection(shop + " " + session)
                .doc(supplierItem.date)
                .update({
              "items": items.map((item) => item.toMapSubset()).toList(),
            });
            if (printSnack) {
              Helpers.snackBarPrinter(
                  "Successful!", "Successfully updated the supplier item.");
            }

            return true;
          } else {
            print("Item doesn't exist in the list");
            // Item doesn't exist in the list
            if (printSnack) {
              Helpers.snackBarPrinter(
                  "Failed!", "Something is Wrong. Please try again.",
                  error: true);
            }

            return false;
          }
        } else {
          print("Item list Data doesn't exist.");
          if (printSnack) {
            Helpers.snackBarPrinter(
                "Failed!", "Something is Wrong. Please try again.",
                error: true);
          }

          return false;
        }
      } else {
        print("Item list document doesn't exist.");
        if (printSnack) {
          Helpers.snackBarPrinter(
              "Failed!", "Something is Wrong. Please try again.",
              error: true);
        }

        return false;
      }
    } catch (e) {
      print('Error updating supplier item: $e');
      return false;
    }
  }
}
