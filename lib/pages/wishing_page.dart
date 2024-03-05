import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upoint/bloc/wishing_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/wish_model.dart';
import 'package:upoint/widgets/wish/wishing_card.dart';

import '../firebase/auth_methods.dart';
import '../models/user_model.dart';

class WishingPage extends StatefulWidget {
  const WishingPage({super.key});

  @override
  State<WishingPage> createState() => _WishingPageState();
}

class _WishingPageState extends State<WishingPage> {
  final WishingBloc _bloc = WishingBloc();

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return Scaffold(
      body: Container(
        color: cColor.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: cColor.white,
            body:
                Consumer<AuthMethods>(builder: (context, userNotifier, child) {
              UserModel? user = userNotifier.user;
              return Stack(
                children: [
                  RefreshIndicator(
                    displacement: 30,
                    color: cColor.grey200,
                    onRefresh: () async {
                      await _bloc.onRefresh();
                    },
                    child: SingleChildScrollView(
                      controller: _bloc.scrollController,
                      child: Column(
                        children: [
                          // 圖片
                          Container(
                            height: Dimensions.height5 * 42,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  _bloc.img,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height2 * 12),
                          // UPoint 功能許願池
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width2 * 6,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: Dimensions.width2 * 4,
                                      height: Dimensions.height2 * 11,
                                      color: cColor.primary,
                                    ),
                                    SizedBox(width: Dimensions.width2 * 6),
                                    BoldText(
                                      color: cColor.grey500,
                                      size: Dimensions.height2 * 8,
                                      text: "UPoint 功能許願池",
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.height5 * 3),
                                // 卡片
                                ValueListenableBuilder(
                                  valueListenable: _bloc.wishNotifier,
                                  builder: (context, value, child) {
                                    List<WishModel> post = value["post"];
                                    bool noMore = value["noMore"];
                                    if (post.isEmpty) {
                                      return CircularProgressIndicator.adaptive(
                                        backgroundColor: cColor.grey500,
                                      );
                                    }
                                    return Column(
                                      children: List.generate(
                                        post.length + 1,
                                        (index) {
                                          if (index == post.length) {
                                            return SizedBox(
                                              height: Dimensions.height5 * 10,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  if (noMore)
                                                    MediumText(
                                                      color: cColor.grey500,
                                                      size: Dimensions.height2 *
                                                          7,
                                                      text: "No More.",
                                                    ),
                                                  if (!noMore)
                                                    CircularProgressIndicator
                                                        .adaptive(
                                                      backgroundColor:
                                                          cColor.grey500,
                                                    )
                                                ],
                                              ),
                                            );
                                          }
                                          return WishingCard(
                                            wish: post[index],
                                            user: user,
                                            bloc: _bloc,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: Dimensions.height5 * 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 返回箭頭
                  Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height5 * 1,
                      left: Dimensions.width5 * 2,
                      right: Dimensions.width5 * 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Dimensions.height5 * 8,
                          height: Dimensions.height5 * 8,
                          decoration: BoxDecoration(
                            color: cColor.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.chevron_left,
                              color: cColor.black,
                              size: Dimensions.height2 * 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 我要許願
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimensions.height2 * 18,
                          width: Dimensions.width2 * 52,
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            borderRadius: BorderRadius.circular(5),
                            color: cColor.primary,
                            child: Center(
                              child: MediumText(
                                color: Colors.white,
                                size: Dimensions.height2 * 7,
                                text: "我要許願",
                              ),
                            ),
                            onPressed: () => _bloc.tabWish(context, user),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
