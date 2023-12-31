import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/value_notifier/bool_value_notifier.dart';

class AddPostPageBloc with ChangeNotifier {
  String initText = "";
  AddPostPageBloc() {}
  final PageController pageController = PageController();
  List<Widget> pageWidget = [];
  int itemCount = 0;
  PostModel cart = PostModel();

  /*   加照片addPicture  */
  final StreamController<InstaAssetsExportDetails> imgStreamController =
      StreamController<InstaAssetsExportDetails>();
  int maxAssets = 1;
  final BoolValueNotifier addPictureNotifier = BoolValueNotifier(false);
  List assetPics = [];

  /*  加資訊addInformation  */
  List<Map<String, dynamic>> informations = [
    {"type": "主辦單位", "bool": true},
    {"type": "日期", "bool": true},
    {"type": "開始時間", "bool": true},
    {"type": "結束時間", "bool": true},
    {"type": "標題", "bool": true},
    {"type": "內容", "bool": true},
  ];
  final BoolValueNotifier addInformNotifier = BoolValueNotifier(false);
  bool isFinish = false;
  void checkInform(PostModel input) {
    if (input.content != null &&
        input.content!.isNotEmpty &&
        input.date != null &&
        input.startTime != null &&
        input.endTime != null &&
        input.title != null &&
        input.title!.isNotEmpty) {
      isFinish = true;
      addInformNotifier.boolChange(true);
    } else {
      addInformNotifier.boolChange(false);
    }
    notifyListeners();
  }

  //主辦單位
  TextEditingController organizerController =
      TextEditingController(text: "initText");
  //標題
  final TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  bool isTitle = false;

  //內容
  final TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();
  bool isContent = false;

  //日期
  String unitOfDate = "";
  ChooseModelValueNotifier dateValueNotifier = ChooseModelValueNotifier(
    ChooseModel(
      chose: "日期",
      isChose: false,
      initChose: 0,
    ),
  );
  //開始時間
  String startTime = "";
  ChooseModelValueNotifier startTimeValueNotifier = ChooseModelValueNotifier(
    ChooseModel(
      chose: "開始",
      isChose: false,
      initChose: 0,
    ),
  );
  //結束時間
  String endTime = "";
  ChooseModelValueNotifier endTimeValueNotifier = ChooseModelValueNotifier(
    ChooseModel(
      chose: "結束",
      isChose: false,
      initChose: 0,
    ),
  );

  /*  addOthers  */
  List<Map<String, dynamic>> others = [
    {"type": "IG連結", "bool": false},
    {"type": "獎勵", "bool": false},
  ];
  final BoolValueNotifier addOtherNotifier = BoolValueNotifier(true);
  //link
  final TextEditingController linkController = TextEditingController();
  FocusNode linkFocusNode = FocusNode();
  bool isLink = false;
  //reward
  final TextEditingController rewardController = TextEditingController();
  FocusNode rewardFocusNode = FocusNode();
  bool isReward = false;

  /*  addPost  */
  void updateCart(PostModel input) {
    if (input.photos != null) {
      cart.photos = input.photos;
    }
    if (input.content != null) {
      cart.content = input.content;
    }
    if (input.organizer != null) {
      cart.organizer = input.organizer;
    }
    if (input.title != null) {
      cart.title = input.title;
    }
    if (input.date != null) {
      cart.date = input.date;
    }
    if (input.startTime != null) {
      cart.startTime = input.startTime;
    }
    if (input.endTime != null) {
      cart.endTime = input.endTime;
    }
    if (input.reward != null) {
      cart.reward = input.reward;
    }
    if (input.link != null) {
      cart.link = input.link;
    }
    if (input.postId != null) {
      cart.postId = input.postId;
    }
    if (input.datePublished != null) {
      cart.datePublished = input.datePublished;
    }
    if (input.uid != null) {
      cart.uid = input.uid;
    }
    notifyListeners();
  }

  void cleanCart() {
    PostModel _cart = PostModel();
    assetPics = [];
    dateValueNotifier.ChooseModelChange(
      ChooseModel(
        chose: "日期",
        isChose: false,
        initChose: 0,
      ),
    );
    startTimeValueNotifier.ChooseModelChange(
      ChooseModel(
        chose: "開始",
        isChose: false,
        initChose: 0,
      ),
    );
    endTimeValueNotifier.ChooseModelChange(
      ChooseModel(
        chose: "結束",
        isChose: false,
        initChose: 0,
      ),
    );
    titleController.clear();
    contentController.clear();
    linkController.clear();
    rewardController.clear();
    checkInform(_cart);
    notifyListeners();
  }

  Future<String> uploadPost(context, User? _user, PostModel _cart) async {
    String res = 'some error occur';
    try {
      _cart.organizer = _user?.username;
      res = await FirestoreMethods().uploadPost(_cart, _user!);
      Get.snackbar(
        "上傳成功",
        "你的貼文已成功上傳",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(
          seconds: 2,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "上傳失敗",
        "請聯繫官方回報問題拿獎勵",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(
          seconds: 2,
        ),
      );
      res = e.toString();
    }
    return res;
  }

  Future<String> updatePost(context, User? _user, PostModel _cart) async {
    String res = 'some error occur';
    try {
      res = await FirestoreMethods().updatePost(_cart, _user!);
      Get.snackbar(
        "更新成功",
        "你的貼文已成功更新",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(
          seconds: 2,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "更新失敗",
        "請聯繫官方回報問題拿獎勵",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(
          seconds: 2,
        ),
      );
      res = e.toString();
    }
    return res;
  }
}

class ChooseModel {
  final String chose;
  final bool isChose;
  final int initChose;

  ChooseModel({
    required this.chose,
    required this.isChose,
    required this.initChose,
  });

  static ChooseModel fromMap(Map map) {
    return ChooseModel(
      chose: map['chose'],
      isChose: map['isChose'],
      initChose: map['initChose'],
    );
  }
}

class ChooseModelValueNotifier extends ValueNotifier {
  ChooseModelValueNotifier(super.value);

  void ChooseModelChange(ChooseModel inFormModel) {
    value = inFormModel;
  }
}
