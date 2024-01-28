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
}
