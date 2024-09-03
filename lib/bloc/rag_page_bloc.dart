import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/models/rag_message_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../api/openai_service.dart';

class RagPageBloc {
  final types.User user;
  final ValueNotifier<List<types.Message>> messagesNotifier = ValueNotifier([]);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final OpenAIService openAIService;

  RagPageBloc({required this.user, required this.openAIService});

  void addMessage(types.Message message) {
    messagesNotifier.value = [...messagesNotifier.value, message];
  }

  void handleSendPressed({
    required types.PartialText message,
    required UserModel u,
  }) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);
    // 上傳Firebase
    FirestoreMethods().sendRagMessage(
      user: u,
      ragMessageModel: RagMessageModel(
        isUser: true,
        content: message.text,
        datePublished: DateTime.fromMillisecondsSinceEpoch(
          textMessage.createdAt ?? DateTime.now().millisecondsSinceEpoch,
        ),
        messageId: textMessage.id,
      ),
    );
  }

  Future<void> fetchData({
    required types.PartialText message,
    required UserModel u,
  }) async {
    isLoadingNotifier.value = true; // 開始加載
    final String response =
        await openAIService.createThreadAndFetchResponse(message.text);
      final apiResponseMessage = types.TextMessage(
        author: types.User(id: 'server'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: response,
      );

      addMessage(apiResponseMessage);
      // 上傳Firebase
      FirestoreMethods().sendRagMessage(
        user: u,
        ragMessageModel: RagMessageModel(
          isUser: false,
          content: apiResponseMessage.text,
          datePublished: DateTime.fromMillisecondsSinceEpoch(
            apiResponseMessage.createdAt ??
                DateTime.now().millisecondsSinceEpoch,
          ),
          messageId: apiResponseMessage.id,
        ),
      );
    isLoadingNotifier.value = false; // 加載完成
  }

  Future<void> loadInitialMessages(UserModel u) async {
    print("所要先前的訊息");
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(u.uuid)
          .collection("rag_messages")
          .orderBy('datePublished', descending: false)
          .get();

      final List<types.Message> messages = snapshot.docs.map((doc) {
        final RagMessageModel ragMessage = RagMessageModel.fromSnap(doc);
        return types.TextMessage(
          author: ragMessage.isUser ? user : const types.User(id: 'server'),
          createdAt:
              (ragMessage.datePublished as Timestamp).millisecondsSinceEpoch,
          id: ragMessage.messageId,
          text: ragMessage.content,
        );
      }).toList();

      messagesNotifier.value = messages;
    } catch (e) {
      debugPrint("Error loading initial messages: ${e.toString()}");
    }
  }

  void dispose() {
    messagesNotifier.dispose();
    isLoadingNotifier.dispose();
  }
}
