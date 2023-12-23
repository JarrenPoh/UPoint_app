import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/value_notifier/bool_value_notifier.dart';

class AddPostPageBloc with ChangeNotifier {
  final PageController pageController = PageController();
  List<Widget> pageWidget = [];
  final BoolValueNotifier addOtherNotifier = BoolValueNotifier(false);
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
  final TextEditingController organizerController =
      TextEditingController(text: "中原xxxx中心");
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

  /*  addPost  */
  void updateCart(PostModel input) {
    if (input.photos != null) {
      cart.photos = input.photos;
    } else if (input.content != null) {
      cart.content = input.content;
    } else if (input.organizer != null) {
      cart.organizer = input.organizer;
    } else if (input.title != null) {
      cart.title = input.title;
    } else if (input.date != null) {
      cart.date = input.date;
    } else if (input.startTime != null) {
      cart.startTime = input.startTime;
    } else if (input.endTime != null) {
      cart.endTime = input.endTime;
    } else if (input.reWard != null) {
      cart.reWard = input.reWard;
    } else if (input.link != null) {
      cart.link = input.link;
    }
    notifyListeners();
  }

  Future uploadPost(
    context,
  ) async {
    try {
      //跑loading
      // await SupabaseMethods().CreatePost(context);
      //清空資料
      Get.snackbar(
        "上傳成功",
        "你的貼文已成功上傳",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(
          seconds: 2,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "上傳失敗",
        "請聯繫官方回報問題拿獎勵",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(
          seconds: 2,
        ),
      );
    }
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
