// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../models/reward_tag_model.dart';

class TabRewardBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  ValueNotifier<List<RewardTagModel>> rewardTagListNotifier = ValueNotifier([]);
  Map<String, ValueNotifier<int>> postLengthFromReward = {};
  ValueNotifier<int> selectFilterNotifier = ValueNotifier(0);

  late List<PostModel> _allPost;

  TabRewardBloc(List<PostModel> allPost) {
    _allPost = allPost;
    _fetchRewardTags();
    _filterOriginList();
  }

  Future<List> _fetchRewardTags() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('rewardTags').get();
    debugPrint('找了${fetchPost.docs.length}個獎勵標籤');
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    rewardTagListNotifier.value =
        _list.map((e) => RewardTagModel.fromSnap(e)).toList();
    // 加入預設
    rewardTagListNotifier.value.insert(
      0,
      RewardTagModel(name: "全部", id: "all", pic: ""),
    );
    rewardTagListNotifier.notifyListeners();

    //計算每個獎勵標籤多少活動
    for (var doc in rewardTagListNotifier.value) {
      String tag = doc.id;
      if (tag == "all") {
        postLengthFromReward['all'] = ValueNotifier<int>(0);
        postLengthFromReward['all']?.value = _allPost.length;
      } else {
        postLengthFromReward[tag] = ValueNotifier<int>(0);
        int count = _allPost.where((post) => post.rewardTagId == tag).length;
        postLengthFromReward[tag]?.value = count;
      }
    }
    return fetchPost.docs.toList();
  }

  void filterPostsByReward(int index) {
    if (index == 0) {
      _filterOriginList();
    } else {
      String id = rewardTagListNotifier.value[index].id;
      List<PostModel> _list =
          _allPost.where((doc) => doc.rewardTagId == id).toList();
      postListNotifier.value = _list;
      postListNotifier.notifyListeners();
    }
    //
    selectFilterNotifier.value = index;
    selectFilterNotifier.notifyListeners();
  }

  void _filterOriginList() {
    postListNotifier.value = _allPost;
    postListNotifier.notifyListeners();
  }

  onPageChanged(int v) {
    pageNotifier.value = v;
  }
}
