import 'package:flutter/material.dart';
import 'package:get/get.dart';

void ErrorMessage(err, message) {
    Get.snackbar(
      err,
      message,
      
      dismissDirection: DismissDirection.up,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderWidth: 3,
        backgroundColor: const Color(0xFFFFF8E1),
      borderColor: err == "error" ? Colors.red : Colors.green,
    );
  }