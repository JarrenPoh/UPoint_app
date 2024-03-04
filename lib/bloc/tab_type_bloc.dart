// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';

import '../models/post_model.dart';

class TabTypeBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  late List<PostModel> _allPost;
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  Map<String, ValueNotifier<int>> postLengthFromType = {};
  List<String> typeList = [
    "全部",
    "演講講座",
    "實習就業",
    "志工服務",
    "藝術人文",
    "資訊科技",
    "學習成長",
    "戶外探索",
    "競賽活動",
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
    //計算每個獎勵標籤多少活動
    for (var type in typeList) {
      if (type == "全部") {
        postLengthFromType['全部'] = ValueNotifier<int>(0);
        postLengthFromType['全部']?.value = _allPost.length;
      } else {
        postLengthFromType[type] = ValueNotifier<int>(0);
        int count = _allPost.where((post) => post.postType == type).length;
        postLengthFromType[type]?.value = count;
      }
      postLengthFromType['全部']?.notifyListeners();
    }
  }
}
