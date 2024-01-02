import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

class LoginPanel extends StatefulWidget {
  final Function() onTap;
  const LoginPanel({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  @override
  Widget build(BuildContext context) {
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 4),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.height5 * 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: AssetImage("assets/Upoint.png"),
                        width: Dimensions.width5 * 16,
                        height: Dimensions.height5 * 16,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  textWidget(false, Icons.people_alt_rounded, "電子郵件"),
                  SizedBox(height: Dimensions.height5 * 3),
                  textWidget(true, Icons.lock, "密碼"),
                  SizedBox(height: Dimensions.height5 * 3),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hintColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(double.infinity, Dimensions.height2 * 22),
                    ),
                    child: const Text(
                      '登入',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height5 * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "忘記密碼>",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height5 * 2),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                      Text(
                        "  或 使用以下方法登入  ",
                        style: TextStyle(color: primary),
                      ),
                      const Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height5 * 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: Image.asset(
                          "assets/google.png",
                          height: Dimensions.height5 * 6,
                        ),
                      ),
                      SizedBox(width: Dimensions.width5 * 5),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: Image.asset(
                          "assets/apple.png",
                          height: Dimensions.height5 * 6,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height5 * 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "  沒有帳號嗎？",
                  style: TextStyle(color: primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "點此註冊！",
                    style: TextStyle(
                      color: hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textWidget(obscureText, prefixIcon, hintText) {
    Color primary = Theme.of(context).colorScheme.primary;
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(prefixIcon, color: primary),
        hintText: hintText,
        hintStyle: TextStyle(color: primary),
        contentPadding: EdgeInsets.symmetric(
          vertical: Dimensions.height2 * 7,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
