import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:upoint/models/user_model.dart' as model;

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //註冊用戶
  Future<String> signUpUser(email, auth.User currentUser) async {
    String res = 'some error occur';
    String? photoUrl;
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
}
