import 'package:cloud_firestore/cloud_firestore.dart';

class VersionModel {
  final datePublished;
  final String title;
  final String content;
  final String iOS;
  final String android;

  VersionModel({
    required this.datePublished,
    required this.title,
    required this.content,
    required this.android,
    required this.iOS,
  });

  static VersionModel fromMap(QueryDocumentSnapshot map) {
    return VersionModel(
      datePublished: map['datePublished'],
      title: map['title'],
      content: map['content'],
      iOS:map['iOS'],
      android: map['android'],
    );
  }


}

