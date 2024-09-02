// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late final ProfilePageBloc _bloc = ProfilePageBloc(widget.user);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);
    return Scaffold(
      backgroundColor: cColor.div,
      appBar: AppBar(
        backgroundColor: cColor.primary,
        title: const MediumText(
          color: Colors.white,
          size: 16,
          text: "會員中心",
        ),
      ),
      body: RefreshIndicator(
        displacement: Dimensions.height5 * 3,
        backgroundColor: cColor.white,
        color: cColor.black,
        onRefresh: () async {
          _bloc.refresh(context);
        },
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height2 * 6,
            horizontal: Dimensions.width2 * 8,
          ),
          children: [
            // 第一排 - 個人簡介
            Container(
              height: Dimensions.height2 * 60,
              padding: EdgeInsets.all(Dimensions.height2 * 8),
              decoration: BoxDecoration(
                color: cColor.card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ProfilePic(user:widget.user),
                  SizedBox(width: Dimensions.width2 * 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MediumText(
                        color: cColor.grey500,
                        size: 16,
                        text: "Hi~ ${widget.user?.username??"訪客"}",
                      ),
                      MediumText(
                          color: cColor.grey500,
                          size: 12,
                          text: widget.user?.email ?? "尚未登入"),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _bloc.editProfile(context),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height2 * 2,
                                horizontal: Dimensions.width2 * 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: cColor.primary,
                              ),
                              child: const MediumText(
                                color: Colors.white,
                                size: 12,
                                text: "設定自動帶入資料",
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.width5),
                          const CustomToolTip(text: "報名時自動填入"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 第二排 - UPoints和活動紀錄
            Row(
              children: [
                scnContainer(0, "0"),
                SizedBox(width: Dimensions.width2 * 8),
                scnContainer(1, '${widget.user?.signList?.length ?? 0} 次'),
              ],
            ),
            const SizedBox(height: 12),
            // 常用功能
            if (widget.user != null)
              Column(
                children: [
                  _block(
                    "常用功能",
                    _bloc.commonUseList(context, widget.user!),
                  ),
                  const SizedBox(height: 12),
                  _block(
                    "帳號管理",
                    _bloc.accountList(context, widget.user!),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            // 沒登入的畫面
            if (widget.user == null)
              Container(
                // height: Dimensions.width2 * 85,
                decoration: BoxDecoration(
                  color: cColor.card,
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
                                  _bloc.logInOrOut(context);
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
    );
  }

  Widget _block(String title, List list) {
    CColor cColor = CColor.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height2 * 4),
      decoration: BoxDecoration(
        color: cColor.card,
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
          // 標題
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height2 * 6,
              horizontal: Dimensions.width2 * 8,
            ),
            child: MediumText(
              color: cColor.grey500,
              size: 14,
              text: "常用功能",
            ),
          ),
          // 內容
          Column(
            children: List.generate(
              list.length,
              (index) {
                return rowArea(
                  icon: list[index]["icon"],
                  title: list[index]["title"],
                  onTap: list[index]["onTap"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rowArea({
    required Widget icon,
    required String title,
    required Function onTap,
  }) {
    CColor cColor = CColor.of(context);
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height2 * 6,
        ),
        child: Row(
          children: [
            SizedBox(width: Dimensions.width2 * 12),
            icon,
            SizedBox(width: Dimensions.width2 * 4),
            MediumText(
              color: cColor.grey500,
              size: Dimensions.height2 * 7,
              text: title,
            ),
          ],
        ),
      ),
    );
  }

  Widget scnContainer(int index, String str) {
    CColor cColor = CColor.of(context);
    return Expanded(
      child: Container(
        // width: Dimensions.width2 * 20,
        decoration: BoxDecoration(
          color: cColor.card,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
