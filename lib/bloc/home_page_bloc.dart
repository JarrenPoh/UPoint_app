import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/value_notifier/list_value_notifier.dart';

class HomePageBloc with ChangeNotifier {
  // List<PostListBloc> postListBlocs = [];
  List tabList = ["找活動", "找獎勵"];
  late TabController tabController;
  ListValueNotifier postListNotifier = ListValueNotifier([]);
  ListValueNotifier originList = ListValueNotifier([]);
  ListValueNotifier organListNotifier = ListValueNotifier([]);
  final ValueNotifier<int> selectedNotifier = ValueNotifier<int>(0);
  HomePageBloc() {
    fetchPosts();
    fetchOrganizers();
  }

  Future<List> fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .get();
    print('找了${fetchPost.docs.length}則貼文');
    postListNotifier.addList(fetchPost.docs.toList());
    originList.addList(fetchPost.docs.toList());
    postListNotifier.notifyListeners();
    return fetchPost.docs.toList();
  }

  void filterPostsByOrganizer(uid) {
    List _list = (originList.value as List)
        .where((doc) => doc.data()['uid'] == uid)
        .toList();
    postListNotifier.addList(_list);
    postListNotifier.notifyListeners();
  }

  void filterOriginList() {
    postListNotifier.addList(originList.value);
    postListNotifier.notifyListeners();
  }

  Future<List> fetchOrganizers() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance.collection('organizers').get();
    print('找了${fetchPost.docs.length}個活動方');
    organListNotifier.addList(fetchPost.docs.toList());
    organListNotifier.notifyListeners();
    return fetchPost.docs.toList();
  }

  // void createBlocs(int length) {
  //   for (int index = 0; index < length; index++) {
  //     final bloc = PostListBloc('homeBloc${index.toString()}'); // 創建一個新的 PostListBloc
  //     postListBlocs.add(bloc); // 將新的 PostListBloc 添加到列表中
  //   }
  // }
}
