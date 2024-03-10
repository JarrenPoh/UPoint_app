// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:upoint/bloc/profile_page_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/custom_tooltip.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/profile/profile_pic.dart';

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
  ProfilePageBloc _bloc = ProfilePageBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.initInform(widget.user);
    super.build(context);
    CColor cColor = CColor.of(context);
    return Scaffold(
      backgroundColor: cColor.div,
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
          backgroundColor: cColor.white,
          color: cColor.black,
          onRefresh: () async {
            _bloc.refresh(widget.user, context);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height5 * 4,
              horizontal: Dimensions.width2 * 12,
            ),
            children: [
              Row(
                children: [
                  // Upoints coin
                  scnContainer(0, "915"),
                  SizedBox(width: Dimensions.width2 * 8),
                  ValueListenableBuilder(
                    valueListenable: _bloc.countNotifier,
                    builder: (context, value, child) {
                      return scnContainer(
                        1,
                        '${value.toString()} 次',
                      );
                    },
                  ),
                ],
              ),
              // 表單預留資料
              if (widget.user != null)
                _block(
                  "表單預填資料",
                  ValueListenableBuilder(
                    valueListenable: _bloc.personNotifier,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          value.length,
                          (index) {
                            return profileRow(
                                '${value[index]["title"]}：${value[index]["value"]}');
                          },
                        ),
                      );
                    },
                  ),
                ),
              // 常用功能
              if (widget.user != null)
                _block(
                  "常用功能",
                  Column(
                    children: List.generate(
                      _bloc.commonUseList(context, widget.user!).length,
                      (index) {
                        return InkWell(
                          onTap: _bloc.commonUseList(
                            context,
                            widget.user!,
                          )[index]["onTap"],
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width2 * 8,
                              vertical: Dimensions.height2 * 4,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: Dimensions.width2 * 5),
                                _bloc.commonUseList(
                                    context, widget.user!)[index]["icon"],
                                SizedBox(width: Dimensions.width5 * 2),
                                RegularText(
                                  color: cColor.grey500,
                                  size: Dimensions.height2 * 7,
                                  text: _bloc.commonUseList(
                                    context,
                                    widget.user!,
                                  )[index]["title"],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // 沒登入的畫面
              if (widget.user == null)
                Container(
                  // height: Dimensions.width2 * 85,
                  decoration: BoxDecoration(
                    color: cColor.white,
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
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RegularText(
                                    color: cColor.grey500,
                                    size: Dimensions.height2 * 7,
                                    text: "歡迎登入，查看更多資訊",
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    _bloc.logInOrOut(widget.user, context);
                                  },
                                  child: MediumText(
                                    color: cColor.grey500,
                                    size: Dimensions.height2 * 8,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _block(String title, Widget child) {
    CColor cColor = CColor.of(context);
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height2 * 8),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height2 * 4),
      decoration: BoxDecoration(
        color: cColor.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height2 * 4,
              horizontal: Dimensions.width2 * 8,
            ),
            child: title == "表單預填資料"
                ? Row(
                    children: [
                      BoldText(
                        color: cColor.grey500,
                        size: Dimensions.height2 * 8,
                        text: title,
                      ),
                      SizedBox(width: Dimensions.width5 * 2),
                      const CustomToolTip(text: "表單預填資料在您填寫報名表單時會自動帶入資料"),
                      const Expanded(child: Column(children: [])),
                      GestureDetector(
                        onTap: () {
                          _bloc.editProfile(widget.user, context);
                        },
                        child: Icon(
                          Icons.edit,
                          color: cColor.grey300,
                          size: Dimensions.height5 * 4,
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      BoldText(
                        color: cColor.grey500,
                        size: Dimensions.height2 * 8,
                        text: title,
                      ),
                    ],
                  ),
          ),
          Divider(thickness: 1, color: cColor.div),
          child,
        ],
      ),
    );
  }

  Widget profileRow(str) {
    CColor cColor = CColor.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width2 * 8,
        vertical: Dimensions.height2 * 4,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: Dimensions.width2 * 5),
              Flexible(
                child: RegularText(
                  color: cColor.grey500,
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
    CColor cColor = CColor.of(context);
    return Expanded(
      child: Container(
        // width: Dimensions.width2 * 20,
        decoration: BoxDecoration(
          color: cColor.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MediumText(
                  color: cColor.grey500,
                  size: Dimensions.height2 * 7,
                  text: index == 0 ? "UPoints" : "活動紀錄",
                ),
                if (index == 0) const CustomToolTip(text: "敬請期待"),
              ],
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
                  color: cColor.grey500,
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
    CColor cColor = CColor.of(context);
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
                colors: [cColor.color, cColor.primary],
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
        ProfilePic(),
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
