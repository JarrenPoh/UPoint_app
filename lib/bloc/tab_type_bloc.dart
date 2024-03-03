// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';

import '../models/post_model.dart';

class TabTypeBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  late List<PostModel> _allPost;
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  List<String> typeList = [
    "全部",
    "體驗活動",
    "實習就業",
    "語言學習",
    "志工服務",
    "藝文欣賞",
    "DIY手作",
    "電腦軟體",
    "程式語言",
    "戶外活動",
    "系學會",
    "運動",
    "大自然",
    "文化交流",
    "營隊",
    "藝術人文",
  ];
  Map<String, ValueNotifier<int>> postLengthFromOrgan = {};

  TabTypeBloc(List<PostModel> allPost) {
    _allPost = allPost;
    filterOriginList();
  }

  void filterPostsByType(String text) {
    List<PostModel> _list =
        _allPost.where((doc) => doc.postType == text).toList();
    postListNotifier.value = _list;
    postListNotifier.notifyListeners();
  }

  onPageChanged(int v) {
    pageNotifier.value = v;
  }

  void filterOriginList() {
    postListNotifier.value = _allPost;
    postListNotifier.notifyListeners();
  }
}
