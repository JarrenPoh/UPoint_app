import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  final datePublished;
  final String pic;
  String? url;
  final String title;

  AdModel({
    required this.datePublished,
    required this.pic,
    this.url,
    required this.title,
  });

  static AdModel fromMap(QueryDocumentSnapshot map) {
    return AdModel(
      datePublished: map['datePublished'],
      pic: map['pic'],
      url: map['url'],
      title: map['title'],
    );
  }
}
