import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    foregroundColor: Color(0xFF212121),
    backgroundColor: Color.fromARGB(255, 25, 25, 25),
  ),
  primaryColor: Color(0xFF0a2e3f),
  hintColor: Color(0xFFF8791D),
  scaffoldBackgroundColor: Color.fromARGB(255, 38, 38, 38),
  // dividerTheme: DividerThemeData(color: Colors.grey[400]),
  colorScheme: const ColorScheme.light(
    // background: Colors.black,
    onPrimary: Color(0xFF191919),
    onSecondary: Colors.white,
    background: Color(0xFF343434),
    onBackground: Color(0xFF9D9D9D),
    onError: Color(0xFFCACACA),
    onErrorContainer: Color(0xFFEAEAEA),
    onInverseSurface: Color(0xFFF8F8F8),
    onPrimaryContainer: Color(0xFFFFC169),

    primary: Colors.white54,
    secondary: Colors.white38,
    tertiary: Colors.white12,
    primaryContainer: Color.fromARGB(255, 65, 65, 65),
  ),
);
