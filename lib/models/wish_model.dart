import 'package:cloud_firestore/cloud_firestore.dart';

class WishModel {
  final datePublished;
  final String content;
  final String wishId;
  final String uid;
  final List rateList;

  WishModel({
    required this.datePublished,
    required this.content,
    required this.wishId,
    required this.uid,
    required this.rateList,
  });

  static WishModel fromMap(QueryDocumentSnapshot map) {
    return WishModel(
      datePublished: map['datePublished'],
      content: map['content'],
      wishId: map['wishId'],
      uid: map['uid'],
      rateList: map['rateList'],
    );
  }

  Map<String, dynamic> toJson() => {
        "datePublished": datePublished,
        "content": content,
        "wishId": wishId,
        "uid": uid,
        "rateList": rateList,
      };
}
