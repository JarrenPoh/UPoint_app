import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/navigation_container.dart';
import 'package:upoint/widgets/login/reset_password.dart';

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
  bool emptyEmail = false;
  bool emptyPassword = false;

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
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    if (_emailController.text.trim() == '') {
      setState(() {
        emptyEmail = true;
      });
    } else if (_passwordController.text.trim() == '') {
      setState(() {
        emptyPassword = true;
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
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationContainer(),
          ),
          (route) => false,
        );
      } else {
        await AuthMethods().signOut();
        // ignore: use_build_context_synchronously
        await Messenger.dialog(
          '如有問題，請回報官方:service.upoint@gmail.com',
          '你尚未驗證你的Gmail',
          context,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await AuthMethods().signOut();
      // ignore: use_build_context_synchronously
      Messenger.snackBar(context, "失敗", '$res ，請回報官方發現問題');
      // ignore: use_build_context_synchronously
      await Messenger.dialog(
        '發生錯誤',
        '如有問題，請回報官方:service.upoint@gmail.com',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
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
                        true,
                        Icons.lock,
                        "密碼",
                        emptyPassword,
                        _passwordController,
                      ),
                      SizedBox(height: Dimensions.height5 * 3),
                      ElevatedButton(
                        onPressed: () async {
                          loginUser();
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
