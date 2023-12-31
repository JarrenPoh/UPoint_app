import 'package:flutter/material.dart';

class ListValueNotifier extends ValueNotifier {
  ListValueNotifier(super.value);

  addList(list) {
    value = list;
  }


}