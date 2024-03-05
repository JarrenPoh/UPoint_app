import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/regular_text.dart';

import 'dimension.dart';
import 'medium_text.dart';

class Messenger {
  // 下方彈出的toast
  static toast(BuildContext context, String title, String text) {
    CColor cColor = CColor.of(context);
    Get.snackbar(
      title,
      text,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: cColor.white,
      colorText: cColor.black,
    );
  }

  // 上方彈出的toast
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
              size: Dimensions.height2 * 7.5,
              maxLines: 10,
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

  //彈窗Dialog
  static Future<Map> wishDialog(
    BuildContext context,
  ) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return CupertinoTheme(
          data: const CupertinoThemeData(),
          child: WishDialog(),
        );
      },
    );

    return result == null
        ? {"status": "failed"}
        : {
            "status": "success",
            "text": result,
          };
  }

  //彈窗Dialog
  static Future<String> updateDialog(
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
              size: Dimensions.height2 * 7.5,
              maxLines: 10,
              text: content,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop('success'),
                child: MediumText(
                  color: cColor.primary,
                  size: Dimensions.height2 * 8,
                  text: '更新',
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

class WishDialog extends StatefulWidget {
  const WishDialog({super.key});

  @override
  State<WishDialog> createState() => WishDialogState();
}

class WishDialogState extends State<WishDialog> {
  final TextEditingController _controller = TextEditingController();
  String? errorText;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (errorText != null) {
        setState(() {
          _controller.text.trim() == '' ? null : errorText = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return CupertinoAlertDialog(
      title: MediumText(
        color: cColor.grey500,
        size: Dimensions.height2 * 8,
        text: "留下許願內容",
      ),
      content: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              height: Dimensions.height2 * 96,
              width: Dimensions.width5 * 52,
              margin: EdgeInsets.symmetric(
                vertical: Dimensions.height2 * 8,
              ),
              padding: EdgeInsets.all(Dimensions.height5 * 2),
              decoration: BoxDecoration(
                color:cColor.white,
                border: Border.all(
                    color: errorText != null ? Colors.red : cColor.grey400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: cColor.grey500,
                  fontSize: Dimensions.height2 * 8,
                  fontFamily: "NotoSansRegular",
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: Dimensions.height5),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          if (errorText != null)
            RegularText(
              color: Colors.red,
              size: Dimensions.height2 * 6,
              text: errorText!,
            ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            print("object:${_controller.text.trim()}");
            if (_controller.text.trim() == "") {
              setState(() {
                errorText = "請至少輸入一個字元";
              });
            } else {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: Container(
            width: Dimensions.width2 * 52,
            height: Dimensions.height2 * 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cColor.primary,
            ),
            child: Center(
              child: MediumText(
                color: Colors.white,
                size: Dimensions.height2 * 8,
                text: '送出願望',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
