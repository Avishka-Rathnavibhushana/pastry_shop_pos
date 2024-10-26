import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_item_controller.dart';
import 'package:pastry_shop_pos/models/supplier.dart';
import 'package:pastry_shop_pos/models/supplier_item.dart';

class DatabaseChangeScripts {
  //get all suppliers from supplier document and chnage shop string varibale to shops list variable
  Future<void> changeShopStringToShopList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('suppliers').get();
      querySnapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance
            .collection('suppliers')
            .doc(doc['name'])
            .update({
          'shops': [doc['shop']]
        });
        //remove shop string variable
        await FirebaseFirestore.instance
            .collection('suppliers')
            .doc(doc['name'])
            .update({'shop': FieldValue.delete()});
      });
    } catch (e) {
      print('Error getting suppliers list: $e');
    }
  }

  // get all collection documents from supplierItems collection and add activated=true bool field for all items
  Future<void> addActivatedFieldToSupplierItems() async {
    print("object");
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('suppliers').get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      print(documents.length);

      for (var document in documents) {
        // Access the document ID and reference
        String documentId = document["name"];
        print(documentId);
        List<String> shops = document["shops"].cast<String>();
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('supplierItems')
            .doc(documentId);

        print(shops.length);

        for (var shop in shops) {
          // print(shop);
          QuerySnapshot morningSnapshot =
              await documentReference.collection(shop + " " + 'Morning').get();
          List<DocumentSnapshot> morningDocs = morningSnapshot.docs;
          print(shop + " " + 'Morning' + " " + morningDocs.length.toString());
          for (var morningDoc in morningDocs) {
            //get "items" field in each document
            List items = morningDoc['items'];
            // loop through items list and add activated field
            items.forEach((item) async {
              await documentReference
                  .collection(shop + " " + 'Morning')
                  .doc(morningDoc.id)
                  .update({
                'items': FieldValue.arrayUnion([
                  {
                    'name': item['name'],
                    'date': item['date'],
                    'sold': item['sold'],
                    'salePrice': item['salePrice'],
                    'purchasePrice': item['purchasePrice'],
                    'qty': item['qty'],
                    'activated': true,
                  }
                ])
              });
            });

            // //get "items" field in each document
            // List items = morningDoc['items'];
            // // loop through items list and remove items where activated field is not present
            // items.forEach((item) async {
            //   if (item['activated'] == null) {
            //     await documentReference
            //         .collection(shop + " " + 'Morning')
            //         .doc(morningDoc.id)
            //         .update({
            //       'items': FieldValue.arrayRemove([item])
            //     });
            //   }
            // });
          }
          QuerySnapshot eveningSnapshot =
              await documentReference.collection(shop + " " + 'Evening').get();
          List<DocumentSnapshot> eveningDocs = eveningSnapshot.docs;
          print(shop + " " + 'Evening' + " " + eveningDocs.length.toString());
          for (var eveningDoc in eveningDocs) {
            //get "items" field in each document
            List items = eveningDoc['items'];
            // loop through items list and add activated field
            items.forEach((item) async {
              await documentReference
                  .collection(shop + " " + 'Evening')
                  .doc(eveningDoc.id)
                  .update({
                'items': FieldValue.arrayUnion([
                  {
                    'name': item['name'],
                    'date': item['date'],
                    'sold': item['sold'],
                    'salePrice': item['salePrice'],
                    'purchasePrice': item['purchasePrice'],
                    'qty': item['qty'],
                    'activated': true,
                  }
                ])
              });
            });

            // //get "items" field in each document
            // List items = eveningDoc['items'];
            // // loop through items list and remove items where activated field is not present
            // items.forEach((item) async {
            //   if (item['activated'] == null) {
            //     await documentReference
            //         .collection(shop + " " + 'Evening')
            //         .doc(eveningDoc.id)
            //         .update({
            //       'items': FieldValue.arrayRemove([item])
            //     });
            //   }
            // });
          }
        }
      }
    } catch (e) {
      print('Error getting supplierItems list: $e');
    }
  }

  // Script to update activated, salePrice and purchasePrice of supplier items specifying date, shop, session and supplierId
  // Takes supplierId, date, shop, session as input and updates the supplier items in the supplierItems collection if ther is any change in the supplier items with updateFrom date
  Future<bool> getItemsFromSupplierAndAddToSupplierItem(
      String supplierId, String date, String shop, String session) async {
    try {
      SupplierItemController supplierItemController =
          Get.find<SupplierItemController>();
      // fetch items from the supplier
      SupplierController supplierController = Get.find<SupplierController>();
      Supplier? supplier = await supplierController.getSupplierById(supplierId);

      List<SupplierItem> supplierItemsPreviousDay = [];

      int updateFrom = 6;

      DateTime dateTime = DateTime.parse(date);
      DateTime previousDate = dateTime.subtract(Duration(days: updateFrom));
      String previousDateStr = previousDate.toString().split(" ")[0];
      supplierItemsPreviousDay =
          await supplierItemController.getSupplierItemsByShopByTime(
        supplierId,
        previousDateStr,
        shop,
        session,
      );

      List<SupplierItem> supplierItemsCurrentDay =
          await supplierItemController.getSupplierItemsByShopByTime(
        supplierId,
        date,
        shop,
        session,
      );

      if (supplier != null) {
        int count = 0;
        print(supplierId + "\n");
        for (SupplierItem item in supplierItemsPreviousDay) {
          SupplierItem? supplierItema = supplierItemsCurrentDay
              .firstWhere((element) => element.name == item.name);
          // ignore: unnecessary_null_comparison
          if (supplierItema == null) {
            continue;
          }

          if (supplierItema.activated == item.activated &&
              supplierItema.salePrice == item.salePrice &&
              supplierItema.purchasePrice == item.purchasePrice) {
            continue;
          } else {
            print(supplierItema.toMap());
            print(item.toMap());
            supplierItema.activated = item.activated;
            supplierItema.salePrice = item.salePrice;
            supplierItema.purchasePrice = item.purchasePrice;
            await supplierItemController.updateItemInSupplierItem(
              supplierId,
              supplierItema,
              date,
              shop,
              session,
            );
            count = count + 1;
          }
        }

        print("Count: $count");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(
          'Error getting items from supplier and adding to supplier item: $e');
      return false;
    }
  }
}
