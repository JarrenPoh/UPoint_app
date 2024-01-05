import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/models/organizer_model.dart';
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
  Future<String> uploadPost(PostModel post, OrganModel organizer) async {
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
      post.uid = organizer.uid;
      post.pic = organizer.pic;
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //送出報名表單（改現有post裡面的signList）
  Future<String> sentSignForm(
    PostModel post,
    Map postMap,
    User user,
    Map userMap,
  ) async {
    String res = 'some error occur';
    try {
      //捕獲最新表單
      QuerySnapshot<Map<String, dynamic>> fetchPost =
          await FirebaseFirestore.instance
              .collection('posts')
              .where(
                'postId',
                isEqualTo: post.postId,
              )
              .get();
      PostModel _post = PostModel.fromSnap(fetchPost.docs.toList().first);
      List signList = _post.signList ?? [];
      signList.add(postMap);
      //更新貼文
      await _firestore.collection('posts').doc(post.postId).update({
        "signList": signList,
      });
      //更新用戶
      signList = user.signList ?? [];
      signList.add(userMap);
      await _firestore.collection('users').doc(user.uuid).update({
        "signList": signList,
      });
      await uploadToInbox(
        user.uuid,
        post.organizer!,
        post.pic,
        "你已成功報名『${post.title}』，請記得出席 ${post.organizer}",
        Uri(
          pathSegments: ['activity'],
          queryParameters: {"id": post.postId!},
        ).toString(),
      );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //修改個資
  Future<String> updateProfile(
    String uuid,
    Map<Object, Object?> userMap,
  ) async {
    String res = 'some error occur';
    try {
      //更新用戶
      await _firestore.collection('users').doc(uuid).update(userMap);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //
  //更新貼文
  Future<String> updatePost(PostModel post) async {
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

  //更新照片
  Future<String> updatePic(pic, bool isOrganizer, String doc) async {
    String _picUrl = '';
    String collection = isOrganizer ? 'organizers' : 'users';
    try {
      _picUrl = await StorageMethods()
          .uploadImageToStorage(collection, pic, false, null);

      await _firestore.collection(collection).doc(doc).update({
        "pic": _picUrl,
      });
    } catch (err) {}
    return _picUrl;
  }

  //發送Notification
  Future<void> uploadToInbox(
    String targetUserId,
    String name,
    String? pic,
    String text,
    String url,
  ) async {
    try {
      String inboxId = const Uuid().v1();
      //儲存通知
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .collection('inboxs')
          .doc(inboxId)
          .set({
        'inboxId': inboxId,
        'datePublished': DateTime.now(),
        'pic': pic,
        'name': name,
        'text': text,
        'url': url,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
