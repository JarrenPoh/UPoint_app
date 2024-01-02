// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   backgroundColor:  hintColor,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: Dimensions.height2 * 70,
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
                  Positioned(
                    bottom: 10,
                    child: Stack(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: Dimensions.width2 * 42,
                              height: Dimensions.width2 * 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                            ),
                            ClipOval(
                              child: Image.asset(
                                'assets/profile.png',
                                width: Dimensions.width2 * 38,
                                height: Dimensions.width2 * 38,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: Dimensions.width2 * 44,
                                    color: Colors.grey[600],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          right: Dimensions.width2 * 1,
                          bottom: Dimensions.width2 * 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: Dimensions.width2 * 11,
                                height: Dimensions.width2 * 11,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 3,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                size: Dimensions.width2 * 7,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            // width: Dimensions.width2 * 20,
                            decoration: BoxDecoration(
                              color: appBarColor,
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
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MediumText(
                                        color: onSecondary,
                                        size: 14,
                                        text: "UPoints"),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/coin.png",
                                          width: Dimensions.width2 * 10,
                                        ),
                                        SizedBox(width: 8),
                                        BoldText(
                                            color: onSecondary,
                                            size: 18,
                                            text: "1,800"),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            // width: Dimensions.width2 * 20,
                            decoration: BoxDecoration(
                              color: appBarColor,
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
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MediumText(
                                        color: onSecondary,
                                        size: 14,
                                        text: "活動記錄"),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        BoldText(
                                            color: onSecondary,
                                            size: 18,
                                            text: "18 次"),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      // height: Dimensions.width2 * 85,
                      decoration: BoxDecoration(
                        color: appBarColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: BoldText(
                                            color: onSecondary,
                                            size: 16,
                                            text: "Hi~ XXX / 個人資料",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    )),
                                Divider(thickness: 1, color: Colors.grey),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "學校：中原大學",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "院系：商學院 資訊管理學系",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "班級：資管三乙",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "學號：110442xx",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "連絡電話：0912123456",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          RegularText(
                                            color: onSecondary,
                                            size: Dimensions.height2 * 7,
                                            text: "電子郵件：upoint@gmail.com",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      // height: Dimensions.width2 * 85,
                      decoration: BoxDecoration(
                        color: appBarColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: BoldText(
                                    color: onSecondary,
                                    size: 16,
                                    text: "常用功能",
                                  ),
                                ),
                                Divider(thickness: 1, color: Colors.grey),
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit_note_outlined,
                                                size: 30,
                                                color: hintColor,
                                              ),
                                              SizedBox(width: 10),
                                              RegularText(
                                                color: onSecondary,
                                                size: Dimensions.height2 * 7,
                                                text: "編輯個人資料",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.settings_outlined,
                                                size: 30,
                                                color: hintColor,
                                              ),
                                              SizedBox(width: 10),
                                              RegularText(
                                                color: onSecondary,
                                                size: Dimensions.height2 * 7,
                                                text: "設定",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                size: 30,
                                                color: hintColor,
                                              ),
                                              SizedBox(width: 10),
                                              RegularText(
                                                color: onSecondary,
                                                size: Dimensions.height2 * 7,
                                                text: "登出",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      // height: Dimensions.width2 * 85,
                      decoration: BoxDecoration(
                        color: appBarColor,
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: RegularText(
                                        color: onSecondary,
                                        size: 14,
                                        text: "歡迎登入，查看更多資訊",
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: MediumText(
                                        color: onSecondary,
                                        size: 16,
                                        text: "登入",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
