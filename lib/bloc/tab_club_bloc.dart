// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/widgets.dart';
import '../models/organizer_model.dart';
import '../models/post_model.dart';

class TabClubBloc {
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  late List<PostModel> _allPost;
  late List<OrganizerModel> organizerList;
  ValueNotifier<int> selectFilterNotifier = ValueNotifier(0);
   ValueNotifier<Map<String, dynamic>> countNotifier = ValueNotifier({});

  TabClubBloc(
    List<PostModel> allPost,
    List<OrganizerModel> _organizerList,
  ) {
    _allPost = allPost;
    organizerList = _organizerList;
    _countLen();
    postListNotifier.value = allPost;
    postListNotifier.notifyListeners();
  }

  _countLen() {
    Map<String, dynamic> map = {};
    for (OrganizerModel model in organizerList) {
      String id = model.uid;
      map[model.username] = id == "all"
          ? _allPost.length
          : _allPost.where((post) => post.organizerUid == id).length;
    }
    countNotifier .value = map;
    countNotifier.notifyListeners();
  }

  void filterPostsByOrganizer(int index) {
    if (index == 0) {
      postListNotifier.value = _allPost;
    } else {
      String uid = organizerList[index].uid;
      List<PostModel> _list =
          _allPost.where((doc) => doc.organizerUid == uid).toList();
      postListNotifier.value = _list;
    }
    postListNotifier.notifyListeners();
    //
    selectFilterNotifier.value = index;
    selectFilterNotifier.notifyListeners();
  }
}
