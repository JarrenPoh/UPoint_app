import 'package:flutter/material.dart';
import '../../bloc/organizer_fetch_bloc.dart';
import '../../bloc/tab_club_bloc.dart';
import '../../globals/colors.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'filter_club_blody.dart';
import 'post_card.dart';
import 'package:provider/provider.dart';

class TabClubBody extends StatefulWidget {
  final int index;
  final UserModel? user;
  final List<PostModel> allPost;
  const TabClubBody({
    super.key,
    required this.index,
    required this.user,
    required this.allPost,
  });

  @override
  State<TabClubBody> createState() => _TabClubBodyState();
}

class _TabClubBodyState extends State<TabClubBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late final TabClubBloc _bloc = TabClubBloc(
    widget.allPost,
    Provider.of<OrganzierFetchBloc>(context, listen: false).organizerList,
  );
  late CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller:
          CustomScrollProviderData.of(context).scrollControllers[widget.index],
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Divider(color: cColor.grey200, thickness: 1),
              FilterClubBody(bloc: _bloc),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 2,
                  vertical: Dimensions.height2 * 6,
                ),
                child: Column(
                  children: [
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
            ],
          ),
        ),
      ],
      // ),
    );
  }
}
