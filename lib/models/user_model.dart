import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uuid;
  String? username;
  String? studentID;
  String? phoneNumber;
  String? fcmToken;

  User({
    required this.email,
    required this.uuid,
    this.phoneNumber,
    this.studentID,
    this.username,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uuid": uuid,
        "username": username,
        "studentID": studentID,
        "phoneNumber": phoneNumber,
        "fcmToken": fcmToken,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uuid: snapshot['uuid'],
      username: snapshot['username'],
      studentID: snapshot['studentID'],
      phoneNumber: snapshot['phoneNumber'],
      fcmToken: snapshot['fcmToken'],
    );
  }
}
