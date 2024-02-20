import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/reward_tag_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/promo_card.dart';
import 'package:upoint/widgets/home/reward_body_filter.dart';

class RewardBody extends StatefulWidget {
  final int index;
  final HomePageBloc bloc;
  final UserModel? user;
  const RewardBody({
    super.key,
    required this.index,
    required this.bloc,
    required this.user,
  });

  @override
  State<RewardBody> createState() => _RewardBodyState();
}

class _RewardBodyState extends State<RewardBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);
    return RefreshIndicator(
      displacement: Dimensions.height5 * 14,
      backgroundColor: cColor.white,
      color: cColor.black,
      onRefresh: () async {
        await widget.bloc.refreshBody(1);
      },
      child: CustomScrollView(
        controller: CustomScrollProviderData.of(context)
            .scrollControllers[widget.index],
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: cColor.grey100,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 篩選
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Dimensions.height2 * 6,
                      ),
                      decoration: BoxDecoration(
                        color: cColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: widget.bloc.organListNotifier,
                        builder: (context, value, child) {
                          value as List;
                          List<RewardTagModel> rewardList =
                              widget.bloc.rewardTagListNotifier.value;
                          if (rewardList.isEmpty) {
                            return CircularProgressIndicator(
                                color: cColor.black);
                          }
                          String searchText = rewardList.first.name;
                          return RewardBodyFilter(
                            bloc: widget.bloc,
                            rewardList: rewardList,
                            searchText: searchText,
                          );
                        },
                      ),
                    ),
                    //文章Ｆ
                    ValueListenableBuilder(
                      valueListenable: widget.bloc.postList2Notifier,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        value as List;
                        List<PostModel> postList =
                            widget.bloc.postList2Notifier.value;
                        return postList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: Dimensions.height5 * 16),
                                    MediumText(
                                      color: cColor.grey500,
                                      size: Dimensions.height2 * 8,
                                      text: "還沒有創建過貼文",
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
                                  childAspectRatio: 172 / 219,
                                  crossAxisSpacing: Dimensions.width2 * 4,
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return PostCard(
                                      post: postList[index],
                                      organizer: null,
                                      hero:
                                          "activity${postList[index].datePublished.toString()}",
                                      isOrganizer: false,
                                      user: widget.user,
                                    );
                                  },
                                  childCount: postList.length, // 10个网格项
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reWardTagContainer(
    List<RewardTagModel> rewardTagList,
    int index,
    Function() filterFunc,
    Map<String, ValueNotifier<int>> postLengthFromReward,
  ) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;
    return Column(
      children: [
        PromoCard(
          index: index,
          imageUrl: index == 0 ? '' : rewardTagList[index - 1].pic,
          aspectRatio: 1 / 1,
          selectedNotifier: widget.bloc.selectedRewardTagNotifier,
          filterFunc: filterFunc,
        ),
        SizedBox(height: Dimensions.height5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediumText(
              color: onSecondary,
              size: Dimensions.height2 * 6,
              text: index == 0 ? '全部' : rewardTagList[index - 1].name,
            ),
            SizedBox(width: Dimensions.width2),
            postLengthFromReward['all'] == null
                ? MediumText(
                    color: hintColor,
                    size: Dimensions.height2 * 6,
                    text: '0',
                  )
                : ValueListenableBuilder(
                    valueListenable: index == 0
                        ? postLengthFromReward['all']!
                        : postLengthFromReward[rewardTagList[index - 1].id]!,
                    builder: (
                      context,
                      dynamic value,
                      Widget? child,
                    ) {
                      return MediumText(
                        color: hintColor,
                        size: Dimensions.height2 * 6,
                        text: value.toString(),
                      );
                    },
                  )
          ],
        ),
      ],
    );
  }
}
