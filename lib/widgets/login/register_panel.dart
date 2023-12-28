import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

class RegisterPanel extends StatefulWidget {
  final Function() onTap;
  const RegisterPanel({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPanel> createState() => _RegisterPanelState();
}

class _RegisterPanelState extends State<RegisterPanel> {
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
                  //logo
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
                  textWidget(false, Icons.lock, "密碼"),
                  SizedBox(height: Dimensions.height5 * 3),
                  textWidget(true, Icons.lock, "確認密碼"),
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
                      '註冊',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height5 * 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "  已經有帳號了？",
                  style: TextStyle(color: primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "回登入頁面！",
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
          borderRadius: BorderRadius.circular(10), // 圓角設定
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
