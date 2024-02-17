import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/reward_tag_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/promo_card.dart';

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
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    return RefreshIndicator(
      displacement: Dimensions.height5 * 3,
      backgroundColor: onPrimary,
      color: onSecondary,
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
              color: scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width5 * 1.5,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height5 * 2),
                        Row(
                          children: [
                            BoldText(
                              color: onSecondary,
                              size: Dimensions.height2 * 9.5,
                              text: '獎勵',
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height5 * 3),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.rewardTagListNotifier,
                          builder: (
                            BuildContext context,
                            dynamic value,
                            Widget? child,
                          ) {
                            value as List;
                            List<RewardTagModel> rewardTagList = widget.bloc.rewardTagListNotifier.value;
                            return SizedBox(
                              height: Dimensions.height5 * 50,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: Dimensions.height5 * 2,
                                  mainAxisSpacing: Dimensions.width5 * 6,
                                  childAspectRatio: 1.3,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  rewardTagList.length + 1,
                                  (index) {
                                    return reWardTagContainer(
                                      rewardTagList,
                                      index,
                                      () {
                                        if (index == 0) {
                                          widget.bloc.filterOriginList(1);
                                        } else {
                                          widget.bloc.filterPostsByReward(
                                            rewardTagList[index - 1].id,
                                          );
                                        }
                                      },
                                      widget.bloc.postLengthFromReward,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height5 * 6),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoldText(
                          color: onSecondary,
                          size: Dimensions.height2 * 9.5,
                          text: '活動',
                        ),
                        SizedBox(height: Dimensions.height5 * 1),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.postList2Notifier,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            value as List;
                            List<PostModel> postList =  widget.bloc.postList2Notifier.value;
                            return postList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: Dimensions.height5 * 16),
                                        MediumText(
                                          color: onSecondary,
                                          size: Dimensions.height2 * 8,
                                          text: "還沒有創建過貼文",
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: List.generate(
                                      postList.length,
                                      (index) {
                                        return PostCard(
                                          post: postList[index],
                                          organizer: null,
                                          hero:
                                              "reward${postList[index].datePublished.toString()}",
                                          isOrganizer: false,
                                          user: widget.user,
                                        );
                                      },
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
