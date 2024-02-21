// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/post_model.dart';
import '../firebase/auth_methods.dart';
import '../firebase/firestore_methods.dart';
import '../models/form_model.dart';
import '../models/option_model.dart';
import '../models/user_model.dart';
import '../pages/sign_form_finish_page.dart';
import 'package:provider/provider.dart';

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
        _i++;
      }
    }
    return _errorText;
  }

  confirmSend(UserModel user, PostModel post, BuildContext context) async {
    debugPrint('傳送報名表單');
    debugPrint('signForm:$signForm');

    String res = await FirestoreMethods().uploadSignForm(
      user,
      post,
      jsonEncode(signForm),
    );
    if (res == "success") {
      Messenger.snackBar(context, "報名成功", "謝謝您的報名，請記得出席活動");
      await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
    } else {
      Messenger.snackBar(context, "報名失敗，請回報問題", "請聯絡service.upoint@gmail.com");
      Messenger.dialog("報名失敗，請回報問題", "請聯絡service.upoint@gmail.com", context);
    }
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
