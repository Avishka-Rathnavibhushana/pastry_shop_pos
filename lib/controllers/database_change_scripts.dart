import 'package:cloud_firestore/cloud_firestore.dart';

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
}
