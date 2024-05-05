import 'package:flutter/material.dart';
import 'package:upoint/bloc/tab_reward_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/tab_reward_body_filter.dart';
import '../../models/ad_model.dart';
import 'ad_layout.dart';

class TabRewardBody extends StatefulWidget {
  final int index;
  final List<PostModel> allPost;
  final UserModel? user;
  final List<AdModel> allAd;
  const TabRewardBody({
    super.key,
    required this.index,
    required this.allPost,
    required this.user,
    required this.allAd,
  });

  @override
  State<TabRewardBody> createState() => _TabRewardBodyState();
}

class _TabRewardBodyState extends State<TabRewardBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late TabRewardBloc _bloc = TabRewardBloc(widget.allPost);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);
    // return RefreshIndicator(
    //   displacement: Dimensions.height5 * 14,
    //   backgroundColor: cColor.white,
    //   color: cColor.black,
    //   onRefresh: () async {
    //     // await widget.bloc.refreshBody(1);
    //   },
      return CustomScrollView(
        controller: CustomScrollProviderData.of(context)
            .scrollControllers[widget.index],
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          // 廣告版位
          AdLayout(allAd: widget.allAd, bloc: _bloc),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 篩選
                TabRewardBodyFilter(
                  bloc: _bloc,
                ),
                //文章Ｆ
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                  child: ValueListenableBuilder(
                    valueListenable: _bloc.postListNotifier,
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      value as List;
                      List<PostModel> postList = _bloc.postListNotifier.value;
                      return postList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: Dimensions.height5 * 16),
                                  MediumText(
                                    color: cColor.grey500,
                                    size: Dimensions.height2 * 8,
                                    text: "No Result.",
                                  ),
                                ],
                              ),
                            )
                          : GridView.custom(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: Dimensions.height2 * 4,
                                childAspectRatio: 172 / 210,
                                crossAxisSpacing: Dimensions.width2 * 4,
                              ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return PostCard(
                                    post: postList[index],
                                    organizer: null,
                                    hero:
                                        "reward${widget.allPost[index].postId}",
                                    isOrganizer: false,
                                    user: widget.user,
                                  );
                                },
                                childCount: postList.length, // 10个网格项
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      // ),
    );
  }

  // Widget reWardTagContainer(
  //   List<RewardTagModel> rewardTagList,
  //   int index,
  //   Function() filterFunc,
  //   Map<String, ValueNotifier<int>> postLengthFromReward,
  // ) {
  //   Color onSecondary = Theme.of(context).colorScheme.onSecondary;
  //   Color hintColor = Theme.of(context).hintColor;
  //   return Column(
  //     children: [
  //       PromoCard(
  //         index: index,
  //         imageUrl: index == 0 ? '' : rewardTagList[index - 1].pic,
  //         aspectRatio: 1 / 1,
  //         selectedNotifier: widget.bloc.selectedRewardTagNotifier,
  //         filterFunc: filterFunc,
  //       ),
  //       SizedBox(height: Dimensions.height5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           MediumText(
  //             color: onSecondary,
  //             size: Dimensions.height2 * 6,
  //             text: index == 0 ? '全部' : rewardTagList[index - 1].name,
  //           ),
  //           SizedBox(width: Dimensions.width2),
  //           postLengthFromReward['all'] == null
  //               ? MediumText(
  //                   color: hintColor,
  //                   size: Dimensions.height2 * 6,
  //                   text: '0',
  //                 )
  //               : ValueListenableBuilder(
  //                   valueListenable: index == 0
  //                       ? postLengthFromReward['all']!
  //                       : postLengthFromReward[rewardTagList[index - 1].id]!,
  //                   builder: (
  //                     context,
  //                     dynamic value,
  //                     Widget? child,
  //                   ) {
  //                     return MediumText(
  //                       color: hintColor,
  //                       size: Dimensions.height2 * 6,
  //                       text: value.toString(),
  //                     );
  //                   },
  //                 )
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
