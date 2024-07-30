import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';

class CustomLoadong2 extends StatelessWidget {
  const CustomLoadong2({super.key});
  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);

    if (Platform.isIOS) {
      return oSWidget(cColor);
    }
    return windowsWidget(cColor);
  }

  Widget windowsWidget(CColor cColor) {
    return  Center(
      child: SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          backgroundColor: cColor.grey400,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget oSWidget(CColor cColor) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: cColor.grey400,
      ),
    );
  }
}
