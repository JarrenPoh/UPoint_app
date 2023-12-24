import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/date_time_transfer.dart';

Future CustomDatePicker(
  BuildContext context,
  String chose,
  bool isChose,
  Function(DateTime) onDateTimeChanged,
  CupertinoDatePickerMode mode,
) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      Color onSecondary = Theme.of(context).colorScheme.onSecondary;
      Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
      DateTime _dateTime = isChose
          ? parseDateString(
              chose, mode == CupertinoDatePickerMode.date ? true : false)
          : DateTime.now();

      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: color_onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: TextStyle(color: onSecondary),
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: onSecondary,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  initialDateTime: _dateTime,
                  backgroundColor: color_onPrimary,
                  mode: mode,
                  minimumDate:
                      mode == CupertinoDatePickerMode.date ? _dateTime : null,
                  onDateTimeChanged: (date) {
                    onDateTimeChanged(date);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
