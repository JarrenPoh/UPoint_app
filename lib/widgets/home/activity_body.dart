import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/promo_card.dart';

class ActivityBody extends StatefulWidget {
  final int index;
  final HomePageBloc bloc;
  final User? user;
  const ActivityBody({
    super.key,
    required this.index,
    required this.bloc,
    required this.user,
  });

  @override
  State<ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<ActivityBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    // Color hintColor = Theme.of(context).hintColor;

    return RefreshIndicator(
      displacement: Dimensions.height5 * 3,
      backgroundColor: onPrimary,
      color: onSecondary,
      onRefresh: () async {
        await widget.bloc.refreshBody(0);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BoldText(
                              color: onSecondary,
                              size: Dimensions.height2 * 9.5,
                              text: '主辦方',
                            ),
                            // Text(
                            //   'see all ',
                            //   style: TextStyle(
                            //     color: hintColor,
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height5 * 3),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.organListNotifier,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            value as List;
                            List<OrganModel> organList = [];
                            value.forEach((e) {
                              organList.add(
                                OrganModel.fromSnap(e),
                              );
                            });
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
                                  organList.length + 1,
                                  (index) {
                                    return organizerContainer(
                                      organList,
                                      index,
                                      () {
                                        if (index == 0) {
                                          widget.bloc.filterOriginList(0);
                                        } else {
                                          widget.bloc.filterPostsByOrganizer(
                                            organList[index - 1].uid,
                                          );
                                        }
                                      },
                                      widget.bloc.postLengthFromOrgan,
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
                          text: '近期活動',
                        ),
                        SizedBox(height: Dimensions.height5 * 1),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.postListNotifier,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            value as List;
                            List<PostModel> postList = [];
                            value.forEach((e) {
                              postList.add(
                                PostModel.fromSnap(e),
                              );
                            });
                            return postList.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: Dimensions.height5 * 16),
                                      Center(
                                        child: MediumText(
                                          color: onSecondary,
                                          size: Dimensions.height2 * 8,
                                          text: "還沒有創建過貼文",
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: List.generate(
                                      postList.length,
                                      (index) {
                                        return PostCard(
                                          post: postList[index],
                                          organizer: null,
                                          hero:
                                              "activity${postList[index].datePublished.toString()}",
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

  Widget organizerContainer(
    List<OrganModel> organList,
    int index,
    Function() filterFunc,
    Map<String, ValueNotifier<int>> postLengthFromOrgan,
  ) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;
    return Column(
      children: [
        PromoCard(
          index: index,
          imageUrl: index == 0 ? '' : organList[index - 1].pic,
          aspectRatio: 1 / 1,
          selectedNotifier: widget.bloc.selectedOrganizerNotifier,
          filterFunc: filterFunc,
        ),
        SizedBox(height: Dimensions.height5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediumText(
              color: onSecondary,
              size: Dimensions.height2 * 6,
              text: index == 0 ? '全部' : organList[index - 1].organizerName,
            ),
            SizedBox(width: Dimensions.width2),
            postLengthFromOrgan['all'] == null
                ? MediumText(
                    color: hintColor,
                    size: Dimensions.height2 * 6,
                    text: '0',
                  )
                : ValueListenableBuilder(
                    valueListenable: index == 0
                        ? postLengthFromOrgan['all']!
                        : postLengthFromOrgan[organList[index - 1].uid]!,
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
