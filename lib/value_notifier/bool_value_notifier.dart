import 'package:flutter/material.dart';

class BoolValueNotifier extends ValueNotifier {
  BoolValueNotifier(super.value);

  void boolChange(bool) {
    value = bool;
  }
}