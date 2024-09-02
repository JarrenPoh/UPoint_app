import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/login/verfify_email.dart';

import '../../globals/colors.dart';
import '../../globals/custom_messengers.dart';
import '../custom_loading2.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool isLoading = false;
  String errorEmail = "";
  String errorPassword = "";
  String errorConfirm = "";

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
          _passwordController.text.trim() == '' ? null : errorPassword = "";
        });
      }
    });
    _confirmController.addListener(() {
      if (errorConfirm.isNotEmpty) {
        setState(() {
          _confirmController.text.trim() == '' ? null : errorConfirm = "";
        });
      }
    });
  }

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  void signUpUser() async {
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
    } else if (_confirmController.text.trim() == '') {
      setState(() {
        errorConfirm = "確認密碼不可為空";
      });
    } else if (_passwordController.text.trim() !=
        _confirmController.text.trim()) {
      setState(() {
        errorConfirm = "密碼填寫不同，請確認清楚你的密碼";
      });
    } else {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          // navigate to the home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return VerifyEmail(
                  email: _emailController.text,
                );
              },
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          // show the error
          // ignore: use_build_context_synchronously
          Messenger.snackBar(context, "失敗", '$res ，請洽詢官方發現問題');
          // ignore: use_build_context_synchronously
          await Messenger.dialog(
            '發生錯誤',
            '如有問題，請洽詢官方:service.upoint@gmail.com',
            context,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
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
                          BoldText(
                            color: CColor.of(context).grey500,
                            size: Dimensions.height2 * 8,
                            text: "精彩校園，",
                          ),
                          BoldText(
                            color: CColor.of(context).primary,
                            size: Dimensions.height2 * 8,
                            text: "U",
                          ),
                          BoldText(
                            color: CColor.of(context).grey500,
                            size: Dimensions.height2 * 8,
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
                        false,
                        Icons.lock,
                        "密碼",
                        errorPassword,
                        _passwordController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      textWidget(
                        true,
                        Icons.lock,
                        "確認密碼",
                        errorConfirm,
                        _confirmController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      ElevatedButton(
                        onPressed: () {
                          signUpUser();
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
                  child: CustomLoadong2(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget textWidget(
      obscureText, prefixIcon, hintText, String errorText, controller) {
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
