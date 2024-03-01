import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';

class WishingPage extends StatefulWidget {
  const WishingPage({super.key});

  @override
  State<WishingPage> createState() => _WishingPageState();
}

class _WishingPageState extends State<WishingPage> {
  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return Scaffold(
      body: Center(
        child: MediumText(
          color: cColor.grey500,
          size: Dimensions.height2 * 8,
          text: "功能許願池",
        ),
      ),
    );
  }
}
