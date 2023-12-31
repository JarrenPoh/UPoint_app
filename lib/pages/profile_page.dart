import 'dart:async';

import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  User? _user;
  late StreamSubscription<User?> _authSubscription;
  void listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('用户已登出');
      } else {
        print('用户已登录: ${user.email}');
      }
      setState(() {
        _user = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenToAuthChanges();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            _user == null
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        uri: Uri(pathSegments: ['profile']),
                      ),
                    ),
                    (Route<dynamic> route) => false, // 不保留任何旧路由
                  )
                : AuthMethods().signOut();
          },
          child: MediumText(
            color: onSecondary,
            size: 16,
            text: _user == null ? "登入" : '登出',
          ),
        ),
      ),
    );
  }
}
