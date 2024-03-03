// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/post_model.dart';
import '../models/organizer_model.dart';

class TabOrganizerBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  ValueNotifier<List<OrganizerModel>> organListNotifier = ValueNotifier([]);
  Map<String, ValueNotifier<int>> postLengthFromOrgan = {};
  ValueNotifier<int> selectFilterNotifier = ValueNotifier(0);

  late List<PostModel> _allPost;

  TabOrganizerBloc(List<PostModel> allPost) {
    _allPost = allPost;
    _fetchOrganizers();
    _filterOriginList();
  }

  Future<List> _fetchOrganizers() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('organizers').get();
    debugPrint('找了${fetchPost.docs.length}個活動方');
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    organListNotifier.value =
        _list.map((e) => OrganizerModel.fromSnap(e)).toList();
    // 加入預設
    organListNotifier.value.insert(
      0,
      OrganizerModel(
        username: "全部",
        uid: "all",
        pic: "",
        email: "",
        phoneNumber: "",
        bio: "",
        unit: "",
        contact: "",
        postLength: 0,
      ),
    );
    organListNotifier.notifyListeners();

    //計算每個主辦方多少活動
    for (var doc in organListNotifier.value) {
      String tag = doc.uid;
      if (tag == "all") {
        postLengthFromOrgan['all'] = ValueNotifier<int>(0);
        postLengthFromOrgan['all']?.value = _allPost.length;
      } else {
        postLengthFromOrgan[tag] = ValueNotifier<int>(0);
        int count =
            _allPost.where((post) => post.organizerUid == doc.uid).length;
        postLengthFromOrgan[tag]?.value = count;
      }
    }
    return fetchPost.docs.toList();
  }

  void filterPostsByOrganizer(int index) {
    if (index == 0) {
      _filterOriginList();
    } else {
      String uid = organListNotifier.value[index].uid;
      List<PostModel> _list =
          _allPost.where((doc) => doc.organizerUid == uid).toList();
      postListNotifier.value = _list;
      postListNotifier.notifyListeners();
    }
    // 
    selectFilterNotifier.value = index;
    selectFilterNotifier.notifyListeners();
  }

  onPageChanged(int v) {
    pageNotifier.value = v;
  }

  void _filterOriginList() {
    postListNotifier.value = _allPost;
    postListNotifier.notifyListeners();
  }
}
