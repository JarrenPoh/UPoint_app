import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upoint/navigation_container.dart';
import 'package:upoint/theme/dark_theme.dart';
import 'package:upoint/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const NavigationContainer(),
    );
  }
}
//hgjg
