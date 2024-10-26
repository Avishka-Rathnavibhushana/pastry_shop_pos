import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/models/user.dart';

class AccountantController extends GetxController {
  // get Accountant users list
  Future<List<User>> getAccountantsList() async {
    try {
      // get list of users from user collection where role is accountant
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: Constants.Accountant)
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting shops list: $e');
      return [];
    }
  }
}
