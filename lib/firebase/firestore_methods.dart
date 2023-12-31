import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart' as model;
import 'package:upoint/models/user_model.dart';
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
  Future<String> uploadPost(PostModel post, User user) async {
    String res = "some error occur";
    String? photoUrl;
    Uint8List? file;
    String postId = const Uuid().v1();
    try {
      file = await post.photos!.first;
      photoUrl = await StorageMethods()
          .uploadImageToStorage('posts', file!, true, postId);
      post.photos!.first = photoUrl;
      post.postId = postId;
      post.datePublished = DateTime.now();
      post.uid = user.uuid;
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //
  //更新貼文
  Future<String> updatePost(
    PostModel post,
    User user,
  ) async {
    String res = "some error occur";
    String? photoUrl;
    Uint8List? file;
    String postId = post.postId!;
    try {
      if (post.photos!.first is! String) {
        //新增
        file = await post.photos!.first;
        photoUrl = await StorageMethods()
            .uploadImageToStorage('posts', file!, true, postId);
        post.photos!.first = photoUrl;
      }
      await _firestore.collection('posts').doc(postId).update({
        "photos": [post.photos!.first],
        "organizer": post.organizer,
        "title": post.title,
        "date": post.date,
        "startTime": post.startTime,
        "endTime": post.endTime,
        "content": post.content,
        "reward": post.reward,
        "link": post.link,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
