import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart' as model;
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpUser(email, auth.User currentUser) async {
    String res = 'some error occur';
    try {
      model.User user = model.User(
        email: email,
        uuid: currentUser.uid,
      );
      //上傳firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(user.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  //上傳貼文
  Future<String> uploadPost(PostModel post) async {
    String res = "some error occur";
    String? photoUrl;
    Uint8List? file;
    String postId = const Uuid().v1();
    try {
      file = await post.photos!.first;
      if (file != null) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('posts', file, true, postId);
        post.photos!.first = photoUrl;
        post.postId = postId;
        post.datePublished = DateTime.now();
      }
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
