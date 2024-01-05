import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  double? currentBrightness;
  bool isTouch = false;
  @override
  Widget build(BuildContext context) {
    // Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color hintColor = Theme.of(context).hintColor;
    return Scaffold(
      backgroundColor: appBarColor,
      body: isTouch
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Dimensions.screenWidth,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/qrcode.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    isTouch = true;
                  });
                },
                child: MediumText(
                  color: hintColor,
                  size: Dimensions.height2 * 8,
                  text: '生成點名',
                ),
              ),
            ),
    );
  }
}
