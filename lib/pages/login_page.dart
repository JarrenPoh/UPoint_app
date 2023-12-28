import 'package:flutter/material.dart';
import '../compontents/login_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function(int) onIconTapped;

  const LoginPage({
    super.key,
    required this.onIconTapped,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    late PageController _pageController = PageController();
    bool _isLoginPage = true;
    @override
    void initState() {
      super.initState();
      _pageController = PageController(initialPage: 0);
    }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }

    void _navigateToPage(int page) {
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    return Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          // controller: _scrollController,
          // scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 192, 192, 192)
                            .withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      // Login Page
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              loginPanel(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "  沒有帳號嗎？",
                                    style: TextStyle(color: primary),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isLoginPage = true;
                                        _navigateToPage(1);
                                      });
                                    },
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
                      ),

                      // Register Page
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              registerPanel(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "  已經有帳號了？",
                                    style: TextStyle(color: primary),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isLoginPage = true;
                                        _navigateToPage(0);
                                      });
                                    },
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class loginPanel extends StatelessWidget {
  const loginPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            //logo
            // Icon(
            //   Icons.person,
            //   size: 100,
            //   color: const Color.fromARGB(255, 65, 65, 65),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage("assets/Upoint.png"),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Text(
            //   "會員登入",
            //   style: TextStyle(
            //       color: hintColor,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 20),
            // ),

            // Text(
            //   "Upoint幫你解決活動大小事！",
            //   style: TextStyle(
            //       color: primary,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 16),
            // ),
            // SizedBox(height: 15),
            Textbox(
              prefixIcon: Icons.people_alt_rounded,
              obscureText: false,
              hintText: "電子郵件",
            ),

            SizedBox(height: 15),

            Textbox(
              prefixIcon: Icons.lock,
              obscureText: true,
              hintText: "密碼",
            ),

            SizedBox(height: 15),

            ElevatedButton(
              child: Text(
                '登入',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 44),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "忘記密碼>",
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "  或 使用以下方法登入  ",
                  style: TextStyle(color: primary),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sso_btn(imgPath: "assets/google.png"),
                  SizedBox(width: 25),
                  sso_btn(imgPath: "assets/apple.png"),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "  沒有帳號嗎？",
            //       style: TextStyle(color: primary),
            //     ),
            //     GestureDetector(
            //       onTap: () {},
            //       child: Text(
            //         "點此註冊！",
            //         style: TextStyle(
            //           color: hintColor,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class registerPanel extends StatelessWidget {
  const registerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            //logo
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage("assets/Upoint.png"),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Textbox(
              prefixIcon: Icons.people_alt_rounded,
              obscureText: false,
              hintText: "電子郵件",
            ),

            SizedBox(height: 15),

            Textbox(
              prefixIcon: Icons.lock,
              obscureText: true,
              hintText: "密碼",
            ),
            SizedBox(height: 15),
            Textbox(
              prefixIcon: Icons.lock,
              obscureText: true,
              hintText: "確認密碼",
            ),

            SizedBox(height: 15),

            ElevatedButton(
              child: Text(
                '註冊',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hintColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 44),
              ),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
