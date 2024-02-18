import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';

import '../globals/medium_text.dart';
import '../models/user_model.dart';

class SignFormFinishPage extends StatelessWidget {
  final UserModel user;
  final String res;
  const SignFormFinishPage({
    super.key,
    required this.user,
    required this.res,
  });

  @override
  Widget build(BuildContext context) {
    String image = res == "success" ? "create_success" : "create_failed";
    String text =
        res == "success" ? "報名成功！" : "$res 上傳失敗！請聯絡service.upoint@gmail.com";
    CColor cColor = CColor.of(context);
    return Scaffold(
      backgroundColor: cColor.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Dimensions.height2 * 76,
              height: Dimensions.height2 * 76,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/$image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 17),
            MediumText(
              color: cColor.grey500,
              size: 20,
              text: text,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: Dimensions.width5 * 30,
              height: Dimensions.height2 * 20,
              child: CupertinoButton(
                color: cColor.primary,
                onPressed: () => Navigator.pop(context),
                pressedOpacity: 0.8,
                padding: const EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                    color: cColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cColor.primary),
                  ),
                  child: Center(
                    child: MediumText(
                      color: cColor.primary,
                      size: Dimensions.height2 * 8,
                      text: "回首頁",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
