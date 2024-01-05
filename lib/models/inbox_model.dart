import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  final datePublished;
  final String name;
  final String inboxId;
  String? pic;
  final String text;
  final String url;

  InboxModel({
    required this.datePublished,
    required this.name,
    required this.inboxId,
    required this.pic,
    required this.text,
    required this.url,
  });

  static InboxModel fromMap(QueryDocumentSnapshot map) {
    return InboxModel(
      datePublished: map['datePublished'],
      name: map['name'],
      inboxId: map['inboxId'],
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
