import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/models/user_model.dart' as model;

class AuthMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  model.User? user;
  Future<void> getUserDetails() async {
    print('拿了user from firestore廣播給provider');
    if (_auth.currentUser != null) {
      User currentUser = _auth.currentUser!;
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUser.uid).get();
      user = model.User.fromSnap(snap);
    }
    // notifyListeners();
  }

  //註冊用戶
  Future<String> signUpUser({
    required String email,
    required String password,
    Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = "success";
        print(res);
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      } else if (err.code == 'email-already-in-use') {
        res = 'the email you entered has been use';
      } else {
        res = err.toString();
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //使用者登入
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = "success";
    } on FirebaseAuthException catch (err) {
      print('errorr');
      if (err.code == 'unknown') {
        res = 'Please enter all the fields';
      } else if (err.code == 'wrong-password') {
        res = '密碼輸入錯誤';
      } else if (err.code == 'network-request-failed') {
        res = '網路出現問題';
      } else if (err.code == 'user-not-found') {
        res = '此郵箱尚未註冊';
      } else {
        res = err.code.toString();
      }
    } on PlatformException catch (err) {
      print('errorr');
      res = err.toString();
    } catch (e) {
      print('errorr');
      res = e.toString();
    }
    return res;
  }

  Future<String> signInWithApple() async {
    String res = 'some error occur';
    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      //上傳用戶註冊資料
      res = await FirestoreMethods().signUpUser(
        userCredential.user!.email,
        FirebaseAuth.instance.currentUser!,
      );
    } catch (e) {
      print(e);
      res = e.toString();
    }
    return res;
  }

  Future<String> signInWithGoogle() async {
    String res = 'some error occur';
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //上傳用戶註冊資料
      res = await FirestoreMethods().signUpUser(
        userCredential.user!.email,
        FirebaseAuth.instance.currentUser!,
      );
    } on PlatformException catch (e) {
      res = e.toString();
      print(e);
      res = e.toString();
    }
    return res;
  }

  //使用者登出
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //重至密碼
  Future<String> resetPassword(String email) async {
    String res = 'some error occur';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = 'success';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = '該信箱尚未註冊';
      } else {
        res = 'error occur in FirebaseAuth';
        print(err.toString());
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //信箱驗證
  Future<String> sendVerificationEmail() async {
    String res = 'some error occur';
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
      res = 'success';
    } on FirebaseAuthException catch (err) {
      print(err.toString());
      res = 'error occur in FirebaseAuth';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
