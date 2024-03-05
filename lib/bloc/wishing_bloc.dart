// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/models/wish_model.dart';
import 'package:uuid/uuid.dart';

import '../globals/custom_messengers.dart';
import '../pages/login_page.dart';

class WishingBloc {
  String img =
      "https://firebasestorage.googleapis.com/v0/b/upoint-d4fc3.appspot.com/o/posts%2FtvRc40ekeeY5UTiPist8qVRm0m92%2Ff84eca80-6de0-1eee-98f0-275a877a743d?alt=media&token=0db32e9c-35f9-4073-8cf5-341040323b7b";
  final ScrollController scrollController = ScrollController();
  ValueNotifier<Map> wishNotifier =
      ValueNotifier({"post": <WishModel>[], "noMore": false});
  ValueNotifier<bool> isLikeNotifier = ValueNotifier(false);
  bool _noMore = false;
  WishingBloc() {
    _fetchWishes();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          _noMore == false) {
        await _fetchWishes();
      }
    });
  }
  DocumentSnapshot? lastDoc;
  final _search = FirebaseFirestore.instance
      .collection('wishes')
      .orderBy('rateList', descending: true);

  _fetchWishes() async {
    int limit = 8;
    QuerySnapshot fetchPost;
    if (lastDoc == null) {
      // 第一次請求
      fetchPost = await _search.limit(limit).get();
    } else {
      // 之後的請求
      fetchPost = await _search.startAfterDocument(lastDoc!).limit(limit).get();
    }
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    debugPrint("找了：${_list.length}");
    if (_list.isEmpty) {
      // 沒貼文了
      _noMore = true;
    } else {
      // 還有貼文
      List<WishModel> _post = _list.map((e) => WishModel.fromMap(e)).toList();
      (wishNotifier.value["post"] as List).addAll(_post);
      lastDoc = fetchPost.docs.last;
      _noMore = false;
    }
    wishNotifier.value["noMore"] = _noMore;
    wishNotifier.notifyListeners();
  }

  onRefresh() {
    lastDoc = null;
    _noMore = false;
    wishNotifier.value["post"] = <WishModel>[];
    wishNotifier.value["noMore"] = _noMore;
    wishNotifier.notifyListeners();
  }

  tabWish(BuildContext context, UserModel? user) async {
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
      Map _map = await Messenger.wishDialog(context);
      if (_map["status"] == "success") {
        //以下尚未填過
        String wishId = const Uuid().v1();
        WishModel wish = WishModel(
          datePublished: DateTime.now(),
          content: _map["text"],
          wishId: wishId,
          uid: user.uuid,
          rateList: [],
        );
        String res = await FirestoreMethods().uploadWishing(wish);
        if (res == "success") {
          Messenger.snackBar(context, "發送成功", "謝謝你的支持");
          Timestamp t = Timestamp.fromDate(wish.datePublished);
          wish.datePublished = t;
          wishNotifier.value["post"].insert(0, wish);
          wishNotifier.notifyListeners();
        } else {
          Messenger.snackBar(
            context,
            "發送失敗",
            "發送失敗，請洽詢官方發現問題：service.upoint@gmail.com",
          );
          Messenger.dialog(
              "發送失敗", "發送失敗，請洽詢官方發現問題：service.upoint@gmail.com", context);
        }
      } else {
        print("failed");
      }
    }
  }

  likeWish(BuildContext context, UserModel user, WishModel wish) async {
    await FirestoreMethods().likeWishing(user, wish);
  }
}
