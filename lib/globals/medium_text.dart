import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final Color color;
  final double size;
  final int? maxLines;
  final String text;
  final double? letterSpacing;
  const MediumText({
    super.key,
    required this.color,
    this.maxLines,
    required this.size,
    required this.text,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        letterSpacing: letterSpacing,
        fontSize: size,
        color: color,
        fontFamily: "NotoSansMedium",
      ),
    );
  }
}
