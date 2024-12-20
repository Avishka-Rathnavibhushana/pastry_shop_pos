import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
import 'package:pastry_shop_pos/models/supplier.dart';

class SupplierController extends GetxController {
  // create supplier
  Future<bool> createSupplier(Supplier supplier) async {
    try {
      // Check if a supplier with the same name already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .where('name', isEqualTo: supplier.name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Supplier doesn't exist, so add it
        await FirebaseFirestore.instance
            .collection('suppliers')
            .doc(supplier.name)
            .set(supplier.toMap());

        Helpers.snackBarPrinter(
          "Successful!",
          "Successfully created the supplier.",
        );

        return true;
      } else {
        // Supplier with the same name already exists
        Helpers.snackBarPrinter(
          "Failed!",
          "Supplier with the same name already exists.",
          error: true,
        );

        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
        "Failed!",
        "Failed to create the supplier.",
        error: true,
      );

      print('Error creating supplier: $e');
      return false;
    }
  }

  // check if item exist in supplier
  Future<bool> checkItemExistInSupplier(String supplierId, String item) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .get();
      if (docSnapshot.exists) {
        Supplier supplier =
            Supplier.fromMap(docSnapshot.data() as Map<String, dynamic>);
        if (supplier.items.contains(item)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to check the item.",
          error: true);
      print('Error checking item: $e');
      return false;
    }
  }

  // add new item to a supplier
  Future<bool> addItemToSupplier(String supplierId, String item) async {
    try {
      if (await checkItemExistInSupplier(supplierId, item)) {
        Helpers.snackBarPrinter(
            "Failed!", "The item already exists in the supplier.",
            error: true);
        return false;
      } else {
        await FirebaseFirestore.instance
            .collection('suppliers')
            .doc(supplierId)
            .update({
          'items': FieldValue.arrayUnion([item])
        });
        Helpers.snackBarPrinter(
            "Successful!", "Successfully added the item to the supplier.");
        return true;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
          "Failed!", "Failed to add the item to the supplier.",
          error: true);
      print('Error adding item to supplier: $e');
      return false;
    }
  }

  // add list of items to supplier
  Future<bool> addItemsToSupplier(String supplierId, List<String> items) async {
    try {
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .update({'items': FieldValue.arrayUnion(items)});
      Helpers.snackBarPrinter(
          "Successful!", "Successfully added the items to the supplier.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter(
          "Failed!", "Failed to add the items to the supplier.",
          error: true);
      print('Error adding items to supplier: $e');
      return false;
    }
  }

  // add list of shops to supplier
  Future<bool> addShopsToSupplier(String supplierId, List<String> shops) async {
    try {
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .update({'shops': FieldValue.arrayUnion(shops)});
      Helpers.snackBarPrinter(
          "Successful!", "Successfully added the shops to the supplier.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter(
          "Failed!", "Failed to add the shops to the supplier.",
          error: true);
      print('Error adding items to supplier: $e');
      return false;
    }
  }

  // get suppliers list
  Future<List<Supplier>> getSuppliersList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('suppliers').get();
      return querySnapshot.docs
          .map((doc) => Supplier.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting suppliers list: $e');
      return [];
    }
  }

  // get suppliers of a specific shop
  Future<List<Supplier>> getSuppliersOfShop(String shopName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .where('shop', isEqualTo: shopName)
          .get();
      return querySnapshot.docs
          .map((doc) => Supplier.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting suppliers list: $e');
      return [];
    }
  }

  // get supplier by id
  Future<Supplier?> getSupplierById(String supplierId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .get();
      if (docSnapshot.exists) {
        return Supplier.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting supplier by ID: $e');
      return null;
    }
  }

  // delete supplier
  Future<bool> deleteSupplier(String supplierId, String shopId) async {
    try {
      // get supplier by id
      Supplier? supplier = await getSupplierById(supplierId);
      if (supplier == null) {
        Helpers.snackBarPrinter("Failed!", "The supplier doesn't exist.",
            error: true);
        return false;
      }

      // remove the supplier from the shops
      await FirebaseFirestore.instance.collection('shops').doc(shopId).update({
        'suppliers': FieldValue.arrayRemove([supplierId])
      });

      supplier.shops.length == 1
          ? await FirebaseFirestore.instance
              .collection('suppliers')
              .doc(supplierId)
              .delete()
          : await FirebaseFirestore.instance
              .collection('suppliers')
              .doc(supplierId)
              .update({
              'shops': FieldValue.arrayRemove([shopId])
            });

      // delete the supplierItems for the supplier
      for (String session in Constants.Sessions) {
        // delete collections in supplierItems
        await FirebaseFirestore.instance
            .collection('supplierItems')
            .doc(supplierId)
            .collection(shopId + " " + session)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      }

      Helpers.snackBarPrinter(
          "Successful!", "Successfully deleted the supplier from shop.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to delete the supplier.",
          error: true);
      print('Error deleting supplier: $e');
      return false;
    }
  }

  // delete supplier across all shops
  Future<bool> deleteSupplierCompletely(String supplierId) async {
    try {
      // get supplier by id
      Supplier? supplier = await getSupplierById(supplierId);
      if (supplier == null) {
        Helpers.snackBarPrinter("Failed!", "The supplier doesn't exist.",
            error: true);
        return false;
      }

      // get shops of the supplier
      List<String> shops = supplier.shops;

      for (int i = 0; i < shops.length; i++) {
        // remove the supplier from the shops
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(shops[i])
            .update({
          'suppliers': FieldValue.arrayRemove([supplierId])
        });

        // delete the supplierItems for the supplier
        for (String session in Constants.Sessions) {
          // delete collections in supplierItems
          await FirebaseFirestore.instance
              .collection('supplierItems')
              .doc(supplierId)
              .collection(shops[i] + " " + session)
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
      }

      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplierId)
          .delete();

      Helpers.snackBarPrinter(
          "Successful!", "Successfully deleted the supplier.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to delete the supplier.",
          error: true);
      print('Error deleting supplier: $e');
      return false;
    }
  }
}
