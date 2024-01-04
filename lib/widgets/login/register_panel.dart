import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/custom_dialog.dart';
import 'package:upoint/widgets/custom_snackBar.dart';
import 'package:upoint/widgets/login/verfify_email.dart';

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
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyConfirm = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (emptyEmail == true) {
        setState(() {
          _emailController.text.trim() == ''
              ? emptyEmail = true
              : emptyEmail = false;
        });
      }
    });
    _passwordController.addListener(() {
      if (emptyPassword == true) {
        setState(() {
          _passwordController.text.trim() == ''
              ? emptyPassword = true
              : emptyPassword = false;
        });
      }
    });
    _confirmController.addListener(() {
      if (emptyConfirm == true) {
        setState(() {
          _confirmController.text.trim() == ''
              ? emptyConfirm = true
              : emptyConfirm = false;
        });
      }
    });
  }

  void signUpUser() async {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    if (_emailController.text.trim() == '') {
      setState(() {
        emptyEmail = true;
      });
    } else if (_passwordController.text.trim() == '') {
      setState(() {
        emptyPassword = true;
      });
    } else if (_confirmController.text.trim() == '') {
      setState(() {
        emptyConfirm = true;
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
          Navigator.of(context).push(
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
          showCustomSnackbar("失敗", res.toString() + ' ，請回報官方發現問題', context);
          CustomDialog(
            context,
            '如有問題，請回報官方:service.upoint@gmail.com',
            res,
            onSecondary,
            onSecondary,
            () {
              Navigator.pop(context);
            },
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
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height5 * 4),
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
                      textWidget(
                        false,
                        Icons.people_alt_rounded,
                        "電子郵件",
                        emptyEmail,
                        _emailController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      textWidget(
                        false,
                        Icons.lock,
                        "密碼",
                        emptyPassword,
                        _passwordController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      textWidget(
                        true,
                        Icons.lock,
                        "確認密碼",
                        emptyConfirm,
                        _confirmController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      ElevatedButton(
                        onPressed: () {
                          signUpUser();
                        },
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
          isLoading
              ? Container(
                  height: Dimensions.height5 * 14,
                  width: Dimensions.width5 * 14,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: onPrimary,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget textWidget(obscureText, prefixIcon, hintText, emptyInput, controller) {
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
        errorText: emptyInput ? '不可為空' : null,
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
