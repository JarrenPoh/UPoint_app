import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/regular_text.dart';

class EditChoose extends StatefulWidget {
  final bool isChose;
  final String chose;
  final String unit;
  final Function onPressed;
  const EditChoose({
    super.key,
    required this.chose,
    required this.isChose,
    required this.unit,
    required this.onPressed,
  });

  @override
  State<EditChoose> createState() => _EditChooseState();
}

class _EditChooseState extends State<EditChoose> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;

    return CupertinoButton(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(Dimensions.height5),
        ),
        padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                RegularText(
                  color: onSecondary,
                  size: Dimensions.height2 * 8,
                  text: !widget.isChose
                      ? widget.chose + '        '
                      : widget.chose + widget.unit,
                ),
                if (!widget.isChose)
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: onSecondary,
                  ),
              ],
            ),
          ],
        ),
      ),
      onPressed: () {
        widget.onPressed();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
