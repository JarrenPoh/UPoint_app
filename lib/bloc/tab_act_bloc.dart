// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/filter_model.dart';
import '../models/organizer_model.dart';
import '../models/post_model.dart';
import '../models/reward_tag_model.dart';

class TabActBloc {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  late List<PostModel> _allPost;
  ValueNotifier<List<PostModel>> postListNotifier = ValueNotifier([]);
  Map<String, ValueNotifier<int>> postLengthFromType = {};
  late List<OrganizerModel> organizerList;
  final List<String> _tyeList = [
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
  late List<FilterModel> filterList;

  TabActBloc(List<PostModel> allPost, List<OrganizerModel> _organizerList) {
    _allPost = allPost;
    organizerList = _organizerList;
    postListNotifier.value = allPost;
    postListNotifier.notifyListeners();

    filterList = [
      FilterModel(
        index: "organizer",
        future: _fetchOrganizers,
        needFuture: true,
        filter: "全部",
        list: organizerList,
        count: <String, int>{},
        type: ActFilterType.ORGANIZER,
        hintText: "主辦單位",
      ),
      FilterModel(
        index: "type",
        future: null,
        needFuture: false,
        filter: "全部",
        list: _tyeList,
        count: <String, int>{},
        type: ActFilterType.TYPE,
        hintText: "活動類別",
      ),
      FilterModel(
        index: "reward",
        future: _fetchRewardTags,
        needFuture: true,
        filter: "全部",
        list: <RewardTagModel>[],
        count: <String, int>{},
        type: ActFilterType.REWARD,
        hintText: "活動獎勵",
      ),
    ];

    // 初始化時計算 count
    for (var filter in filterList) {
      if (!filter.needFuture) {
        _countLen(filter);
      }
    }
  }

  Future<Map<String, dynamic>> _fetchOrganizers() async {
    FilterModel filter =
        filterList.firstWhere((e) => e.type == ActFilterType.ORGANIZER);
    filter.count.clear();
    filter.count
        .addAll({for (var organizer in filter.list) organizer.username: 0});
    _countLen(filter);

    // 照著 count 的大小排序
    filter.list.sort((a, b) => filter.count[b.username]!.compareTo(filter.count[a.username]!));

    return {
      "list": filter.list.map((e) => e.username).toList(),
      "count": filter.count,
    };
  }

  Future<Map<String, dynamic>> _fetchRewardTags() async {
    FilterModel filter =
        filterList.firstWhere((e) => e.type == ActFilterType.REWARD);
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('rewardTags').get();
    debugPrint('找了${fetchPost.docs.length}個獎勵標籤');
    List<QueryDocumentSnapshot> docs = fetchPost.docs.toList();
    List<RewardTagModel> rewardList =
        docs.map((e) => RewardTagModel.fromSnap(e)).toList();
    rewardList.insert(0, RewardTagModel(name: "全部", id: "all", pic: ""));
    filter.list.clear();
    filter.list.addAll(rewardList);
    filter.count.clear();
    filter.count.addAll({for (var reward in rewardList) reward.name: 0});
    _countLen(filter);

    // 照著 count 的大小排序
    filter.list.sort((a, b) => filter.count[b.name]!.compareTo(filter.count[a.name]!));

    return {
      "list": filter.list.map((e) => e.name).toList(),
      "count": filter.count,
    };
  }

  void _countLen(FilterModel filter) {
    if (filter.type == ActFilterType.ORGANIZER) {
      // 主辦單位
      for (var organizer in filter.list) {
        String id = organizer.uid;
        filter.count[organizer.username] = id == "all"
            ? _allPost.length
            : _allPost.where((post) => post.organizerUid == id).length;
      }
    } else if (filter.type == ActFilterType.TYPE) {
      // 活動類型
      filter.count.clear();
      filter.count.addAll({for (var type in filter.list) type: 0});
      for (var type in filter.list) {
        filter.count[type] = type == "全部"
            ? _allPost.length
            : _allPost.where((post) => post.postType == type).length;
      }
    } else if (filter.type == ActFilterType.REWARD) {
      // 獎勵標籤
      for (var reward in filter.list) {
        String id = reward.id;
        filter.count[reward.name] = id == "all"
            ? _allPost.length
            : _allPost.where((post) => post.rewardTagId == id).length;
      }
    }
  }

  void filter() {
    List<PostModel> _list = _allPost;
    // 主辦單位
    FilterModel organizerFilter =
        filterList.firstWhere((e) => e.type == ActFilterType.ORGANIZER);
    String _organizerFilterText = organizerFilter.filter;
    if (_organizerFilterText != "全部") {
      OrganizerModel model = organizerFilter.list
          .firstWhere((element) => element.username == _organizerFilterText);
      _list = _list.where((doc) => doc.organizerUid == model.uid).toList();
    }
    // 活動類別
    FilterModel typeFilter =
        filterList.firstWhere((e) => e.type == ActFilterType.TYPE);
    String _typeFilterText = typeFilter.filter;
    if (_typeFilterText != "全部") {
      _list = _list.where((doc) => doc.postType == _typeFilterText).toList();
    }
    // 獎勵標籤
    FilterModel rewardFilter =
        filterList.firstWhere((e) => e.type == ActFilterType.REWARD);
    String _rewardFilterText = rewardFilter.filter;
    if (_rewardFilterText != "全部") {
      _list = _list.where((doc) => doc.reward == _rewardFilterText).toList();
    }
    postListNotifier.value = _list;
    postListNotifier.notifyListeners();
  }
}