import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/edit_profile_page.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/pages/privacy_page.dart';
import 'package:upoint/secret.dart';
import 'package:upoint/widgets/profile/profile_pic.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;
  const ProfilePage({
    super.key,
    this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  UserModel? _user;
  OrganizerModel? _organizer;
  int countTime = 0;
  String username = '使用者';
  String className = '尚未編輯';
  String studentID = '尚未編輯';
  String phoneNumber = '尚未編輯';
  String email = '尚未編輯';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _user = widget.user;
    }
    initInform();
  }

  initInform() {
    if (_organizer != null) {
      if (_organizer!.username.isNotEmpty) {
        username = _organizer!.username;
      }
      if (_organizer!.phoneNumber.isNotEmpty) {
        phoneNumber = _organizer!.phoneNumber;
      }
      if (_organizer!.email.isNotEmpty) {
        email = _organizer!.email;
      }
    }
    if (_user != null) {
      if (_user!.signList != null && _user!.signList!.isNotEmpty) {
        countTime = _user!.signList!.length;
      }
      if (_user!.username != null && _user!.username!.isNotEmpty) {
        username = _user!.username!;
      }
      if (_user!.className != null && _user!.className!.isNotEmpty) {
        className = _user!.className!;
      }
      if (_user!.studentID != null && _user!.studentID!.isNotEmpty) {
        studentID = _user!.studentID!;
      }
      if (_user!.phoneNumber != null && _user!.phoneNumber!.isNotEmpty) {
        phoneNumber = _user!.phoneNumber!;
      }
      if (_user!.email.isNotEmpty) {
        email = _user!.email;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  refresh() async {
    print('refresh');
    if (_user != null) {
      QuerySnapshot<Map<String, dynamic>> fetchUser =
          await FirebaseFirestore.instance
              .collection('users')
              .where(
                'uuid',
                isEqualTo: widget.user!.uuid,
              )
              .get();
      UserModel _u = UserModel.fromSnap(fetchUser.docs.toList().first);
      _user = _u;
      setState(() {
        initInform();
      });
    }
  }

  editProfile() async {
    if (_user != null) {
      String? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditProfilePage(
              user: _user!,
            );
          },
        ),
      );
      if (result == 'success') {
        refresh();
      }
    }
  }

  logInOrOut() async {
    if (_user != null) {
      String res = await Messenger.dialog(
        '您要登出嗎？',
        '要確定ㄟ',
        context,
      );
      if (res == "success") {
        await AuthMethods().signOut();
        // ignore: use_build_context_synchronously
        bool? back = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        if (back == true) {
          await Provider.of<AuthMethods>(context, listen: false)
              .getUserDetails();
        }
      }
    } else {
      bool? back = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      if (back == true) {
        await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
      }
    }
  }

  deleteAccount() async {
    String res = await Messenger.dialog(
      '確定要刪除帳號嗎！',
      '一旦刪除後便永久無法復原！',
      context,
    );
    if (res == "success") {
      await AuthMethods().deleteUser();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: appBarColor,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: MySliverDelegate(
                minHeight: Dimensions.height5 * 35,
                maxHeight: Dimensions.height5 * 35,
                child: firstContainer(),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          displacement: Dimensions.height5 * 3,
          backgroundColor: onPrimary,
          color: onSecondary,
          onRefresh: () async {
            refresh();
          },
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: Dimensions.height5 * 4),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 0.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            scnContainer(
                              0,
                              "0",
                            ),
                            SizedBox(width: 16),
                            scnContainer(
                              1,
                              '${countTime.toString()} 次',
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        widget.user != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: BoldText(
                                                  color: onSecondary,
                                                  size: Dimensions.height2 * 8,
                                                  text: "$username / 個人資料",
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  editProfile();
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(
                                            thickness: 1, color: Colors.grey),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            profileRow("學校：中原大學"),
                                            profileRow("系級：$className"),
                                            profileRow("學號：$studentID"),
                                            profileRow("連絡電話：$phoneNumber"),
                                            profileRow("電子郵件：$email"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 16),
                        widget.user != null
                            ? Container(
                                // height: Dimensions.width2 * 85,
                                decoration: BoxDecoration(
                                  color: scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          child: BoldText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 8,
                                            text: "常用功能",
                                          ),
                                        ),
                                        Divider(
                                            thickness: 1, color: Colors.grey),
                                        Column(
                                          children: [
                                            funcBtn(
                                              () => editProfile(),
                                              Icons.edit_note_outlined,
                                              "編輯個人資料",
                                            ),
                                            funcBtn(
                                              () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return PrivacyPage();
                                                    },
                                                  ),
                                                );
                                              },
                                              Icons.library_books_outlined,
                                              "隱私條約",
                                            ),
                                            funcBtn(
                                              () {
                                                logInOrOut();
                                              },
                                              _user == null
                                                  ? Icons.login
                                                  : Icons.logout,
                                              _user == null ? "登入" : '登出',
                                            ),
                                            if (_user != null)
                                              funcBtn(
                                                () async {
                                                  await deleteAccount();
                                                },
                                                Icons.key_off,
                                                "註銷帳號",
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 16),
                        widget.user == null
                            ? Container(
                                // height: Dimensions.width2 * 85,
                                decoration: BoxDecoration(
                                  color: scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: RegularText(
                                                  color: onSecondary,
                                                  size: Dimensions.height2 * 7,
                                                  text: "歡迎登入，查看更多資訊",
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  logInOrOut();
                                                },
                                                child: MediumText(
                                                  color: onSecondary,
                                                  size: Dimensions.height2 * 8,
                                                  text: _user == null
                                                      ? "登入"
                                                      : "登出",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget funcBtn(
    Function() onPressed,
    IconData iconData,
    String str,
  ) {
    Color hintColor = Theme.of(context).hintColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return MaterialButton(
      onPressed: () => onPressed(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 30,
              color: hintColor,
            ),
            SizedBox(width: 10),
            RegularText(
              color: onSecondary,
              size: Dimensions.height2 * 7,
              text: str,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileRow(str) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Flexible(
                child: RegularText(
                  color: onSecondary,
                  size: Dimensions.height2 * 7,
                  text: str,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scnContainer(int index, String str) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Expanded(
      child: Container(
        // width: Dimensions.width2 * 20,
        decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MediumText(
              color: onSecondary,
              size: Dimensions.height2 * 7,
              text: index == 0 ? "UPoints" : "活動紀錄",
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                index == 0
                    ? Image.asset(
                        "assets/Upoint.png",
                        width: Dimensions.width2 * 10,
                      )
                    : Container(),
                SizedBox(width: index == 0 ? 8 : 0),
                BoldText(
                  color: onSecondary,
                  size: Dimensions.height2 * 9,
                  text: str,
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget firstContainer() {
    Color hintColor = Theme.of(context).hintColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            height: Dimensions.height2 * 85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFD396), hintColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.14),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
          ),
        ),
        ProfilePic(
          picUri: widget.user != null
              ? widget.user!.pic ?? defaultUserPic
              : defaultUserPic,
          id: widget.user != null ? widget.user!.uuid : '',
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => (maxHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
