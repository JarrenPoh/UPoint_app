import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/value_notifier/list_value_notifier.dart';

class HomePageBloc with ChangeNotifier {
  // List<PostListBloc> postListBlocs = [];
  List tabList = ["找活動", "找獎勵"];
  late TabController tabController;
  ListValueNotifier postListNotifier = ListValueNotifier([]);
  ListValueNotifier postList2Notifier = ListValueNotifier([]);
  ListValueNotifier originList = ListValueNotifier([]);
  ListValueNotifier organListNotifier = ListValueNotifier([]);
  ListValueNotifier rewardTagListNotifier = ListValueNotifier([]);
  final ValueNotifier<int> selectedOrganizerNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> selectedRewardTagNotifier = ValueNotifier<int>(0);
  Map<String, ValueNotifier<int>> postLengthFromOrgan = {};
  Map<String, ValueNotifier<int>> postLengthFromReward = {};

  HomePageBloc() {
    fetchPosts();
  }
  Future<List> fetchPosts() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('datePublished',
            isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .orderBy('datePublished', descending: true)
        .get();
    print('找了${fetchPost.docs.length}則貼文');
    postListNotifier.addList(fetchPost.docs.toList()); //activity_body用的
    postList2Notifier.addList(fetchPost.docs.toList());
    originList.addList(fetchPost.docs.toList()); //最願使數據要用的
    postListNotifier.notifyListeners();
    fetchOrganizers();
    fetchRewardTags();
    return fetchPost.docs.toList();
  }

  void filterOriginList(int index) {
    if (index == 0) {
      postListNotifier.addList(originList.value);
      postListNotifier.notifyListeners();
    } else {
      postList2Notifier.addList(originList.value);
      postList2Notifier.notifyListeners();
    }
  }

  Future<void> refreshBody(int index) async {
    if (index == 0) {
      await fetchPosts();
      selectedOrganizerNotifier.value = 0;
    } else {
      await fetchPosts();
      selectedRewardTagNotifier.value = 0;
    }
  }

  /*  activity body  */

  void filterPostsByOrganizer(uid) {
    List _list = (originList.value as List)
        .where((doc) => doc.data()['uid'] == uid)
        .toList();
    postListNotifier.addList(_list);
    postListNotifier.notifyListeners();
  }

  Future<List> fetchOrganizers() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('organizers').get();
    print('找了${fetchPost.docs.length}個活動方');
    organListNotifier.addList(fetchPost.docs.toList());
    organListNotifier.notifyListeners();

    //計算每個主辦方多少活動
    for (var doc in fetchPost.docs) {
      String tag = doc['uid'];
      postLengthFromOrgan[tag] = ValueNotifier<int>(0);
      int count = (originList.value as List)
          .where((post) => post['uid'] == doc.data()['uid'])
          .length;
      postLengthFromOrgan[tag]?.value = count;
    }
    postLengthFromOrgan['all'] = ValueNotifier<int>(0);
    postLengthFromOrgan['all']?.value = (originList.value as List).length;
    return fetchPost.docs.toList();
  }

  /*  reward body  */
  void filterPostsByReward(id) {
    List _list = (originList.value as List)
        .where((doc) => doc.data()['rewardTagId'] == id)
        .toList();
    postList2Notifier.addList(_list);
    postList2Notifier.notifyListeners();
  }

  Future<List> fetchRewardTags() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('rewardTags').get();
    print('找了${fetchPost.docs.length}個獎勵標籤');
    rewardTagListNotifier.addList(fetchPost.docs.toList());
    rewardTagListNotifier.notifyListeners();

    //計算每個獎勵標籤多少活動
    for (var doc in fetchPost.docs) {
      String tag = doc['id'];
      postLengthFromReward[tag] = ValueNotifier<int>(0);
      int count = (originList.value as List)
          .where((post) => post['rewardTagId'] == doc.data()['id'])
          .length;
      postLengthFromReward[tag]?.value = count;
    }
    postLengthFromReward['all'] = ValueNotifier<int>(0);
    postLengthFromReward['all']?.value = (originList.value as List).length;
    return fetchPost.docs.toList();
  }
}
