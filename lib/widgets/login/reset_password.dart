import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';

import '../../globals/colors.dart';
import '../../globals/custom_messengers.dart';
import '../custom_loading2.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String errorEmail = "";
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
  }

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  Future resetPassword() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.trim() == '') {
      setState(() {
        errorEmail = "電子郵件不可為空";
      });
    } else if (!isEmail(_emailController.text.trim())) {
      setState(() {
        errorEmail = "請輸入有效的電子郵件格式";
      });
    } else {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().resetPassword(
        _emailController.text.trim(),
      );
      if (res == 'success') {
        // ignore: use_build_context_synchronously
        Messenger.snackBar(
          context,
          "成功",
          '$res重置密碼已寄至${_emailController.text.trim()}，請查閱',
        );
        Navigator.of(context).pop();
      } else {
        // ignore: use_build_context_synchronously
        Messenger.snackBar(
          context,
          "成功",
          '$res重置密碼已寄至${_emailController.text.trim()}，請查閱',
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          elevation: 0,
          title: MediumText(
            color: onSecondary,
            size: Dimensions.height2 * 9,
            text: '重置密碼',
          ),
          iconTheme: IconThemeData(color: hintColor, size: 20),
        ),
        body: Center(
          child: isLoading
              ? CustomLoadong2()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textWidget(
                        false,
                        Icons.people_alt_rounded,
                        "輸入你的電子信箱，我們將寄信給您",
                        errorEmail,
                        _emailController,
                      ),
                      const SizedBox(height: 24),
                      //bottom
                      CupertinoButton(
                        onPressed: resetPassword,
                        child: Container(
                          width: Dimensions.width5 * 25,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 6,
                            horizontal: Dimensions.width5,
                          ),
                          decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: hintColor,
                          ),
                          child: isLoading
                              ? Center(
                                  child: CustomLoadong2(),
                                )
                              : MediumText(
                                  color: Colors.white,
                                  size: Dimensions.height2 * 8,
                                  text: '重置密碼發送',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
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
