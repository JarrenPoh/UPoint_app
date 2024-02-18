import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../globals/colors.dart';
import '../../globals/regular_text.dart';

class SignFormBottom extends StatelessWidget {
  const SignFormBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final CColor cColor = CColor.of(context);
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
                color: cColor.grey500,
                fontSize: Dimensions.height2 * 7,
                fontFamily: "NotoSansRegular"),
            children: <TextSpan>[
              const TextSpan(
                text: "掃描或",
              ),
              const TextSpan(
                text: "Upoint App 獲取更多活動資訊！\n",
              ),
              TextSpan(
                text: "iOS點此下載  ",
                style: TextStyle(
                  color: cColor.primary,
                  fontFamily: "NotoSansMedium",
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(appleStoreLink));
                  },
              ),
              const TextSpan(
                text: "、",
              ),
              TextSpan(
                text: "Android點此下載 ",
                style: TextStyle(
                  color: cColor.primary,
                  fontFamily: "NotoSansMedium",
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // 在这里添加你的外部链接跳转逻辑
                    // 使用url_launcher包来打开外部链接
                    launchUrl(Uri.parse(googlePlayLink));
                  },
              ),
            ],
          ),
        ),
        // const SizedBox(height: 24),
        // // qrcode
        // Row(
        //   children: [
        //     _qrCode(appleStoreQrcode, "iOS版", cColor.grey500),
        //     SizedBox(
        //       height: 40,
        //       child: VerticalDivider(
        //         color: cColor.grey500,
        //         width: 72,
        //         thickness: 1,
        //       ),
        //     ),
        //     _qrCode(googlePlayQrcode, "Android版", cColor.grey500),
        //   ],
        // ),
        const SizedBox(height: 43)
      ],
    );
  }

  Widget _qrCode(String url, String text, Color color) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RegularText(color: color, size: 14, text: "UPoint APP"),
        const SizedBox(height: 8),
        RegularText(color: color, size: 14, text: text),
      ],
    );
  }
}
