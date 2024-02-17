import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/reward_tag_model.dart';

class HomePageBloc with ChangeNotifier {
  // List<PostListBloc> postListBlocs = [];
  List tabList = ["找活動", "找獎勵"];
  late TabController tabController;
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  ValueNotifier<List<PostModel>> postList2Notifier = ValueNotifier([]);
  ValueNotifier<List<PostModel>> originList = ValueNotifier([]);
  ValueNotifier<List<OrganizerModel>> organListNotifier = ValueNotifier([]);
  ValueNotifier<List<RewardTagModel>> rewardTagListNotifier = ValueNotifier([]);
  final ValueNotifier<int> selectedOrganizerNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> selectedRewardTagNotifier = ValueNotifier<int>(0);
  Map<String, ValueNotifier<int>> postLengthFromOrgan = {};
  Map<String, ValueNotifier<int>> postLengthFromReward = {};

  HomePageBloc() {
    fetchPosts();
  }
  Future<List> fetchPosts() async {
    DateTime now = DateTime.now();
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('endDateTime',
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day - 5))
        .orderBy('endDateTime', descending: false)
        .get();
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    List<PostModel> _post = _list.map((e) => PostModel.fromSnap(e)).toList();
    print('找了${fetchPost.docs.length}則貼文');
    postListNotifier.value = _post; //activity_body用的
    postList2Notifier.value = _post;
    originList.value = _post; //最願使數據要用的
    postListNotifier.notifyListeners();
    fetchOrganizers();
    fetchRewardTags();
    return fetchPost.docs.toList();
  }

  Future<PostModel> fetchPostById(postId) async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance
            .collection('posts')
            .where(
              'postId',
              isEqualTo: postId,
            )
            .get();
    PostModel _post = PostModel.fromSnap(fetchPost.docs.toList().first);
    return _post;
  }

  void filterOriginList(int index) {
    if (index == 0) {
      postListNotifier.value = originList.value;
      postListNotifier.notifyListeners();
    } else {
      postList2Notifier.value = originList.value;
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
    List<PostModel> _list =
        originList.value.where((doc) => doc.organizerUid == uid).toList();
    postListNotifier.value = _list;
    postListNotifier.notifyListeners();
  }

  Future<List> fetchOrganizers() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('organizers').get();
    print('找了${fetchPost.docs.length}個活動方');
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    organListNotifier.value =
        _list.map((e) => OrganizerModel.fromSnap(e)).toList();
    organListNotifier.notifyListeners();

    //計算每個主辦方多少活動
    for (var doc in organListNotifier.value) {
      String tag = doc.uid;
      postLengthFromOrgan[tag] = ValueNotifier<int>(0);
      int count =
          originList.value.where((post) => post.organizerUid == doc.uid).length;
      postLengthFromOrgan[tag]?.value = count;
    }
    postLengthFromOrgan['all'] = ValueNotifier<int>(0);
    postLengthFromOrgan['all']?.value = (originList.value as List).length;
    return fetchPost.docs.toList();
  }

  /*  reward body  */
  void filterPostsByReward(id) {
    List<PostModel> _list = originList.value 
        .where((doc) => doc.rewardTagId == id)
        .toList();
    postList2Notifier.value = _list;
    postList2Notifier.notifyListeners();
  }

  Future<List> fetchRewardTags() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('rewardTags').get();
    print('找了${fetchPost.docs.length}個獎勵標籤');
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    rewardTagListNotifier.value =
        _list.map((e) => RewardTagModel.fromSnap(e)).toList();
    rewardTagListNotifier.notifyListeners();

    //計算每個獎勵標籤多少活動
    for (var doc in rewardTagListNotifier.value) {
      String tag = doc.id;
      postLengthFromReward[tag] = ValueNotifier<int>(0);
      int count = originList.value
          .where((post) => post.rewardTagId == tag)
          .length;
      postLengthFromReward[tag]?.value = count;
    }
    postLengthFromReward['all'] = ValueNotifier<int>(0);
    postLengthFromReward['all']?.value = (originList.value as List).length;
    return fetchPost.docs.toList();
  }
}
