import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static void snackBarPrinter(String title, String message,
      {bool error = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: error ? Color(0xFFB05959) : Color(0xFF9BC39E),
    );
  }

  static String numberToStringConverter(double number) {
    String numberString = number.toStringAsFixed(2);
    String numberPart = numberString.split(".")[0];
    String decimalPart = numberString.split(".")[1];

    return int.parse(decimalPart) > 0 ? numberString : numberPart;
  }
}
