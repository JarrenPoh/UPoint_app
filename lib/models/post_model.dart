import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  List? photos;
  String? organizer;
  String? title;
  var date;
  String? startTime;
  String? endTime;
  String? content;
  String? reward;
  String? rewardTagId;
  String? link;
  String? postId;
  String? uid;
  List? signList;
  var datePublished;
  String? pic;

  PostModel({
    this.photos,
    this.organizer,
    this.title,
    this.date,
    this.startTime,
    this.endTime,
    this.content,
    this.reward,
    this.rewardTagId,
    this.link,
    this.postId,
    this.datePublished,
    this.uid,
    this.signList,
    this.pic,
  });

  static Map toMap(PostModel cart) {
    return {
      "photos": cart.photos,
      "organizer": cart.organizer,
      "title": cart.title,
      "date": cart.date,
      "startTime": cart.startTime,
      "endTime": cart.endTime,
      "content": cart.content,
      "reward": cart.reward,
      "rewardTagId": cart.rewardTagId,
      "link": cart.link,
      "postId": cart.postId,
      "datePublished": cart.datePublished,
      "uid": cart.uid,
      "signList": cart.signList,
      "pic": cart.pic,
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return PostModel(
      photos: snapshot['photos'],
      organizer: snapshot['organizer'],
      title: snapshot['title'],
      date: snapshot['date'],
      startTime: snapshot['startTime'],
      endTime: snapshot['endTime'],
      content: snapshot['content'],
      reward: snapshot['reward'],
      rewardTagId: snapshot['rewardTagId'],
      link: snapshot['link'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      uid: snapshot['uid'],
      signList: snapshot['signList'],
      pic: snapshot['pic'],
    );
  }

  Map<String, dynamic> toJson() => {
        "photos": photos,
        "organizer": organizer,
        "title": title,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "content": content,
        "reward": reward,
        "rewardTagId": rewardTagId,
        "link": link,
        "postId": postId,
        "datePublished": datePublished,
        "uid": uid,
        "pic": pic,
      };

  static PostModel fromMap(Map map) {
    return PostModel(
      photos: map['photos'],
      organizer: map['organizer'],
      title: map['title'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      content: map['content'],
      reward: map['reward'],
      rewardTagId: map['rewardTagId'],
      link: map['link'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      uid: map['uid'],
      pic: map['pic'],
    );
  }
}
