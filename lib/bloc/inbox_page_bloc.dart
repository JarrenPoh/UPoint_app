import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:upoint/models/inbox_model.dart';

class InboxPageBloc with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<InboxModel> Inboxs = [];
  Map<DateTime, List<InboxModel>> map = {};
  List<dateGroup> groups = [];
  List<String> InboxIdList = [];
  ValueNotifier notifierProvider =
      ValueNotifier({"list": [], "bool": false, "isLoading": true});
  bool noMore = false;
  int limit = 8;
  List docs = [];
  List lastDocs = [];

  InboxPageBloc() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          noMore == false) {
        if (FirebaseAuth.instance.currentUser != null) {
          await fetchNext(FirebaseAuth.instance.currentUser!.uid);
        }
      }
    });
  }

  Future fetchNext(String uid) async {
    var fireStoreQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('inboxs')
        .orderBy('datePublished', descending: true);

    if (lastDocs.isNotEmpty) {
      fireStoreQuery =
          fireStoreQuery.startAfterDocument(lastDocs[lastDocs.length - 1]);
    }
    fireStoreQuery = fireStoreQuery.limit(limit);
    var snapshot = await fireStoreQuery.get();
    docs = snapshot.docs;
    debugPrint('fetchInbox length: ${docs.length}');
    if (docs.isNotEmpty) {
      noMore = docs.length < limit;
      lastDocs.addAll(docs);
      await format(lastDocs);
    } else {
      noMore = true;
    }
    notifierProvider.value = {
      "list": groups,
      "bool": noMore,
      "isLoading": false,
    };
    notifierProvider.notifyListeners();
  }

  format(List _docs) async {
    groups = [];
    Inboxs = [];
    map = {};
    _docs.forEach((element) {
      Inboxs.add(InboxModel.fromMap(element));
    });

    for (InboxModel inboxModel in Inboxs) {
      DateTime date = DateTime(
        inboxModel.datePublished.toDate().year,
        inboxModel.datePublished.toDate().month,
        inboxModel.datePublished.toDate().day,
      );
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(inboxModel);
    }

    await initializeDateFormatting('zh_CN');
    DateTime now = DateTime.now();
    String title;
    map.forEach((date, Inboxs) {
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        title = '今日';
      } else if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day - 1) {
        title = '昨天';
      } else {
        title = DateFormat('M月dd日', 'zh_CN').format(date);
      }
      groups.add(dateGroup(title, Inboxs));
    });
    // print(groups.length);
    // print(groups.first.title);
    // print(groups.first.InboxModel.length);
  }

  Future onRefresh() async {
    debugPrint("刷新inbox");
    notifierProvider.value = {
      "list": [],
      "bool": false,
      "isLoading": true,
    };
    this.noMore = false;
    this.lastDocs = [];
    notifierProvider.notifyListeners();
  }
}
