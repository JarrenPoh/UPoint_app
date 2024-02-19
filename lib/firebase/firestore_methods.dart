import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/firebase/storage_methods.dart';
import 'package:upoint/models/sign_form_model.dart';
import 'package:upoint/models/user_model.dart';
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

  //上傳報名表單
  Future<String> uploadSignForm(
    UserModel user,
    String postId,
    String getSignFormBody,
  ) async {
    String res = "some error occur";
    String signFormId = const Uuid().v1();
    List _signList = user.signList ?? [];
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
      print('err${err.toString()}');
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
