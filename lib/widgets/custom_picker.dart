import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> CustomPicker(
  BuildContext context,
  List choseList,
  int iniChose,
  String chose,
  bool isChose,
  Function(int) onSelectedItemChanged,
) {
  Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
  Color color_title = Theme.of(context).colorScheme.primary;
  Color onSecondary = Theme.of(context).colorScheme.onSecondary;

  return showModalBottomSheet(
    context: context,
    builder: (_) {
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
                style: TextStyle(color: color_title),
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
                child: CupertinoPicker(
                  backgroundColor: color_onPrimary,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(
                    initialItem: iniChose,
                  ),
                  onSelectedItemChanged: (int value) {
                    onSelectedItemChanged(value);
                    chose = choseList[value].toString();
                    iniChose = value;
                    isChose = true;
                  },
                  children: List.generate(
                    choseList.length,
                    (index) => Text(
                      (choseList[index]).toString(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
