import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pastry_shop_pos/controllers/app_binding.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';
import 'package:pastry_shop_pos/pages/chashier_home_page.dart';
import 'package:pastry_shop_pos/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDmFXRVjlesU_Ls4yJYTD0AqRioXX-JoDw",
      authDomain: "pastry-shop-87211.firebaseapp.com",
      projectId: "pastry-shop-87211",
      storageBucket: "pastry-shop-87211.appspot.com",
      messagingSenderId: "2874494797",
      appId: "1:2874494797:web:7d1dcea0104409e009f104",
      measurementId: "G-QW09QN6J3D",
      // databaseURL:
      //     "https://pastry-shop-pos-default-rtdb.asia-southeast1.firebasedatabase.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pastry Shop POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      initialBinding: AppBinding(),
      home: Material(
        child: LoginPage(),
        //     CashierHomePage(
        //   shopName: "test",
        // ),
        //     AdminHomePage(
        //   shopName: "Admin Panel",
        // ),
      ),
    );
  }
}
