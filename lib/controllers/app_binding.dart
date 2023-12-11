import 'package:get/instance_manager.dart';
import 'package:pastry_shop_pos/controllers/auth_controller.dart';
import 'package:pastry_shop_pos/controllers/supplier_controller.dart';

class AppBinding implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => SupplierController());
  }
}
