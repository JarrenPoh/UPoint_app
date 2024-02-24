// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
import 'package:upoint/firebase/messaging_methods.dart';
import 'package:upoint/models/post_model.dart';
import '../firebase/auth_methods.dart';
import '../firebase/firestore_methods.dart';
import '../globals/date_time_transfer.dart';
import '../models/form_model.dart';
import '../models/option_model.dart';
import '../models/user_model.dart';
import '../pages/sign_form_finish_page.dart';
import 'package:provider/provider.dart';

import '../secret.dart';

class SignFormBloc {
  SignFormBloc(List<FormModel> formModel, UserModel user) {
    _firstSignForm(formModel, user);
  }
  List<Map> signForm = [];
  _firstSignForm(List<FormModel> formModel, UserModel user) {
    formModel.first.options.insertAll(0, fixCommon);
    for (var form in formModel)
      // ignore: curly_braces_in_flow_control_structures
      for (var option in form.options) {
        print('type: ${option.type}');
        String _value = "";
        switch (option.type) {
          case "username":
            _value = user.username ?? "";
            break;
          case "phoneNumber":
            _value = user.phoneNumber ?? "";
            break;
          case "email":
            _value = user.email;
            break;
          case "class":
            _value = user.className ?? "";
            break;
          case "studentID":
            _value = user.studentID ?? "";
            break;
        }
        signForm.add({
          "subtitle": option.subtitle,
          "value": _value,
        });
      }
    // UserSimplePreference.setSignForm(jsonEncode(_list));
  }

  // longField 的 textChanged
  onLongFieldChanged(String text, int index) {
    // if (UserSimplePreference.getSignForm() != "") {
    //   _signForm = jsonDecode(UserSimplePreference.getSignForm());
    // }
    signForm[index]["value"] = text;
    debugPrint('signForm:$signForm');
    // UserSimplePreference.setSignForm(jsonEncode(_signForm));
  }

  // shortField 的 textChanged
  onShortFieldChanged(List list, int index) {
    // if (UserSimplePreference.getSignForm() != "") {
    //   _signForm = jsonDecode(UserSimplePreference.getSignForm());
    // }
    signForm[index]["value"] = list;
    debugPrint('signForm:$signForm');
    // UserSimplePreference.setSignForm(jsonEncode(_signForm));
  }

  String? checkFunc(List<FormModel> formList) {
    String? _errorText;
    var _i = 0;
    for (var form in formList) {
      for (var option in form.options) {
        if (option.necessary == true && signForm[_i]["value"] == "") {
          _errorText = "${signForm[_i]["subtitle"]}是必填欄位";
          break;
        }
        if (option.type == "phoneNumber" &&
            !isTaiwanMobileNumber(signForm[_i]["value"])) {
          _errorText = "${signForm[_i]["subtitle"]}請輸入有效手機號碼格式";
          break;
        } else if (option.type == "email" && !isEmail(signForm[_i]["value"])) {
          _errorText = "${signForm[_i]["subtitle"]}請輸入有效電子郵件格式";
          break;
        }
        _i++;
      }
    }
    return _errorText;
  }

  confirmSend(UserModel user, PostModel post, BuildContext context) async {
    debugPrint('傳送報名表單');
    debugPrint('signForm:$signForm');
    try {
      // 上傳報名資訊到此貼文
      String res = await FirestoreMethods().uploadSignForm(
        user,
        post,
        jsonEncode(signForm),
      );
      String title = "";
      String text = "";
      if (res == "success") {
        await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
        title = "報名成功";
        text =
            "您報名了 ${post.title} ，請於${TimeTransfer.timeTrans01(post.startDateTime)}準時出席";
      } else {
        title = "報名失敗";
        text =
            "您報名的${post.title}報名失敗，請再嘗試一次，仍然失敗請洽詢官方：service.upoint@gmail.com";
      }
      // 發送報名成功通知給本使用者
      if (user.fcmToken != null) {
        for (var token in user.fcmToken!) {
          await MessagingMethod().sendNotification(
            token,
            title,
            text,
            user,
            "https://$host/activity?id=${post.postId}",
          );
        }
      }
      // 發送到inbox
      await FirestoreMethods().uploadToInbox(
        user.uuid,
        post.organizerName!,
        post.organizerPic,
        post.organizerUid!,
        text,
        "https://$host/activity?id=${post.postId}",
      );
      Provider.of<InboxPageBloc>(context, listen: false).onRefresh();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignFormFinishPage(
            user: user,
            res: res,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  bool isTaiwanMobileNumber(String input) {
    final RegExp mobileRegExp = RegExp(
      r'^09\d{8}$',
    );
    return mobileRegExp.hasMatch(input);
  }

  List<OptionModel> fixCommon = [
    OptionModel(
      type: "username",
      subtitle: "姓名",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "phoneNumber",
      subtitle: "聯絡電話",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "email",
      subtitle: "email",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
  ];
}
