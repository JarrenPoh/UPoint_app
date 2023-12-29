import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/login/login_panel.dart';
import 'package:upoint/widgets/login/register_panel.dart';

class LoginPage extends StatefulWidget {
  final Uri uri;
  const LoginPage({
    super.key,
    required this.uri,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PageController _pageController = PageController();
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

  @override
  Widget build(BuildContext context) {
    // Color primary = Theme.of(context).colorScheme.primary;
    // Color hintColor = Theme.of(context).hintColor;
    // Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Scaffold(
        backgroundColor: appBarColor,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width5 * 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            // Login Page
                            LoginPanel(
                              onTap: () => _navigateToPage(1),
                              uri: widget.uri,
                            ),
                            // Register Page
                            RegisterPanel(
                              onTap: () => _navigateToPage(0),
                              uri: widget.uri,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
