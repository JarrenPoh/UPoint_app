import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/models/user_model.dart' ;
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpUser(email, auth.User currentUser) async {
    String res = 'some error occur';
    try {
      UserModel user = UserModel(
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

  //送出報名表單（改現有post裡面的signList）
  // Future<String> sentSignForm(
  //   PostModel post,
  //   Map postMap,
  //   User user,
  //   Map userMap,
  // ) async {
  //   String res = 'some error occur';
  //   try {
  //     //捕獲最新表單
  //     QuerySnapshot<Map<String, dynamic>> fetchPost =
  //         await FirebaseFirestore.instance
  //             .collection('posts')
  //             .where(
  //               'postId',
  //               isEqualTo: post.postId,
  //             )
  //             .get();
  //     PostModel _post = PostModel.fromSnap(fetchPost.docs.toList().first);
  //     List signList = _post.signList ?? [];
  //     signList.add(postMap);
  //     //更新貼文
  //     await _firestore.collection('posts').doc(post.postId).update({
  //       "signList": signList,
  //     });
  //     //更新用戶
  //     signList = user.signList ?? [];
  //     signList.add(userMap);
  //     await _firestore.collection('users').doc(user.uuid).update({
  //       "signList": signList,
  //     });
  //     await uploadToInbox(
  //       user.uuid,
  //       post.organizerName!,
  //       post.organizerPic,
  //       "你已成功報名『${post.title}』，請記得出席 ${post.organizerName}",
  //       Uri(
  //         pathSegments: ['activity'],
  //         queryParameters: {"id": post.postId!},
  //       ).toString(),
  //     );
  //     res = 'success';
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

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
  Future<String> updatePic(pic,  String doc) async {
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
