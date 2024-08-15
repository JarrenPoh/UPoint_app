import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/organizer_model.dart';
import '../globals/global.dart';

class OrganzierFetchBloc with ChangeNotifier {
  List<OrganizerModel> _organizerList = [];
  List<OrganizerModel> get organizerList => _organizerList;

  bool _hasFetched = false;
  bool get hasFetched => _hasFetched;

  Future<void> fetchOrganizers() async {
    QuerySnapshot<Map<String, dynamic>> fetchOrganizers =
        await FirebaseFirestore.instance.collection('organizers').get();
    debugPrint('找了${fetchOrganizers.docs.length}個活動方');
    List<QueryDocumentSnapshot> docs = fetchOrganizers.docs.toList();
    _organizerList = docs.map((e) => OrganizerModel.fromSnap(e)).toList();
    if (!isDebugging) {
      _organizerList.removeWhere((e) => debugId.contains(e.uid));
    }
    _organizerList.insert(
      0,
      OrganizerModel(
        username: "全部",
        uid: "all",
        pic: "",
        email: "",
        phoneNumber: "",
        bio: "",
        unit: "",
        contact: "",
        postLength: 0,
        followers: [],
        followersFcm: [],
      ),
    );
    _organizerList = _repeatHandle(_organizerList);
    notifyListeners();
  }

  List<OrganizerModel> _repeatHandle(List<OrganizerModel> list) {
    Map<String, int> usernameCount = {};
    for (OrganizerModel model in list) {
      usernameCount[model.username] = (usernameCount[model.username] ?? 0) + 1;
    }
    Map<String, int> currentIndex = {};
    List<OrganizerModel> finalList = list.map((OrganizerModel model) {
      String username = model.username;
      if (usernameCount[username]! > 1) {
        currentIndex[username] = (currentIndex[username] ?? 0) + 1;
        return OrganizerModel(
          username: "$username (${currentIndex[username]})",
          uid: model.uid,
          pic: model.pic,
          email: model.email,
          phoneNumber: model.phoneNumber,
          bio: model.bio,
          unit: model.unit,
          contact: model.contact,
          postLength: model.postLength,
          followers: model.followers,
          followersFcm: model.followersFcm,
        );
      } else {
        return OrganizerModel(
          username: username,
          uid: model.uid,
          pic: model.pic,
          email: model.email,
          phoneNumber: model.phoneNumber,
          bio: model.bio,
          unit: model.unit,
          contact: model.contact,
          postLength: model.postLength,
          followers: model.followers,
          followersFcm: model.followersFcm,
        );
      }
    }).toList();
    return finalList;
  }
}
