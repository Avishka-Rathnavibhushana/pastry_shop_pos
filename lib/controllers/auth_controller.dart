import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pastry_shop_pos/constants/constants.dart';
import 'package:pastry_shop_pos/helpers/helpers.dart';
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

  var loading = false.obs;

  // create user
  Future<bool> createUserWithId(String userId, User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user.toMap());
      Helpers.snackBarPrinter("Successful!", "Successfully created the user.");
      return true;
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to create the user.",
          error: true);
      print('Error creating user with ID: $e');
      return false;
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
      Helpers.snackBarPrinter("Successful!", "Successfully updated the user.");
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to update the user.",
          error: true);
      print('Error updating user by ID: $e');
    }
  }

  // delete user by id
  Future<void> deleteUserById(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      Helpers.snackBarPrinter("Successful!", "Successfully deleted the user.");
    } catch (e) {
      Helpers.snackBarPrinter("Failed!", "Failed to delete the user.",
          error: true);
      print('Error deleting user by ID: $e');
    }
  }

  // load roles and shops
  Future<dynamic> loadRolesAndShops() async {
    try {
      List<User> users = await getUsersList();
      List<String> roles = [];
      List<String> shops = [];
      for (User user in users) {
        if (user.role == Constants.Admin && !roles.contains(Constants.Admin)) {
          roles.add(user.role);
        }
        if (user.role == Constants.Cashier &&
            !roles.contains(Constants.Cashier)) {
          roles.add(user.role);
        }
        if (user.role == Constants.Accountant &&
            !roles.contains(Constants.Accountant)) {
          roles.add(user.role);
        }
        if (user.role == Constants.Cashier &&
            user.shop != null &&
            !shops.contains(user.shop)) {
          shops.add(user.shop!);
        }
      }
      return [roles, shops];
    } catch (e) {
      print('Error loading roles and shops: $e');
      return [];
    }
  }

  // authenticate user
  Future<bool> authenticateUser(String username, String password, String role,
      {String? shop}) async {
    try {
      User? user = await getUserById(username);
      if (user != null) {
        if (user.password != Helpers.encryptPassword(password)) {
          Helpers.snackBarPrinter("Failed!", "Incorrect password.",
              error: true);
          return false;
        }

        if (user.role != role) {
          Helpers.snackBarPrinter("Failed!", "Incorrect role.", error: true);
          return false;
        }

        if ((user.role == Constants.Cashier ||
                user.role == Constants.Accountant) &&
            user.shop != shop) {
          Helpers.snackBarPrinter("Failed!", "Incorrect shop.", error: true);
          return false;
        }

        Helpers.snackBarPrinter("Successful!", "Successfully logged in.");
        this.user.value = user;
        return true;
      } else {
        Helpers.snackBarPrinter("Failed!", "User not found.", error: true);
        return false;
      }
    } catch (e) {
      Helpers.snackBarPrinter(
          "Failed!", "Something is wrong. Please try again.",
          error: true);
      print('Error authenticating user: $e');
      return false;
    }
  }

  // logout user
  Future<void> logoutUser({bool snackBar = false}) async {
    try {
      this.user.value = User(
        username: "",
        role: "",
        password: "",
        address: "",
        tel: "",
        shop: "",
      );
      if (snackBar) {
        Helpers.snackBarPrinter("Successful!", "Successfully logged out.");
      }
    } catch (e) {
      if (snackBar) {
        Helpers.snackBarPrinter(
            "Failed!", "Something is wrong. Please try again.",
            error: true);
      }
      print('Error logging out user: $e');
    }
  }

  // load shops list
  Future<List<String>> loadShopsList() async {
    try {
      List<User> users = await getUsersList();
      List<String> shops = [];
      for (User user in users) {
        if (user.role == Constants.Cashier &&
            user.shop != null &&
            !shops.contains(user.shop)) {
          shops.add(user.shop!);
        }
      }
      return shops;
    } catch (e) {
      print('Error loading shops list: $e');
      return [];
    }
  }
}
