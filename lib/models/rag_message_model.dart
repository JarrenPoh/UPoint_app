import 'package:cloud_firestore/cloud_firestore.dart';

class RagMessageModel {
 final bool isUser;
  final String content;
  final datePublished;
  final String messageId;

  RagMessageModel({
    required this.isUser,
    required this.content,
    required this.datePublished,
    required this.messageId,
  });

  Map<String, dynamic> toJson() => {
        "isUser": isUser,
        "content": content,
        "datePublished": datePublished,
        "messageId":messageId,
      };

  static RagMessageModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    return RagMessageModel(
      isUser: snapshot['isUser'],
      content: snapshot['content'],
      datePublished: snapshot['datePublished'],
      messageId:snapshot["messageId"],
    );
  }

  static RagMessageModel? fromMap(Map? map) {
    if (map == null) {
      return null;
    } else {
      return RagMessageModel(
        isUser: map['isUser'],
        content: map['content'],
        datePublished: map['datePublished'],
        messageId:map["messageId"],
      );
    }
  }
}
