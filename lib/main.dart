import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/pages/admin_home_page.dart';
import 'package:pastry_shop_pos/pages/chashier_home_page.dart';
import 'package:pastry_shop_pos/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAHfpKmCi9-K3bR3Aj0qdC8Bu4bK-pG_CY",
        authDomain: "pastry-shop-pos.firebaseapp.com",
        databaseURL:
            "https://pastry-shop-pos-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "pastry-shop-pos",
        storageBucket: "pastry-shop-pos.appspot.com",
        messagingSenderId: "945867413250",
        appId: "1:945867413250:web:d3a643673ac0859593d41b",
        measurementId: "G-TWTEX6WY0V"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastry Shop POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
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
