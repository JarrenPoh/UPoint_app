import 'package:cloud_firestore/cloud_firestore.dart';

class AnnounceModel {
  String? photo;
  List likes;
  String content;
  //以下尚未填
  String announceId;
  String organizerUid;
  String organizerName;
  var datePublished;
  String organizerPic;
  bool isPin;

  AnnounceModel({
    required this.photo,
    required this.organizerName,
    required this.content,
    required this.announceId,
    this.datePublished,
    required this.organizerUid,
    required this.organizerPic,
    required this.likes,
    required this.isPin,
  });

  static Map toMap(AnnounceModel cart) {
    return {
      "photo": cart.photo,
      "organizerName": cart.organizerName,
      "content": cart.content,
      "announceId": cart.announceId,
      "datePublished": cart.datePublished,
      "organizerUid": cart.organizerUid,
      "organizerPic": cart.organizerPic,
      "likes": cart.likes,
      "isPin": cart.isPin,
    };
  }

  static AnnounceModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return AnnounceModel(
      photo: snapshot['photo'],
      organizerName: snapshot['organizerName'],
      content: snapshot['content'],
      announceId: snapshot['announceId'],
      datePublished: snapshot['datePublished'],
      organizerUid: snapshot['organizerUid'],
      organizerPic: snapshot['organizerPic'],
      likes: snapshot['likes'],
      isPin: snapshot["isPin"],
    );
  }

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "organizerName": organizerName,
        "content": content,
        "announceId": announceId,
        "datePublished": datePublished,
        "organizerUid": organizerUid,
        "organizerPic": organizerPic,
        "likes": likes,
        "isPin": isPin,
      };

  static AnnounceModel fromMap(Map map) {
    return AnnounceModel(
      photo: map['photo'],
      organizerName: map['organizerName'],
      content: map['content'],
      announceId: map['announceId'],
      datePublished: map['datePublished'],
      organizerUid: map['organizerUid'],
      organizerPic: map['organizerPic'],
      likes: map['likes'],
      isPin: map["isPin"],
    );
  }
}
