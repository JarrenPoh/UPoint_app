import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:upoint/globals/colors.dart';

import 'dimension.dart';
import 'medium_text.dart';

class Messenger {
  // 下方彈出的toast
  static snackBar(BuildContext context, String title, String text) {
    CColor cColor = CColor.of(context);
    Get.snackbar(
      title,
      text,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: cColor.white,
      colorText: cColor.black,
    );
  }

  //彈窗Dialog
  static Future<String> dialog(
    String title,
    String content,
    BuildContext context,
  ) async {
    CColor cColor = CColor.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoTheme(
          data: CupertinoThemeData(barBackgroundColor: cColor.white),
          child: CupertinoAlertDialog(
            title: MediumText(
              color: cColor.grey400,
              size: Dimensions.height2 * 7,
              text: title,
            ),
            content: MediumText(
              color: cColor.grey500,
              size: Dimensions.height2 * 9,
              text: content,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop('cancel'),
                child: MediumText(
                  color: Colors.blueAccent,
                  size: Dimensions.height2 * 8,
                  text: '取消',
                ),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop('success'),
                child: MediumText(
                  color: Colors.redAccent,
                  size: Dimensions.height2 * 8,
                  text: '確定',
                ),
              ),
            ],
          ),
        );
      },
    );

    // Return 'result' which will be 'success' or 'cancel'
    return result ??
        'dismissed'; // Return 'dismissed' if the dialog is dismissed without selection
  }

  //選日期
  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime? selectedDate,
  ) async {
    CColor cColor = CColor.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: cColor.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  //選時間
  static Future<TimeOfDay?> selectTime(
    BuildContext context,
    TimeOfDay? selectedTime,
  ) async {
    CColor cColor = CColor.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: cColor.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return picked;
  }
}
