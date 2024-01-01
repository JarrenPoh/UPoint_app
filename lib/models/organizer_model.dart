import 'package:cloud_firestore/cloud_firestore.dart';

class OrganModel {
  String organizerName;
  String uid;
  String pic;

  OrganModel({
    required this.organizerName,
    required this.uid,
    required this.pic,
  });

  static Map toMap(OrganModel cart) {
    return {
      "organizerName": cart.organizerName,
      "uid": cart.uid,
      "pic": cart.pic,
    };
  }

   static OrganModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OrganModel(
      organizerName: snapshot['organizerName'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
    );
  }

  Map<String, dynamic> toJson() => {
        "organizerName": organizerName,
        "uid": uid,
        "pic": pic,
      };

  static OrganModel fromMap(Map map) {
    return OrganModel(
      organizerName: map['organizerName'],
      uid: map['uid'],
      pic: map['pic'],
    );
  }
}
