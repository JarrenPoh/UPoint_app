import 'package:cloud_firestore/cloud_firestore.dart';

class OrganModel {
  String organizerName;
  String uid;
  String pic;
  String phoneNumber;
  String email;

  OrganModel({
    required this.organizerName,
    required this.uid,
    required this.pic,
    required this.email,
    required this.phoneNumber,
  });

  static Map toMap(OrganModel cart) {
    return {
      "organizerName": cart.organizerName,
      "uid": cart.uid,
      "pic": cart.pic,
      "email":cart.email,
      "phoneNumber":cart.phoneNumber,
    };
  }

   static OrganModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OrganModel(
      organizerName: snapshot['organizerName'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      email:snapshot['email'],
      phoneNumber:snapshot['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        "organizerName": organizerName,
        "uid": uid,
        "pic": pic,
        "email":email,
        "phoneNumber":phoneNumber,
      };

  static OrganModel fromMap(Map map) {
    return OrganModel(
      organizerName: map['organizerName'],
      uid: map['uid'],
      pic: map['pic'],
      email:map['email'],
      phoneNumber:map['phoneNumber'],
    );
  }
}
