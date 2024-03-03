import 'package:flutter/material.dart';
import 'package:upoint/bloc/tab_organizer_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/ad_layout.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/tab_organizer_body_filter.dart';
import '../../models/ad_model.dart';

class TabOrganizerBody extends StatefulWidget {
  final int index;
  final UserModel? user;
  final List<PostModel> allPost;
  final List<AdModel> allAd;
  const TabOrganizerBody({
    super.key,
    required this.index,
    required this.user,
    required this.allPost,
    required this.allAd,
  });

  @override
  State<TabOrganizerBody> createState() => _TabOrganizerBodyState();
}

class _TabOrganizerBodyState extends State<TabOrganizerBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late TabOrganizerBloc _bloc = TabOrganizerBloc(widget.allPost);

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
            child: Column(
              children: [
                // 篩選
                TabOrganizerBodyFilter(
                  bloc: _bloc,
                ),
                //文章
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
                              ],
                            )
                          : GridView.custom(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: Dimensions.height2 * 4,
                                childAspectRatio: 172 / 190,
                                crossAxisSpacing: Dimensions.width2 * 4,
                              ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return PostCard(
                                    post: postList[index],
                                    organizer: null,
                                    hero:
                                        "organizer${postList[index].datePublished.toString()}",
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
}
