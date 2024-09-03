// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/calendar_page.dart';
import 'package:upoint/pages/wishing_page.dart';

import '../globals/custom_messengers.dart';
import '../pages/login_page.dart';
import '../pages/rag_page.dart';

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
    // 創建 _featuredPost 和 _recommandPost 的副本
    _featuredPost = List.from(_allPost);
    _recommandPost = List.from(_allPost);

    init();
  }

  init() {
    sortFeatured();
    sortRecommand();
  }

  // featured
  sortFeatured() {
    _featuredPost.sort(
        (a, b) => (b.signFormsLength ?? 0).compareTo(a.signFormsLength ?? 0));
    int limit = 4;
    int end = _featuredPost.length < limit ? _featuredPost.length : limit;
    featuredPostValue.value["postList"] = _featuredPost.sublist(0, end);
    featuredPostValue.value["noMore"] = end == _featuredPost.length;
    featuredPostValue.notifyListeners();
  }

  moreFeatured() {
    int limit = 10;
    int start = (featuredPostValue.value["postList"] as List).length;
    int end = _featuredPost.length < start + limit
        ? _featuredPost.length
        : start + limit;
    (featuredPostValue.value["postList"] as List)
        .addAll(_featuredPost.sublist(start, end));
    featuredPostValue.value["noMore"] = end == _featuredPost.length;
    featuredPostValue.notifyListeners();
  }

  // recommand
  sortRecommand() {
    _recommandPost.shuffle();
    int limit = 4;
    int end = _recommandPost.length < limit ? _recommandPost.length : limit;
    recommandPostValue.value["postList"] = _recommandPost.sublist(0, end);
    recommandPostValue.value["noMore"] = end == _recommandPost.length;
    recommandPostValue.notifyListeners();
  }

  moreRecommand() {
    int limit = 10;
    int start = (recommandPostValue.value["postList"] as List).length;
    int end = _recommandPost.length < start + limit
        ? _recommandPost.length
        : start + limit;
    (recommandPostValue.value["postList"] as List)
        .addAll(_recommandPost.sublist(start, end));
    recommandPostValue.value["noMore"] = end == _recommandPost.length;
    recommandPostValue.notifyListeners();
  }

  onPageChanged(int v) {
    pageNotifier.value = v;
  }

  List<Map> buttonList({
    required BuildContext context,
    required UserModel? user,
  }) {
    return [
      {
        "title": "RAG智能小助理",
        "icon": "assets/robot.svg",
        "color": const Color(0xFFF8791D),
        "tap": () async {
          if (user == null) {
            String res = await Messenger.dialog(
              '請先登入',
              '您尚未登入帳戶',
              context,
            );
            if (res == "success") {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RagPage(
                    hero: "rag",
                    user: user,
                  );
                },
              ),
            );
          }
        },
      },
      {
        "title": "活動行事曆",
        "icon": "assets/calendar.svg",
        "color": Color(0xFFFF7D7D),
        "tap": () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const CalendarPage();
            },
          ));
        }
      },
      {
        "title": "功能許願池",
        "icon": "assets/fountain.svg",
        "color": Color(0xFF4EB7FF),
        "tap": () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const WishingPage();
            },
          ));
        }
      },
      {
        "title": "最新消息(尚未開放)",
        "icon": "assets/new-box.svg",
        "color": Color(0xFFD19EEA),
        "tap": null,
      },
      {
        "title": "APP更新資訊(尚未開放)",
        "icon": "assets/rocket-launch.svg",
        "color": Color(0xFFFFBC7D),
        "tap": null,
      },
      {
        "title": "工讀徵才(尚未開放)",
        "icon": "assets/briefcase-variant.svg",
        "color": Color(0xFF80CE88),
        "tap": null,
      },
      {
        "title": "(尚未開放)",
        "icon": "assets/bow-arrow.svg",
        "color": Color(0xFFFE9669),
        "tap": null,
      },
      {
        "title": "(尚未開放)",
        "icon": "assets/bow-arrow.svg",
        "color": Color(0xFFFE9669),
        "tap": null,
      },
    ];
  }
}
