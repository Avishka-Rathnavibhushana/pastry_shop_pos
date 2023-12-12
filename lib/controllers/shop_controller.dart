import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/shop.dart';

class ShopController extends GetxController {
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
}
