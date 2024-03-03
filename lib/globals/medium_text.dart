import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  final Color color;
  final double size;
  final int? maxLines;
  final String text;
  final double? letterSpacing;
  final TextAlign? textAlign;
  const MediumText({
    super.key,
    required this.color,
    this.maxLines,
    required this.size,
    required this.text,
    this.letterSpacing,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        letterSpacing: letterSpacing,
        fontSize: size,
        color: color,
        fontFamily: "NotoSansMedium",
      ),
    );
  }
}
