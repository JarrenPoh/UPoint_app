// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, prefer_const_constructors, use_build_context_synchronously
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/pages/wishing_page.dart';

import '../pages/edit_profile_page.dart';
import '../pages/privacy_page.dart';

class ProfilePageBloc {
  ValueNotifier<List<Map>> personNotifier = ValueNotifier([]);
  ValueNotifier<int> countNotifier = ValueNotifier(0);
  initInform(UserModel? userModel) {
    print('here02');
    if (userModel != null) {
      if (userModel.signList != null && userModel.signList!.isNotEmpty) {
        countNotifier.value = userModel.signList!.length;
      }
      if (userModel.username != null && userModel.username!.isNotEmpty) {
        personalInform[0]["value"] = userModel.username!;
      }
      if (userModel.className != null && userModel.className!.isNotEmpty) {
        personalInform[1]["value"] = userModel.className!;
      }
      if (userModel.studentID != null && userModel.studentID!.isNotEmpty) {
        personalInform[2]["value"] = userModel.studentID!;
      }
      if (userModel.phoneNumber != null && userModel.phoneNumber!.isNotEmpty) {
        personalInform[3]["value"] = userModel.phoneNumber!;
      }
      if (userModel.email.isNotEmpty) {
        personalInform[4]["value"] = userModel.email;
      }
    }
    personNotifier.value = personalInform;
    countNotifier.notifyListeners();
    personNotifier.notifyListeners();
  }

  _deleteAccount(UserModel user, BuildContext context) async {
    String res = await Messenger.dialog(
      '確定要刪除帳號嗎！',
      '一旦刪除後便永久無法復原！',
      context,
    );
    if (res == "success") {
      String _rr = await AuthMethods().deleteUser(user);
      if (_rr == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        Messenger.dialog(
            "註銷失敗", "$_rr 有問題請洽詢官方：service.upoint@gmail.com", context);
        Messenger.snackBar(
            context, "註銷失敗", "$_rr 有問題請洽詢官方：service.upoint@gmail.com");
      }
    }
  }

  refresh(UserModel? user, BuildContext context) async {
    if (user != null) {
      await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
    }
  }

  editProfile(UserModel? user, BuildContext context) async {
    if (user != null) {
      String? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditProfilePage(
              user: user,
            );
          },
        ),
      );
      if (result == 'success') {
        refresh(user, context);
      }
    }
  }

  logInOrOut(UserModel? user, BuildContext context) async {
    if (user != null) {
      String res = await Messenger.dialog(
        '您要登出嗎？',
        '要確定ㄟ',
        context,
      );
      if (res == "success") {
        await AuthMethods().signOut();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  List<Map> personalInform = [
    {
      "title": "姓名",
      "index": "username",
      "value": "尚未編輯",
    },
    {
      "title": "班級",
      "index": "className",
      "value": "尚未編輯",
    },
    {
      "title": "學號",
      "index": "studentID",
      "value": "尚未編輯",
    },
    {
      "title": "聯絡電話",
      "index": "phoneNumber",
      "value": "尚未編輯",
    },
    {
      "title": "電子郵件",
      "index": "email",
      "value": "尚未編輯",
    },
  ];

  List<Map> commonUseList(context, UserModel user) {
    CColor cColor = CColor.of(context);
    return [
      {
        "title": "編輯個人資料",
        "icon": Icon(Icons.edit_note_outlined, size: 26, color: cColor.primary),
        "onTap": () => editProfile(user, context),
      },
      {
        "title": "功能許願池",
        "icon": SvgPicture.asset(
          width: 26,
          height: 26,
          "assets/fountain.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WishingPage();
                },
              ),
            ),
      },
      {
        "title": "隱私條約",
        "icon":
            Icon(Icons.library_books_outlined, size: 26, color: cColor.primary),
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PrivacyPage();
                },
              ),
            )
      },
      {
        "title": "登出",
        "icon": SvgPicture.asset(
          width: 26,
          height: 26,
          "assets/logout.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () => logInOrOut(user, context),
      },
      {
        "title": "註銷帳號",
        "icon": SvgPicture.asset(
          width: 26,
          height: 26,
          "assets/key-remove.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () async => await _deleteAccount(
              user,
              context,
            )
      },
    ];
  }
}
