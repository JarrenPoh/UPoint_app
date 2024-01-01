import 'package:cloud_firestore/cloud_firestore.dart';

class RewardTagModel {
  String name;
  String id;
  String pic;

  RewardTagModel({
    required this.name,
    required this.id,
    required this.pic,
  });

  static Map toMap(RewardTagModel cart) {
    return {
      "name": cart.name,
      "id": cart.id,
      "pic": cart.pic,
    };
  }

   static RewardTagModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return RewardTagModel(
      name: snapshot['name'],
      id: snapshot['id'],
      pic: snapshot['pic'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "pic": pic,
      };

  static RewardTagModel fromMap(Map map) {
    return RewardTagModel(
      name: map['name'],
      id: map['id'],
      pic: map['pic'],
    );
  }
}
