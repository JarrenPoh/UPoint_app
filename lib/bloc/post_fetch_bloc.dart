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

  void setpost(List<PostModel> post) {
    _post = post;
    notifyListeners();
  }

  void clearpost() {
    _post = [];
    notifyListeners();
  }
}
