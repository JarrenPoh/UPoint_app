// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, prefer_const_constructors, use_build_context_synchronously
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/calendar_page.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/pages/wishing_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/privacy_page.dart';

class ProfilePageBloc {
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
  UserModel? user;
  ProfilePageBloc(UserModel? _user) {
    user = _user;
  }

  _deleteAccount(BuildContext context) async {
    String res = await Messenger.dialog(
      '確定要刪除帳號嗎！',
      '一旦刪除後便永久無法復原！',
      context,
    );
    if (res == "success") {
      String _rr = await AuthMethods().deleteUser(user!);
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

  refresh(BuildContext context) async {
    if (user != null) {
      await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
    }
  }

  editProfile(BuildContext context) async {
    if (user != null) {
      String? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditProfilePage(
              user: user!,
            );
          },
        ),
      );
      if (result == 'success') {
        refresh(context);
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

  logInOrOut(BuildContext context) async {
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

  List<Map> commonUseList(context, UserModel user) {
    double size = 20;
    return [
      {
        "title": "編輯個人資料",
        "icon": SvgPicture.asset(
          width: size,
          height: size,
          "assets/edit_profile.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () => editProfile(context),
      },
      {
        "title": "活動行事曆",
        "icon": SvgPicture.asset(
          width: size,
          height: size,
          "assets/calendar.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return CalendarPage();
              }),
            ),
      },
      {
        "title": "功能許願池",
        "icon": SvgPicture.asset(
          width: size,
          height: size,
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
    ];
  }

  List<Map> accountList(context, UserModel user) {
    double size = 20;
    return [
      {
        "title": "隱私條約",
        "icon": SvgPicture.asset(
          width: size,
          height: size,
          "assets/privacy.svg",
          fit: BoxFit.cover,
        ),
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
          width: size,
          height: size,
          "assets/logout.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () => logInOrOut(context),
      },
      {
        "title": "註銷帳號",
        "icon": SvgPicture.asset(
          width: size,
          height: size,
          "assets/key-remove.svg",
          fit: BoxFit.cover,
        ),
        "onTap": () async => await _deleteAccount(context)
      },
    ];
  }
}
