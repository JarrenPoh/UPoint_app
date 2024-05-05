import 'package:flutter/material.dart';
import 'package:upoint/bloc/tab_type_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/ad_layout.dart';
import 'package:upoint/widgets/home/post_card.dart';
import '../../models/ad_model.dart';
import 'tab_type_body_filter.dart';

class TabTypeBody extends StatefulWidget {
  final int index;
  final UserModel? user;
  final List<PostModel> allPost;
  final List<AdModel> allAd;
  const TabTypeBody({
    super.key,
    required this.index,
    required this.user,
    required this.allPost,
    required this.allAd,
  });

  @override
  State<TabTypeBody> createState() => _TabTypeBodyState();
}

class _TabTypeBodyState extends State<TabTypeBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late TabTypeBloc _bloc = TabTypeBloc(widget.allPost);

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
        controller: CustomScrollProviderData.of(context)
            .scrollControllers[widget.index],
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          AdLayout(allAd: widget.allAd, bloc: _bloc),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width5 * 2,
              ),
              child: Column(
                children: [
                  // 篩選
                  TabTypeBodyFilter(
                    bloc: _bloc,
                  ),
                  //文章
                  ValueListenableBuilder(
                    valueListenable: _bloc.postListNotifier,
                    builder:
                        (BuildContext context, dynamic value, Widget? child) {
                      value as List;
                      List<PostModel> postList = _bloc.postListNotifier.value;
                      return postList.isEmpty
                          ? Column(
                              children: [
                                SizedBox(height: Dimensions.height5 * 16),
                                Center(
                                  child: MediumText(
                                    color: cColor.grey500,
                                    size: Dimensions.height2 * 8,
                                    text: "No Result.",
                                  ),
                                ),
                                SizedBox(height: Dimensions.height5 * 200),
                              ],
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
                                        "type${postList[index].datePublished.toString()}",
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
        ],
      // ),
    );
  }

  // Widget organizerContainer(
  //   List<OrganizerModel> organList,
  //   int index,
  //   Function() filterFunc,
  //   Map<String, ValueNotifier<int>> postLengthFromOrgan,
  // ) {
  //   Color onSecondary = Theme.of(context).colorScheme.onSecondary;
  //   Color hintColor = Theme.of(context).hintColor;
  //   return Column(
  //     children: [
  //       PromoCard(
  //         index: index,
  //         imageUrl: index == 0 ? '' : organList[index - 1].pic,
  //         aspectRatio: 1 / 1,
  //         selectedNotifier: widget.bloc.selectedOrganizerNotifier,
  //         filterFunc: filterFunc,
  //       ),
  //       SizedBox(height: Dimensions.height5),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           MediumText(
  //             color: onSecondary,
  //             size: Dimensions.height2 * 6,
  //             text: index == 0 ? '全部' : organList[index - 1].username,
  //           ),
  //           SizedBox(width: Dimensions.width2),
  //           postLengthFromOrgan['all'] == null
  //               ? MediumText(
  //                   color: hintColor,
  //                   size: Dimensions.height2 * 6,
  //                   text: '0',
  //                 )
  //               : ValueListenableBuilder(
  //                   valueListenable: index == 0
  //                       ? postLengthFromOrgan['all']!
  //                       : postLengthFromOrgan[organList[index - 1].uid]!,
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
