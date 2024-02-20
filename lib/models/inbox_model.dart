import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  final datePublished;
  final String name;
  final String inboxId;
  final String uid;
  String? pic;
  final String text;
  final String url;

  InboxModel({
    required this.datePublished,
    required this.name,
    required this.inboxId,
    required this.pic,
    required this.text,
    required this.uid,
    required this.url,
  });

  static InboxModel fromMap(QueryDocumentSnapshot map) {
    return InboxModel(
      datePublished: map['datePublished'],
      name: map['name'],
      inboxId: map['inboxId'],
      uid:map['uid'],
      pic: map['pic'],
      text: map['text'],
      url: map['url'],
    );
  }


}
class dateGroup {
  String title;
  List<InboxModel> inboxModel;

  dateGroup(this.title, this.inboxModel);
}
