import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    foregroundColor: Color(0xFFF8F8F8),
    backgroundColor: Colors.white,
  ),
  primaryColor: Color(0xFF011e2d),
  hintColor: Color(0xFFF8791D),
  scaffoldBackgroundColor: Color.fromRGBO(244, 243, 243, 1),
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: ColorScheme.light(
    // background: Color.fromRGBO(237, 237, 237, 1),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    background: Color(0xFFF8F8F8),
    onBackground: Color(0xFFEAEAEA),
    onError: Color(0xFFCACACA),
    onErrorContainer: Color(0xFF9D9D9D),
    onInverseSurface: Color(0xFF343434),
    onPrimaryContainer: Color(0xFFFFF5E7),

    primary: Colors.black54,
    secondary: Colors.black38,
    tertiary: Colors.black12,
    primaryContainer: Colors.grey.shade300,
  ),
);
