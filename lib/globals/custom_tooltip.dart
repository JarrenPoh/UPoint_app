import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:upoint/globals/colors.dart';

import 'dimension.dart';
import 'medium_text.dart';

class CustomToolTip extends StatefulWidget {
  final String text;
  const CustomToolTip({
    super.key,
    required this.text,
  });

  @override
  State<CustomToolTip> createState() => _CustomToolTipState();
}

class _CustomToolTipState extends State<CustomToolTip> {
  final JustTheController tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return GestureDetector(
      onTap: () {
        print('value:${tooltipController.value}');
        if (tooltipController.value == TooltipStatus.isHidden) {
          tooltipController.showTooltip();
        }
      },
      child: JustTheTooltip(
        controller: tooltipController,
        borderRadius: BorderRadius.circular(5),
        backgroundColor: cColor.grey100,
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: MediumText(
            color: cColor.grey500,
            size: Dimensions.height2 * 7,
            text: widget.text,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: cColor.grey300,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.all(0),
          child: Icon(
            Icons.question_mark,
            color: cColor.grey300,
            size: Dimensions.height2 * 6,
          ),
        ),
      ),
    );
  }
}
