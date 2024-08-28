// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/cupertino.dart';
import '../models/post_model.dart';

class CalendarBloc {
  List<PostModel> post = [];
  Map<DateTime, List<PostModel>> events = {};
  DateTime focusedDay = DateTime.now();

  CalendarBloc({required List<PostModel> p}) {
    post = p;
    events = PostModel.toEvent(post);
  }

  ValueNotifier<List<PostModel>> bodyListNotifier = ValueNotifier([]);

  onDaySelected(List<PostModel>? _list) {
    bodyListNotifier.value = _list ?? [];
    bodyListNotifier.notifyListeners();
  }
}
