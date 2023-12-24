import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';

Future CustomDialog(
  context,
  title,
  content,
  color_title,
  color_content,
  onPress,
) {
  return showDialog(
    context: context,
    builder: (context) {
      Color onPrimary = Theme.of(context).colorScheme.onPrimary;
      return CupertinoTheme(
        data: CupertinoThemeData(barBackgroundColor: onPrimary),
        child: CupertinoAlertDialog(
          title: RegularText(
            color: color_title,
            size: Dimensions.height2 * 6,
            text: title,
          ),
          content: MediumText(
            color: color_content,
            size: Dimensions.height2 * 8,
            text: content,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: MediumText(
                color: Colors.blueAccent,
                size: Dimensions.height2 * 8,
                text: '取消',
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => onPress(),
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
}
