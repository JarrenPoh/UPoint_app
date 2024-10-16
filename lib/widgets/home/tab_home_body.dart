import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upoint/bloc/tab_home_bloc.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/ad_model.dart';
import 'package:upoint/widgets/home/ad_layout.dart';
import '../../globals/colors.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'post_card.dart';

class TabHomeBody extends StatefulWidget {
  final int index;
  final UserModel? user;
  final List<PostModel> allPost;
  final List<AdModel> allAd;
  const TabHomeBody({
    super.key,
    required this.index,
    required this.user,
    required this.allPost,
    required this.allAd,
  });

  @override
  State<TabHomeBody> createState() => _TabHomeBodyState();
}

class _TabHomeBodyState extends State<TabHomeBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late TagHomeBloc _bloc = TagHomeBloc(widget.allPost);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);
    // return RefreshIndicator(
    //   displacement: Dimensions.height5 * 14,
    //   backgroundColor: cColor.white,
    //   color: cColor.black,
    //   onRefresh: () async {
    //     // await widget.bloc.refreshBody(0);
    //   },
    return CustomScrollView(
      controller:
          CustomScrollProviderData.of(context).scrollControllers[widget.index],
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        // 廣告版位
        AdLayout(allAd: widget.allAd, bloc: _bloc),
        // 功能按鈕
        SliverToBoxAdapter(
          child: Container(
            color: cColor.white,
            height: Dimensions.height5 * 19,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                _bloc.buttonList(context: context, user: widget.user).length,
                (index) {
                  List<Map<dynamic, dynamic>> buttonList =
                      _bloc.buttonList(context: context, user: widget.user);
                  return Row(
                    children: [
                      SizedBox(width: Dimensions.width5 * 4),
                      GestureDetector(
                        onTap: () => buttonList[index]["tap"] == null
                            ? Messenger.toast(context, "尚未開放", "尚未開放，敬請期待")
                            : buttonList[index]["tap"]?.call(),
                        child: SizedBox(
                          width: Dimensions.width5 * 11,
                          child: Column(
                            children: [
                              SizedBox(height: Dimensions.height5 * 2),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: Dimensions.height2 * 20,
                                    width: Dimensions.height2 * 20,
                                    decoration: BoxDecoration(
                                      color: buttonList[index]["color"],
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.height2 * 10,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    color: Colors.white,
                                    width: Dimensions.height2 * 12,
                                    height: Dimensions.height2 * 12,
                                    "${buttonList[index]["icon"]}",
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height5 * 1),
                              MediumText(
                                color: cColor.grey500,
                                size: 11,
                                text: buttonList[index]["title"],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        // 貼文主體
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
            child: Column(
              children: [
                SizedBox(height: Dimensions.height5),
                // UPoint精選
                postBlock(
                  "UPoint精選",
                  _bloc.featuredPostValue,
                  _bloc.moreFeatured,
                ),
                SizedBox(height: Dimensions.height5),
                // UPoint猜你喜歡
                postBlock(
                  "猜你喜歡",
                  _bloc.recommandPostValue,
                  _bloc.moreRecommand,
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // );
  }

  Widget postBlock(
    String title,
    ValueListenable<Map> valueListenable,
    Function searchMore,
  ) {
    CColor cColor = CColor.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: Dimensions.width2 * 4,
              height: Dimensions.height2 * 11,
              color: cColor.primary,
            ),
            SizedBox(width: Dimensions.width2 * 6),
            MediumText(
              color: cColor.grey500,
              size: 18,
              text: title,
            ),
          ],
        ),
        SizedBox(height: Dimensions.height2 * 4),
        ValueListenableBuilder(
          valueListenable: valueListenable,
          builder: (context, value, child) {
            List<PostModel> _postList = value["postList"];
            bool _noMore = value["noMore"];
            return Column(
              children: [
                GridView.custom(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Dimensions.height2 * 4,
                    childAspectRatio: 172 / 210,
                    crossAxisSpacing: Dimensions.width2 * 4,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return PostCard(
                        post: _postList[index],
                        organizer: null,
                        hero: "$title${_postList[index].postId}",
                        isOrganizer: false,
                        user: widget.user,
                      );
                    },
                    childCount: _postList.length,
                  ),
                ),
                if (_noMore == false)
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: Dimensions.height2 * 9),
                    child: SizedBox(
                      height: Dimensions.height2 * 18,
                      child: InkWell(
                        onTap: () => searchMore(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/chevron-double-down.svg",
                              fit: BoxFit.cover,
                            ),
                            MediumText(
                              color: cColor.primary,
                              size: Dimensions.height2 * 7,
                              text: "查看更多",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
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
