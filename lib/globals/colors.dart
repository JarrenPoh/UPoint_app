import 'package:flutter/material.dart';

class CColor {
  final Color white;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color black;
  final Color primary;
  final Color second;
  final Color color;
  final Color sub;
  final Color div;
  final Color card;
  final Color bgColor;

  CColor({
    required this.white,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.black,
    required this.primary,
    required this.second,
    required this.color,
    required this.sub,
    required this.div,
    required this.card,
    required this.bgColor,
  });

  factory CColor.of(BuildContext context) {
    return CColor(
      white: Theme.of(context).colorScheme.onPrimary,
      grey100: Theme.of(context).colorScheme.background,
      grey200: Theme.of(context).colorScheme.onBackground,
      grey300: Theme.of(context).colorScheme.onError,
      grey400: Theme.of(context).colorScheme.onErrorContainer,
      grey500: Theme.of(context).colorScheme.onInverseSurface,
      black: Theme.of(context).colorScheme.onSecondary,
      primary: const Color(0xFFF8791D),
      second: const Color(0xFFFB9348),
      color: const Color(0xFFFF9F18),
      sub: Theme.of(context).colorScheme.onPrimaryContainer,
      div: Theme.of(context).appBarTheme.foregroundColor!,
      card: Theme.of(context).cardTheme.color!,
      bgColor: Theme.of(context).appBarTheme.backgroundColor!,
    );
  }
}
