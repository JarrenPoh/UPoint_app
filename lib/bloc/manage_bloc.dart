import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:upoint/value_notifier/list_value_notifier.dart';

class ManageBloc extends ChangeNotifier {
  ListValueNotifier postListNotifier = ListValueNotifier([]);
  ManageBloc(uid) {
    fetchPosts(uid);
  }
  Future<List> fetchPosts(uid) async {
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .get();
    print('找了${fetchPost.docs.length}則貼文');
    List _list = fetchPost.docs.toList();
    _list.sort((a, b) {
      DateTime dateA = (a['date'] as Timestamp).toDate();
      DateTime dateB = (b['date'] as Timestamp).toDate();
      return dateB.compareTo(dateA); 
    });
    postListNotifier.addList(_list);
    postListNotifier.notifyListeners();
    return _list;
  }

  Future<List> updatePost(postId) async {
    List _list = [];
    int i = (postListNotifier.value as List)
        .indexWhere((map) => map['postId'] == postId);
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('postId', isEqualTo: postId)
        .get();
    postListNotifier.value[i] = fetchPost.docs.first;
    _list = postListNotifier.value;

    postListNotifier.addList(_list);
    postListNotifier.notifyListeners();
    return _list;
  }
}
