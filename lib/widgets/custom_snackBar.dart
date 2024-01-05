import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showCustomSnackbar(String title, String message, BuildContext context) {
  Color onSecondary = Theme.of(context).colorScheme.onSecondary;
  Color onPrimary = Theme.of(context).colorScheme.onPrimary;

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
    backgroundColor: onPrimary,
    colorText: onSecondary,
  );
}
