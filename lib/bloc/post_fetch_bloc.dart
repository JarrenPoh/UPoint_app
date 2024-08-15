import 'package:flutter/material.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/models/post_model.dart';

class PostFetchBloc with ChangeNotifier {
  List<PostModel> _post = [];
  List<PostModel> get post => _post;

  fetch() async {
    if (_post.isEmpty) {
      debugPrint('拿了post from 資料');
      List<PostModel> _post = await FirestoreMethods().fetchAllPost();
      setpost(_post);
    }
    return _post;
    // notifyListeners();
  }

  Future<List<PostModel>?> update(PostModel update) async {
    debugPrint('更新post資料');
    int index = _post.indexWhere((e) => e.postId == update.postId);

    if (index != -1) {
      _post[index] = update; // 替換舊的 PostModel
      setpost(_post);
    } else {
      debugPrint('PostModel not found with postId: ${update.postId}');
    }
    return _post;
  }

  void setpost(List<PostModel> post) {
    _post = post;
    notifyListeners();
  }

  void clearpost() {
    _post = [];
    notifyListeners();
  }
}
