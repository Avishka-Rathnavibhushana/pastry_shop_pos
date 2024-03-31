import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/shop.dart';

class ShopController extends GetxController {
  var extraControllerValue = "0".obs;

  // create shop
  Future<bool> createShop(Shop shop) async {
    try {
      // Check if a shop with the same name already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('name', isEqualTo: shop.name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Shop doesn't exist, so add it
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(shop.name)
            .set(shop.toMap());

        Helpers.snackBarPrinter(
          "Successful!",
          "Successfully created the shop.",
        );

        return true;
      } else {
        // Shop with the same name already exists
        Helpers.snackBarPrinter(
          "Failed!",
          "Shop with the same name already exists.",
          error: true,
        );

        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Failed to create the shop.",
        error: true,
      );

      print('Error creating shop: $e');
      return false;
    }
  }

  // get shops list
  Future<List<Shop>> getShopsList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('shops').get();
      return querySnapshot.docs
          .map((doc) => Shop.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting shops list: $e');
      return [];
    }
  }

  // // get shops list
  // Future<List<String>> getShopsNameList() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('role', isEqualTo: 'CASHIER')
  //         .get();
  //     // Extract user names from the documents and return the list
  //     return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
  //   } catch (e) {
  //     print('Error getting shops list: $e');
  //     return [];
  //   }
  // }

  // get suppliers of a specific shop
  Future<List<String>> getSuppliersOfShop(String shopId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .get();
      if (docSnapshot.exists) {
        Shop shop = Shop.fromMap(docSnapshot.data() as Map<String, dynamic>);
        return shop.suppliers;
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting suppliers of shop: $e');
      return [];
    }
  }

  //check suppler exist in shop
  Future<bool> checkSupplierExistInShop(
      String shopId, String supplierId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .get();
      if (docSnapshot.exists) {
        Shop shop = Shop.fromMap(docSnapshot.data() as Map<String, dynamic>);
        if (shop.suppliers.contains(supplierId)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to check the supplier.",
          error: true);
      print('Error checking supplier: $e');
      return false;
    }
  }

  // add a supplier to shop
  Future<bool> addSupplierToShop(String shopId, String supplierId) async {
    try {
      if (await checkSupplierExistInShop(shopId, supplierId)) {
        Helpers.snackBarPrinter(
            "Failed!", "The supplier already exists in the shop.",
            error: true);
        return false;
      } else {
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(shopId)
            .update({
          'suppliers': FieldValue.arrayUnion([supplierId])
        });
        Helpers.snackBarPrinter(
            "Successful!", "Successfully added the supplier to the shop.");
        return true;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
          "Failed!", "Failed to add the supplier to the shop.",
          error: true);
      print('Error adding supplier to shop: $e');
      return false;
    }
  }

  // delete shop and spplier items from shop
  Future<bool> deleteShop(String id) async {
    try {
      // get shop details
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('shops').doc(id).get();
      Shop shop = Shop.fromMap(docSnapshot.data() as Map<String, dynamic>);
      // get suppliers of shop
      List<String> suppliers = shop.suppliers;

      // delete shopc from supplierItems
      for (int i = 0; i < suppliers.length; i++) {
        for (String session in Constants.Sessions) {
          // delete collections in supplierItems
          await FirebaseFirestore.instance
              .collection('supplierItems')
              .doc(suppliers[i])
              .collection(id + " " + session)
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
      }

      // remove shop from suppliers
      for (int i = 0; i < suppliers.length; i++) {
        await FirebaseFirestore.instance
            .collection('suppliers')
            .doc(suppliers[i])
            .update({
          'shops': FieldValue.arrayRemove([id])
        });
      }

      // delete shop
      await FirebaseFirestore.instance.collection('shops').doc(id).delete();

      // delete shop from users
      await FirebaseFirestore.instance.collection('users').doc(id).delete();

      Helpers.snackBarPrinter("Successful!", "Successfully deleted the shop.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to delete the shop.",
          error: true);
      print('Error deleting shop: $e');
      return false;
    }
  }

  // get shops collection-> shopid -> extra[date] value
  Future<double> getShopExtra(
      String shopId, String date, String session) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .get();
      if (docSnapshot.exists) {
        // get extra value map and return value if date exists
        Map<String, dynamic> extra =
            (docSnapshot.data() as Map<String, dynamic>)["extra"];
        if (extra.containsKey(date + " " + session)) {
          return extra[date + " " + session];
        } else {
          return 0.0;
        }
      } else {
        return 0.0;
      }
    } catch (e) {
      print('Error getting shop extra: $e');
      return 0.0;
    }
  }

  // update extra value map if date exists or add new date and value
  Future<bool> updateShopExtra(
      String shopId, String date, double value, String session) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .get();
      if (docSnapshot.exists) {
        // get extra value map
        Map<String, dynamic> shopData =
            docSnapshot.data() as Map<String, dynamic>;

        // update extra value map if date exists or add new date and value
        shopData["extra"][date + " " + session] = value;

        // update shop with new extra value map
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(shopId)
            .update(shopData);

        Helpers.snackBarPrinter(
          "Successful!",
          "Successfully updated the extra value.",
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Failed to update the extra value.",
        error: true,
      );
      print('Error updating shop extra: $e');
      return false;
    }
  }
}
