// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:upoint/models/post_model.dart';

class TagHomeBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  late List<PostModel> _allPost;
  final ValueNotifier<Map> featuredPostValue = ValueNotifier({
    "postList": [],
    "noMore": false,
  });
  final ValueNotifier<Map> recommandPostValue = ValueNotifier({
    "postList": [],
    "noMore": false,
  });
  late List<PostModel> _featuredPost;
  late List<PostModel> _recommandPost;

  TagHomeBloc(List<PostModel> allPost) {
    _allPost = allPost;
    _featuredPost = _allPost;
    _recommandPost = _allPost;
    init();
  }
  init() {
    _recommandPost.shuffle();
    sortFeatured();
    sortRecommand();
  }

  // featured
  sortFeatured() {
    _featuredPost
        .sort((a, b) => b.signFormsLength!.compareTo(a.signFormsLength!));
    int limit = 4;
    int end = _featuredPost.length < limit ? _featuredPost.length : limit;
    featuredPostValue.value["postList"] = _featuredPost.sublist(0, end);
    featuredPostValue.notifyListeners();
  }

  moreFeatured() {
    int limit = 10;
    int end = _featuredPost.length < limit ? _featuredPost.length : limit;
    (featuredPostValue.value["postList"] as List)
        .addAll(_featuredPost.sublist(4, end));
    featuredPostValue.value["noMore"] = true;
    featuredPostValue.notifyListeners();
  }

  // recommand
  sortRecommand() {
    int limit = 4;
    int end = _recommandPost.length < limit ? _recommandPost.length : limit;
    recommandPostValue.value["postList"] = _recommandPost.sublist(0, end);
    recommandPostValue.notifyListeners();
  }

  moreRecommand() {
    int limit = 10;
    int end = _recommandPost.length < limit ? _recommandPost.length : limit;
    (recommandPostValue.value["postList"] as List)
        .addAll(_recommandPost.sublist(4, end));
    recommandPostValue.value["noMore"] = true;
    recommandPostValue.notifyListeners();
  }

  onPageChanged(int v) {
    pageNotifier.value = v;
  }

  List<Map> buttonList = [
    {
      "title": "功能許願池",
      "icon": "assets/fountain.svg",
      "color": Color(0xFFFFBC7D),
    },
    {
      "title": "最新消息(尚未開放)",
      "icon": "assets/new-box.svg",
      "color": Color(0xFFD19EEA),
    },
    {
      "title": "APP更新資訊(尚未開放)",
      "icon": "assets/rocket-launch.svg",
      "color": Color(0xFFFF7D7D),
    },
    {
      "title": "工讀徵才(尚未開放)",
      "icon": "assets/briefcase-variant.svg",
      "color": Color(0xFF80CE88),
    },
    {
      "title": "(尚未開放)",
      "icon": "assets/bow-arrow.svg",
      "color": Color(0xFFFE9669),
    },
    {
      "title": "(尚未開放)",
      "icon": "assets/bow-arrow.svg",
      "color": Color(0xFFFE9669),
    },
    {
      "title": "(尚未開放)",
      "icon": "assets/bow-arrow.svg",
      "color": Color(0xFFFE9669),
    },
  ];
}
