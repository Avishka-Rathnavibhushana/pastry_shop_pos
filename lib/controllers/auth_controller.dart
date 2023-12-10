import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pastry_shop_pos/models/user.dart';

class AuthController extends GetxController {
  final user = User(
    username: "",
    role: "",
    password: "",
    address: "",
    tel: "",
    shop: "",
  ).obs;

  // create user
  Future<void> createUserWithId(String userId, User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user.toMap());
      Get.snackbar("Successful!", "Successfully created the user.");
    } catch (e) {
      Get.snackbar("Failed!", "Failed to create the user.");
      print('Error creating user with ID: $e');
    }
  }

  // get users list
  Future<List<User>> getUsersList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting users list: $e');
      return [];
    }
  }

  // get user by id
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        return User.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  // update user by id
  Future<void> updateUserById(String userId, User updatedUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updatedUser.toMap());
      Get.snackbar("Successful!", "Successfully updated the user.");
    } catch (e) {
      Get.snackbar("Failed!", "Failed to update the user.");
      print('Error updating user by ID: $e');
    }
  }

  // delete user by id
  Future<void> deleteUserById(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      Get.snackbar("Successful!", "Successfully deleted the user.");
    } catch (e) {
      Get.snackbar("Failed!", "Failed to delete the user.");
      print('Error deleting user by ID: $e');
    }
  }
}
