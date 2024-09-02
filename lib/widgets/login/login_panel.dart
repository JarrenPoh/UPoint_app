import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/widgets/custom_loading2.dart';
import 'package:upoint/widgets/login/reset_password.dart';
import 'package:provider/provider.dart';

import '../../globals/bold_text.dart';
import 'verfify_email.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorEmail = "";
  String errorPassword = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (errorEmail.isNotEmpty) {
        setState(() {
          _emailController.text.trim() == '' ? null : errorEmail = "";
        });
      }
    });
    _passwordController.addListener(() {
      if (errorPassword.isNotEmpty) {
        setState(() {
          _passwordController.text.trim() == '' ? null : errorPassword = '';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  void loginUser() async {
    if (_emailController.text.trim() == '') {
      setState(() {
        errorEmail = "電子郵件不可為空";
      });
    } else if (!isEmail(_emailController.text.trim())) {
      setState(() {
        errorEmail = "請輸入有效的電子郵件格式";
      });
    } else if (_passwordController.text.trim() == '') {
      setState(() {
        errorPassword = "密碼不可為空";
      });
    } else {
      if (!isLoading) {
        FocusScope.of(context).unfocus();
        setState(() {
          isLoading = true;
        });
        String res = await AuthMethods().loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

        signIn(res);
      }
    }
  }

  void signIn(res) async {
    if (res == "success") {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        await Messenger.dialog(
          '如有問題，請洽詢官方:service.upoint@gmail.com',
          '你尚未驗證你的Gmail',
          context,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return VerifyEmail(
                email: _emailController.text,
              );
            },
          ),
        );
        // ignore: use_build_context_synchronously
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await AuthMethods().signOut();
      // ignore: use_build_context_synchronously
      Messenger.snackBar(context, "失敗", '$res ，請洽詢官方發現問題');
      // ignore: use_build_context_synchronously
      await Messenger.dialog(
        '發生錯誤',
        '$res，請洽詢官方:service.upoint@gmail.com',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.width5 * 4),
                  child: Column(
                    children: [
                      //logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BoldText(
                            color: CColor.of(context).primary,
                            size: Dimensions.height2 * 24,
                            text: "U",
                          ),
                          BoldText(
                            color: CColor.of(context).grey500,
                            size: Dimensions.height2 * 24,
                            text: "Point",
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediumText(
                            color: CColor.of(context).grey500,
                            size: Dimensions.height2 * 8,
                            letterSpacing: null,
                            text: "精彩校園，",
                          ),
                          MediumText(
                            color: CColor.of(context).primary,
                            size: Dimensions.height2 * 8,
                            letterSpacing: null,
                            text: "U",
                          ),
                          MediumText(
                            color: CColor.of(context).grey500,
                            size: Dimensions.height2 * 8,
                            letterSpacing: null,
                            text: "你作主",
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height5 * 5),
                      textWidget(
                        false,
                        Icons.people_alt_rounded,
                        "電子郵件",
                        errorEmail,
                        _emailController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      textWidget(
                        true,
                        Icons.lock,
                        "密碼",
                        errorPassword,
                        _passwordController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      ElevatedButton(
                        onPressed: () async {
                          loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CColor.of(context).primary,
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
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: ((context) => ResetPassword()),
                                ),
                              );
                            },
                            child: Text(
                              "忘記密碼>",
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
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
                          GestureDetector(
                            onTap: () async {
                              String res;
                              setState(() {
                                isLoading = true;
                              });
                              res = await AuthMethods().signInWithGoogle();
                              signIn(res);
                            },
                            child: Container(
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
                          ),
                          SizedBox(width: isIOS ? Dimensions.width5 * 5 : 0),
                          isIOS
                              ? GestureDetector(
                                  onTap: () async {
                                    String res;
                                    setState(() {
                                      isLoading = true;
                                    });
                                    res = await AuthMethods().signInWithApple();
                                    signIn(res);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.grey[100],
                                    ),
                                    child: Image.asset(
                                      "assets/apple.png",
                                      height: Dimensions.height5 * 6,
                                    ),
                                  ),
                                )
                              : Container()
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
                          color: CColor.of(context).primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  height: Dimensions.height5 * 14,
                  width: Dimensions.width5 * 14,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const CustomLoadong2()
                )
              : Container()
        ],
      ),
    );
  }

  Widget textWidget(obscureText, prefixIcon, hintText, String errorText,
      TextEditingController controller) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: onSecondary),
      cursorColor: hintColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // 圓角設定
        ),
        errorText: errorText.isNotEmpty ? errorText : null,
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
