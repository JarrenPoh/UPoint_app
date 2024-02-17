import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 25, 25, 25),
  ),
  primaryColor: Color(0xFF0a2e3f),
  hintColor: Color(0xFFF8791D),
  scaffoldBackgroundColor: Color.fromARGB(255, 38, 38, 38),
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: const ColorScheme.light(
    // background: Colors.black,
    onPrimary: Color.fromARGB(255, 19, 19, 19),
    onSecondary: Colors.white,
    primary: Colors.white54,
    secondary: Colors.white38,
    tertiary: Colors.white12,
    primaryContainer: Color.fromARGB(255, 65, 65, 65),
  ),
);