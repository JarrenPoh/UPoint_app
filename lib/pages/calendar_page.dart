import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upoint/bloc/calendar_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/pages/post_detail_page.dart';
import 'package:upoint/widgets/calendar/calendar_table.dart';
import '../bloc/post_fetch_bloc.dart';
import '../firebase/auth_methods.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    return Consumer<PostFetchBloc>(builder: (context, postNotifier, child) {
      final CalendarBloc bloc = CalendarBloc(p: postNotifier.post);
      return Scaffold(
        backgroundColor: cColor.div,
        appBar: AppBar(
          iconTheme: IconThemeData(color: cColor.grey500, size: 20),
          backgroundColor: cColor.white,
          title: MediumText(
            color: cColor.grey500,
            size: 16,
            text: "活動行事曆",
          ),
        ),
        body: Consumer<AuthMethods>(builder: (context, userNotifier, child) {
          UserModel? user = userNotifier.user;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width2 * 4),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // 顏色說明
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              instuc(
                                title: "追蹤中",
                                color: const Color(0xFFFF7D7D),
                              ),
                              SizedBox(width: Dimensions.width2 * 8),
                              instuc(
                                title: "未報名",
                                color: const Color(0xFF4EB7FF),
                              ),
                              SizedBox(width: Dimensions.width2 * 8),
                              instuc(
                                title: "已報名",
                                color: const Color(0xFF80CE88),
                              ),
                            ],
                          ),
                        ),
                        // 行事曆
                        CalendarTable(bloc: bloc, user: user),
                      ],
                    ),
                  ),
                ];
              },
              body: ValueListenableBuilder(
                valueListenable: bloc.bodyListNotifier,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return Center(
                      child: MediumText(
                        color: cColor.grey500,
                        size: 14,
                        text: "No Result.",
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width2 * 4,
                      vertical: Dimensions.height2 * 6,
                    ),
                    child: ListView(
                      children: List.generate(
                        value.length,
                        (index) {
                          PostModel post = value[index];
                          Color color = const Color(0xFF4EB7FF);
                          if (user != null) {
                            if (user.signList?.contains(post.postId) ?? false) {
                              // 已報名
                              color = const Color(0xFF80CE88);
                            } else if (user.followings
                                    ?.contains(post.organizerUid) ??
                                false) {
                              color = const Color(0xFFFF7D7D);
                            }
                          }
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PostDetailPage(
                                        post: value[index],
                                        hero:
                                            "post from calendar${DateTime.now()}",
                                      );
                                    },
                                  ),
                                ),
                                child: Container(
                                  width: Dimensions.screenWidth,
                                  height: Dimensions.height2 * 30,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height2 * 6,
                                    horizontal: Dimensions.width2 * 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: color),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      MediumText(
                                        color: color,
                                        size: 14,
                                        text: value[index].title ?? "",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimensions.height2 * 4),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      );
    });
  }

  Widget instuc({required String title, required Color color}) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
        ),
        SizedBox(width: Dimensions.width2 * 2),
        MediumText(
          color: color,
          size: 14,
          text: title,
        ),
      ],
    );
  }
}
