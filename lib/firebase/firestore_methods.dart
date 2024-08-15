import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/globals/user_simple_preference.dart';
import 'package:upoint/models/ad_model.dart';
import 'package:upoint/models/announce_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/sign_form_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../globals/global.dart';
import '../models/wish_model.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpUser(email, auth.User currentUser) async {
    String res = 'some error occur';
    try {
      String? fcmToken = UserSimplePreference.getFcmToken();
      UserModel user = UserModel(
        email: email,
        uuid: currentUser.uid,
        fcmToken: fcmToken == null ? null : [fcmToken],
      );
      //上傳firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(user.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
      debugPrint(res);
    }
    return res;
  }

  //上傳報名表單
  Future<String> uploadSignForm(
    UserModel user,
    PostModel post,
    String getSignFormBody,
  ) async {
    String res = "some error occur";
    String signFormId = const Uuid().v1();
    List _signList = user.signList ?? [];
    String postId = post.postId!;
    try {
      //以下尚未填過
      SignFormModel signForm = SignFormModel(
        uuid: user.uuid,
        fcmToken: user.fcmToken,
        body: getSignFormBody,
        datePublished: DateTime.now(),
        signFormId: signFormId,
      );
      // 上傳到posts collection下的signForms collection
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('signForms')
          .doc(signFormId)
          .set(signForm.toJson());
      // 幫posts文件的signFormsLength加一
      await _firestore.collection('posts').doc(postId).update({
        "signFormsLength": FieldValue.increment(1),
      });
      // 幫users文件的signList加上postId
      _signList.add(postId);
      await _firestore.collection('users').doc(user.uuid).update({
        "signList": _signList,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
      debugPrint('err${err.toString()}');
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

  //更新照片
  Future<String> updatePic(pic, String doc) async {
    String _picUrl = '';
    try {
      _picUrl = await StorageMethods()
          .uploadImageToStorage('users', pic, false, null);

      await _firestore.collection('users').doc(doc).update({
        "pic": _picUrl,
      });
    } catch (err) {}
    return _picUrl;
  }

  //找一篇文
  Future<PostModel> fetchPostById(postId) async {
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance
            .collection('posts')
            .where(
              'postId',
              isEqualTo: postId,
            )
            .get();
    PostModel _post = PostModel.fromSnap(fetchPost.docs.toList().first);

    return _post;
  }

  //找指定處室文
  Future<List<PostModel>> fetchOrganizePost(
      {required String organizerUid}) async {
    print("搜尋指定單位貼文");
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance
            .collection('posts')
            .where(
              'organizerUid',
              isEqualTo: organizerUid,
            )
            .get();
    // 獲取文檔列表並排序
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
        fetchPost.docs.toList()
          ..sort((a, b) {
            Timestamp timeA = a['datePublished'];
            Timestamp timeB = b['datePublished'];
            return timeB.compareTo(timeA); // 從新到舊排序
          });
    List<PostModel> _post =
        sortedDocs.map((e) => PostModel.fromSnap(e)).toList();
    return _post;
  }

  //找指定處試公告
  Future<List<AnnounceModel>> fetchOrganizeAnnounce(
      {required String organizerUid}) async {
    print("搜尋指定單位公告");
    QuerySnapshot<Map<String, dynamic>> fetchPost =
        await FirebaseFirestore.instance
            .collection('announcements')
            .where(
              'organizerUid',
              isEqualTo: organizerUid,
            )
            .get();
    // 獲取文檔列表並排序
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
        fetchPost.docs.toList()
          ..sort((a, b) {
            Timestamp timeA = a['datePublished'];
            Timestamp timeB = b['datePublished'];
            return timeB.compareTo(timeA); // 從新到舊排序
          });
    List<AnnounceModel> announcements =
        sortedDocs.map((e) => AnnounceModel.fromSnap(e)).toList();
    return announcements;
  }

  // 找所有文
  Future<List<PostModel>> fetchAllPost() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('endDateTime', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('endDateTime', descending: false)
        .get();
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    List<PostModel> _post = _list.map((e) => PostModel.fromSnap(e)).toList();
    if (!isDebugging) {
      _post.removeWhere((e) => debugId.contains(e.organizerUid));
      _post.removeWhere((e) => e.isVisible == false);
    }
    // 按 startDateTime 進行排序，最近的日期放在前面
    _post.sort(
        (a, b) => (b.startDateTime as Timestamp).compareTo(a.startDateTime));
    debugPrint('找了${fetchPost.docs.length}則貼文');
    return _post;
  }

  Future<List<AdModel>> fetchAllAd() async {
    QuerySnapshot<Map<String, dynamic>> fetchPost = await FirebaseFirestore
        .instance
        .collection('ads')
        .orderBy('datePublished', descending: true)
        .get();
    List<QueryDocumentSnapshot> _list = fetchPost.docs.toList();
    List<AdModel> _ads = _list.map((e) => AdModel.fromMap(e)).toList();
    debugPrint('找了${fetchPost.docs.length}則貼文');
    return _ads;
  }

  //發送Notification
  Future<void> uploadToInbox(
    String targetUserId,
    String organizerName,
    String? organizerPic,
    String organizerUid,
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
        'pic': organizerPic,
        "uid": organizerUid,
        'name': organizerName,
        'text': text,
        'url': url,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //上傳許願
  Future<String> uploadWishing(
    WishModel wish,
  ) async {
    String res = "some error occur";
    try {
      // 上傳到posts collection下的signForms collection
      await _firestore.collection('wishes').doc(wish.wishId).set(wish.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
      debugPrint('err${err.toString()}');
    }
    return res;
  }

  //點贊許願
  Future likeWishing(UserModel user, WishModel wish) async {
    try {
      //以下尚未填過
      List rateList = wish.rateList;
      if (rateList.contains(user.uuid)) {
        print('herer');
        await _firestore.collection('wishes').doc(wish.wishId).update({
          'rateList': FieldValue.arrayRemove([user.uuid]),
        });
      } else {
        print('herer11');
        await _firestore.collection('wishes').doc(wish.wishId).update({
          'rateList': FieldValue.arrayUnion([user.uuid])
        });
      }
    } catch (err) {
      debugPrint('err${err.toString()}');
    }
  }

  // 增加fcmToken
  Future<void> addFcm(String fcmToken, UserModel user) async {
    try {
      debugPrint("增加Fcm");
      await _firestore.collection('users').doc(user.uuid).update({
        "fcmToken": FieldValue.arrayUnion([fcmToken]),
      });
    } catch (e) {
      print("error: ${e.toString()}");
    }
  }

  //追蹤
  Future<void> followOrganizer(
      {required UserModel user, required String organizerUid}) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user.uuid).get();
      List followings = (snap.data()! as dynamic)['followings'] ?? [];

      if (followings.contains(organizerUid)) {
        // 已經追蹤過
        // 刪除處室追蹤列表的我的uid
        await _firestore.collection('organizers').doc(organizerUid).update({
          'followers': FieldValue.arrayRemove([user.uuid]),
        });
        // 刪除處室追蹤列表的我的fcm
        if (user.fcmToken != null || user.fcmToken!.isNotEmpty) {
          await _firestore.collection('organizers').doc(organizerUid).update({
            'followersFcm': FieldValue.arrayRemove(user.fcmToken!),
          });
        }
        // 刪除我的蹤列表的處室uid
        await _firestore.collection('users').doc(user.uuid).update({
          'followings': FieldValue.arrayRemove([organizerUid]),
        });
      } else {
        // 增加處室追蹤列表的我的uid
        await _firestore.collection('organizers').doc(organizerUid).update({
          'followers': FieldValue.arrayUnion([user.uuid]),
        });
        // 增加處室追蹤列表的我的fcm
        if (user.fcmToken != null || user.fcmToken!.isNotEmpty) {
          await _firestore.collection('organizers').doc(organizerUid).update({
            'followersFcm': FieldValue.arrayUnion(user.fcmToken!),
          });
        }
        // 增加我的蹤列表的處室uid
        await _firestore.collection('users').doc(user.uuid).update({
          'followings': FieldValue.arrayUnion([organizerUid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
