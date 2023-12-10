import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
  ),
  primaryColor: Color(0xFF011e2d),
  hintColor: Color(0xFFffb307),
  scaffoldBackgroundColor: Color.fromRGBO(244, 243, 243, 1),
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: ColorScheme.light(
    // background: Color.fromRGBO(237, 237, 237, 1),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    primary: Colors.black54,
    secondary: Colors.black38,
    tertiary: Colors.black12,
    primaryContainer: Colors.grey.shade300,
  ),
);
